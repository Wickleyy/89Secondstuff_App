import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[NotificationService] Background message: ${message.messageId}');
}

class NotificationService extends GetxService {
  static NotificationService get to => Get.find<NotificationService>();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final Rx<String?> fcmToken = Rx<String?>(null);
  final RxBool isInitialized = false.obs;
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxInt unreadCount = 0.obs;

  static const String _channelId = 'channel_thrift_v5';
  static const String _channelName = 'Notifikasi 89SecondStuff';
  static const String _channelDescription = 'Promo, Stok, dan Transaksi';
  static const String _soundFile = 'audio12';

  RealtimeChannel? _promoChannel;
  Future<NotificationService> init() async {
    try {
      await _requestPermissions();
      await _initializeLocalNotifications();
      await _setupFCMHandlers();
      await _getFCMToken();
      await _subscribeToGlobalTopics();
      await _handleTerminatedState();

      _listenToRealtimePromos();

      isInitialized.value = true;
      debugPrint('[NotificationService] Init SUCCESS (V5 + Public Methods) 🚀');
    } catch (e) {
      debugPrint('[NotificationService] Init error: $e');
    }
    return this;
  }

  void _listenToRealtimePromos() {
    try {
      if (!Get.isRegistered<SupabaseService>()) {
        debugPrint("[Realtime] Gagal: SupabaseService belum terdaftar.");
        return;
      }

      final supabase = Get.find<SupabaseService>().client;

      debugPrint(
          "[Realtime] Mencoba berlangganan ke tabel 'notification_history'...");

      if (_promoChannel != null) {
        supabase.removeChannel(_promoChannel!);
      }

      _promoChannel = supabase.channel('public:notification_history');

      _promoChannel!
          .onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'notification_history',
        callback: (payload) {
          final data = payload.newRecord;
          debugPrint("[Realtime] 🔥 DATA BARU DITERIMA: $data");

          showPromoNotification(
            title: data['title'] ?? 'Info Promo',
            message: data['body'] ?? 'Cek aplikasi sekarang!',
            promoCode: data['promo_code'],
          );
        },
      )
          .subscribe((status, error) {
        debugPrint("[Realtime] Status Koneksi: $status");
        if (error != null) debugPrint("[Realtime] Error: $error");
      });
    } catch (e) {
      debugPrint("[Realtime] Exception: $e");
    }
  }

  Future<void> _subscribeToGlobalTopics() async {
    try {
      await _firebaseMessaging.subscribeToTopic('new_drops');
      await _firebaseMessaging.subscribeToTopic('promo');
      await _firebaseMessaging.subscribeToTopic('all_users');
      debugPrint('[Topic] Subscribed to global topics');
    } catch (e) {
      debugPrint('[Topic] Error subscribing: $e');
    }
  }

  Future<void> subscribeToProduct(String productId) async {
    try {
      await _firebaseMessaging.subscribeToTopic('product_$productId');
      debugPrint('[Topic] Subscribed to product_$productId');
    } catch (e) {
      debugPrint('[Topic] Error subscribing product: $e');
    }
  }

  Future<void> unsubscribeFromProduct(String productId) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('product_$productId');
      debugPrint('[Topic] Unsubscribed from product_$productId');
    } catch (e) {
      debugPrint('[Topic] Error unsubscribing: $e');
    }
  }

  Future<void> showNewProductNotification({
    required String productName,
    required double price,
    int? productId,
  }) async {
    final priceFormatted = 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';

    await showNotification(
      title: 'Produk Baru!',
      body: '$productName - $priceFormatted',
      type: 'new_product',
      data: {'product_id': productId?.toString()},
    );
  }

  Future<void> showChatNotification({
    required String senderName,
    required String message,
    String? senderId,
    bool isAdmin = false,
  }) async {
    await showNotification(
      title: 'Pesan dari $senderName',
      body: message.length > 50 ? '${message.substring(0, 50)}...' : message,
      type: isAdmin ? 'admin_chat' : 'chat',
      data: {'sender_id': senderId},
    );
  }

  Future<void> showNewOrderNotification({
    required String orderId,
    required String customerName,
    required double total,
  }) async {
    final totalFormatted = 'Rp ${total.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';

    await showNotification(
      title: 'Pesanan Baru!',
      body: 'Pesanan dari $customerName - $totalFormatted',
      type: 'order_new',
      data: {'order_id': orderId},
    );
  }

  Future<void> showOrderStatusNotification({
    required String orderId,
    required String status,
  }) async {
    String title;
    String body;

    switch (status.toLowerCase()) {
      case 'processing':
        title = 'Pesanan Diproses';
        body = 'Pesanan #$orderId sedang diproses';
        break;
      case 'shipped':
        title = 'Pesanan Dikirim';
        body = 'Pesanan #$orderId sedang dalam perjalanan';
        break;
      case 'delivered':
        title = 'Pesanan Sampai';
        body = 'Pesanan #$orderId telah sampai. Terima kasih!';
        break;
      case 'cancelled':
        title = 'Pesanan Dibatalkan';
        body = 'Pesanan #$orderId telah dibatalkan';
        break;
      default:
        title = 'Update Pesanan';
        body = 'Status pesanan #$orderId: $status';
    }

    await showNotification(
      title: title,
      body: body,
      type: 'order_status',
      data: {'order_id': orderId, 'status': status},
    );
  }

  Future<void> showPaymentSuccessNotification({
    required String orderId,
    required double amount,
  }) async {
    final amountFormatted = 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';

    await showNotification(
      title: 'Pembayaran Berhasil!',
      body: 'Pembayaran $amountFormatted untuk pesanan #$orderId berhasil',
      type: 'payment_success',
      data: {'order_id': orderId},
    );
  }

  Future<void> showCheckoutSuccessNotification({
    required String orderId,
    required int itemCount,
  }) async {
    await showNotification(
      title: 'Checkout Berhasil!',
      body: 'Pesanan #$orderId dengan $itemCount item berhasil dibuat',
      type: 'order_new',
      data: {'order_id': orderId},
    );
  }

  Future<void> showLowStockNotification({
    required String productName,
    required int currentStock,
  }) async {
    String title;
    String body;

    if (currentStock == 0) {
      title = 'Stok Habis!';
      body = 'Produk "$productName" sudah habis. Segera restock!';
    } else {
      title = 'Stok Menipis!';
      body = 'Produk "$productName" tersisa $currentStock item';
    }

    await showNotification(
      title: title,
      body: body,
      type: 'low_stock',
      data: {'product_name': productName, 'stock': currentStock},
    );
  }

  Future<void> showPromoNotification({
    required String title,
    required String message,
    String? promoCode,
  }) async {
    await showNotification(
      title: title,
      body: message,
      type: 'promo',
      data: {'promo_code': promoCode},
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    _addToNotificationList(
      title: title,
      body: body,
      type: type,
      data: data,
    );

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: jsonEncode({...?data, 'type': type}),
    );
  }

  void navigateFromNotification(Map<String, dynamic> data) {
    debugPrint('[Navigasi] Payload Data: $data');
    final type = data['type']?.toString() ?? '';

    if (!Get.isRegistered<NotificationService>()) {
      Future.delayed(const Duration(milliseconds: 500),
          () => navigateFromNotification(data));
      return;
    }

    switch (type) {
      case 'event':
      case 'promo_alert':
        Get.toNamed(AppRoutes.MAIN_NAVIGATION);
        break;
      case 'new_drop':
      case 'new_product':
        Get.toNamed(AppRoutes.MAIN_NAVIGATION);
        break;
      case 'stock_alert':
      case 'cart_alert':
      case 'wishlist_alert':
        Get.toNamed(AppRoutes.CART);
        break;
      case 'order_update':
      case 'order_status':
      case 'order_new':
      case 'payment_success':
        Get.toNamed(AppRoutes.ORDER_HISTORY);
        break;
      case 'chat':
      case 'new_message':
      case 'admin_chat':
        Get.toNamed(AppRoutes.CHAT);
        break;
      case 'low_stock':
        Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST);
        break;
      default:
        Get.toNamed(AppRoutes.MAIN_NAVIGATION);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true);

    await _localNotifications.initialize(
      InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(_soundFile),
          enableVibration: true,
        ),
      );
    }
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
        alert: true, badge: true, sound: true);
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _setupFCMHandlers() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      fcmToken.value = token;
      debugPrint('[NotificationService] FCM Token: $token');
      if (token != null) await _saveFCMTokenToSupabase(token);
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        fcmToken.value = newToken;
        _saveFCMTokenToSupabase(newToken);
      });
    } catch (e) {
      debugPrint('Error getting token: $e');
    }
  }

  Future<void> _saveFCMTokenToSupabase(String token) async {
    try {
      if (!Get.isRegistered<SupabaseService>()) return;
      final supabase = Get.find<SupabaseService>();
      final userId = supabase.currentUser?.id;
      if (userId != null) {
        await supabase.client.from('profiles').update({
          'fcm_token': token,
          'fcm_token_updated_at': DateTime.now().toIso8601String(),
        }).eq('id', userId);
      }
    } catch (e) {
      debugPrint('Error saving token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[NotificationService] Foreground message received');
    _addToNotificationList(
      title: message.notification?.title ?? 'Notifikasi',
      body: message.notification?.body ?? '',
      type: message.data['type'] ?? 'general',
      data: message.data,
    );
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    navigateFromNotification(message.data);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(_soundFile),
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
    );
    const iosDetails =
        DarwinNotificationDetails(presentAlert: true, presentSound: true);

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: jsonEncode(message.data),
    );
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        navigateFromNotification(data);
      } catch (e) {
        debugPrint('Error parsing payload: $e');
      }
    }
  }

  Future<void> _handleTerminatedState() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        navigateFromNotification(initialMessage.data);
      });
    }
  }

  void _addToNotificationList(
      {required String title,
      required String body,
      required String type,
      Map<String, dynamic>? data}) {
    final notification = NotificationItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      data: data,
      createdAt: DateTime.now(),
      isRead: false,
    );
    notifications.insert(0, notification);
    unreadCount.value = notifications.where((n) => !n.isRead).length;
    if (notifications.length > 50) notifications.removeLast();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      unreadCount.value = notifications.where((n) => !n.isRead).length;
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    unreadCount.value = 0;
  }

  void clearAllNotifications() {
    notifications.clear();
    unreadCount.value = 0;
  }

  void removeNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  Future<void> updateTokenAfterLogin() async {
    if (fcmToken.value != null) await _saveFCMTokenToSupabase(fcmToken.value!);
    await _subscribeToGlobalTopics();
  }

  Future<void> removeTokenOnLogout() async {
    if (!Get.isRegistered<SupabaseService>()) return;
    final supabase = Get.find<SupabaseService>();
    final userId = supabase.currentUser?.id;
    if (userId != null) {
      await supabase.client
          .from('profiles')
          .update({'fcm_token': null}).eq('id', userId);
    }
  }

  // ==================== FUNGSI KIRIM CHAT (ADMIN -> USER) ====================

  /// Mengirim notifikasi chat ke SATU user spesifik via FCM Legacy API
  Future<bool> sendTargetedChatNotification({
    required String targetFcmToken, // Token HP User (ambil dari table profiles)
    required String senderName, // Nama Admin
    required String message, // Isi Chat
    required String senderId, // ID Admin (untuk navigasi)
  }) async {
    try {
      // ⚠️ GANTI DENGAN SERVER KEY DARI FIREBASE CONSOLE -> PROJECT SETTINGS -> CLOUD MESSAGING
      // Pastikan "Cloud Messaging API (Legacy)" sudah di-enable di Google Cloud Console
      const String serverKey = 'AAAA...PASTE_SERVER_KEY_DISINI...';

      final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      final Map<String, dynamic> body = {
        "to": targetFcmToken, // Target token spesifik
        "priority": "high",
        "notification": {
          "title": senderName,
          "body": message,
          "sound": "default", // Atau gunakan _soundFile jika ingin custom sound
        },
        // Payload DATA ini penting agar navigateFromNotification bekerja
        "data": {
          "type": "chat",
          "sender_id": senderId,
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        }
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$serverKey",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('[FCM] Notifikasi Chat berhasil dikirim ke $targetFcmToken');
        return true;
      } else {
        debugPrint(
            '[FCM] Gagal kirim: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[FCM] Error sending chat: $e');
      return false;
    }
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem(
      {required this.id,
      required this.title,
      required this.body,
      required this.type,
      this.data,
      required this.createdAt,
      this.isRead = false});

  NotificationItem copyWith(
      {String? id,
      String? title,
      String? body,
      String? type,
      Map<String, dynamic>? data,
      DateTime? createdAt,
      bool? isRead}) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case 'new_product':
        return Icons.shopping_bag;
      case 'chat':
      case 'new_message':
      case 'admin_chat':
        return Icons.chat_bubble;
      case 'order_new':
      case 'order_status':
        return Icons.local_shipping;
      case 'payment_success':
        return Icons.payment;
      case 'promo':
      case 'winter_event':
        return Icons.discount;
      case 'stock_alert':
        return Icons.warning;
      default:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'new_product':
        return Colors.blue;
      case 'chat':
      case 'new_message':
      case 'admin_chat':
        return Colors.green;
      case 'order_new':
      case 'order_status':
        return Colors.orange;
      case 'payment_success':
        return Colors.teal;
      case 'promo':
      case 'winter_event':
        return Colors.purple;
      case 'stock_alert':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
