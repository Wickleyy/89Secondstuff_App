import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

// Background message handler - must be top-level function
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

  // Observable states
  final Rx<String?> fcmToken = Rx<String?>(null);
  final RxBool isInitialized = false.obs;
  final RxList<NotificationItem> notifications = <NotificationItem>[].obs;
  final RxInt unreadCount = 0.obs;

  // Channel configuration with default sound
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'Notifikasi Penting';
  static const String _channelDescription = 'Notifikasi untuk pesanan dan promo';

  Future<NotificationService> init() async {
    try {
      // Request permissions
      await _requestPermissions();

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Setup FCM handlers
      await _setupFCMHandlers();

      // Get FCM token
      await _getFCMToken();

      // Subscribe to topics for broadcast notifications
      await _subscribeToTopics();

      // Handle terminated state - check if app was opened from notification
      await _handleTerminatedState();

      isInitialized.value = true;
      debugPrint('[NotificationService] Service initialized successfully');
    } catch (e) {
      debugPrint('[NotificationService] Init error: $e');
    }
    return this;
  }

  /// Subscribe to FCM topics for broadcast notifications
  Future<void> _subscribeToTopics() async {
    try {
      // Subscribe to general topics
      await _firebaseMessaging.subscribeToTopic('all_users');
      await _firebaseMessaging.subscribeToTopic('promo');
      debugPrint('[NotificationService] Subscribed to topics: all_users, promo');
    } catch (e) {
      debugPrint('[NotificationService] Error subscribing to topics: $e');
    }
  }

  /// Handle app opened from terminated state via notification
  Future<void> _handleTerminatedState() async {
    // Check if app was opened from a terminated state via FCM notification
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    
    if (initialMessage != null) {
      debugPrint('[NotificationService] App opened from TERMINATED state');
      debugPrint('[NotificationService] Initial message data: ${initialMessage.data}');
      
      // Delay navigation to ensure app is fully initialized
      Future.delayed(const Duration(milliseconds: 500), () {
        navigateFromNotification(initialMessage.data);
      });
    }
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('[NotificationService] Permission status: ${settings.authorizationStatus}');

    // For Android 13+ request notification permission
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/launcher_icon');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Create Android notification channel with custom sound
    final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        ),
      );
      debugPrint('[NotificationService] Notification channel created');
    }
  }

  Future<void> _setupFCMHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages when app is opened
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Set background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      fcmToken.value = token;
      debugPrint('[NotificationService] FCM Token: $token');

      // Save token to Supabase if user is logged in
      if (token != null) {
        await _saveFCMTokenToSupabase(token);
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        fcmToken.value = newToken;
        debugPrint('[NotificationService] FCM Token refreshed');
        await _saveFCMTokenToSupabase(newToken);
      });
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
    }
  }

  Future<void> _saveFCMTokenToSupabase(String token) async {
    try {
      if (!Get.isRegistered<SupabaseService>()) return;
      
      final supabase = Get.find<SupabaseService>();
      final userId = supabase.currentUser?.id;

      if (userId == null) {
        debugPrint('[NotificationService] No user logged in, skipping token save');
        return;
      }

      await supabase.client.from('profiles').update({
        'fcm_token': token,
        'fcm_token_updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      debugPrint('[NotificationService] FCM Token saved to Supabase');
    } catch (e) {
      debugPrint('[NotificationService] Error saving FCM token: $e');
    }
  }

  /// Update FCM token after user login
  Future<void> updateTokenAfterLogin() async {
    if (fcmToken.value != null) {
      await _saveFCMTokenToSupabase(fcmToken.value!);
    }
  }

  /// Remove FCM token on logout
  Future<void> removeTokenOnLogout() async {
    try {
      if (!Get.isRegistered<SupabaseService>()) return;
      
      final supabase = Get.find<SupabaseService>();
      final userId = supabase.currentUser?.id;

      if (userId == null) return;

      await supabase.client.from('profiles').update({
        'fcm_token': null,
      }).eq('id', userId);

      debugPrint('[NotificationService] FCM Token removed from Supabase');
    } catch (e) {
      debugPrint('[NotificationService] Error removing FCM token: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[NotificationService] Foreground message received');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');

    // Add to notification list
    _addToNotificationList(
      title: message.notification?.title ?? 'Notifikasi',
      body: message.notification?.body ?? '',
      type: message.data['type'] ?? 'general',
      data: message.data,
    );

    // Show local notification with custom sound
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('[NotificationService] Message opened app from background');
    navigateFromNotification(message.data);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/launcher_icon',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification.title,
      notification.body,
      details,
      payload: jsonEncode(message.data),
    );
  }

  void _onLocalNotificationTapped(NotificationResponse response) {
    debugPrint('[NotificationService] Local notification tapped');
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        navigateFromNotification(data);
      } catch (e) {
        debugPrint('[NotificationService] Error parsing payload: $e');
      }
    }
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    debugPrint('[NotificationService] Background notification tapped');
  }

  void navigateFromNotification(Map<String, dynamic> data) {
    debugPrint('[NotificationService] Navigating from notification: $data');

    final type = data['type']?.toString() ?? '';

    // Ensure GetX is ready before navigating
    if (!Get.isRegistered<NotificationService>()) {
      debugPrint('[NotificationService] GetX not ready, delaying navigation');
      Future.delayed(const Duration(milliseconds: 300), () {
        navigateFromNotification(data);
      });
      return;
    }

    switch (type) {
      case 'order_update':
      case 'order_status':
      case 'order_new':
      case 'payment_success':
        debugPrint('[NotificationService] Navigating to ORDER_HISTORY');
        Get.toNamed(AppRoutes.ORDER_HISTORY);
        break;
      case 'new_product':
      case 'promo':
        debugPrint('[NotificationService] Navigating to MAIN_NAVIGATION (Home)');
        Get.toNamed(AppRoutes.MAIN_NAVIGATION);
        break;
      case 'chat':
      case 'new_message':
        debugPrint('[NotificationService] Navigating to CHAT');
        Get.toNamed(AppRoutes.CHAT);
        break;
      case 'admin_chat':
        debugPrint('[NotificationService] Navigating to ADMIN_CHAT_LIST');
        Get.toNamed(AppRoutes.ADMIN_CHAT_LIST);
        break;
      case 'low_stock':
        debugPrint('[NotificationService] Navigating to ADMIN_PRODUCT_LIST');
        Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST);
        break;
      default:
        debugPrint('[NotificationService] Navigating to MAIN_NAVIGATION (default)');
        Get.toNamed(AppRoutes.MAIN_NAVIGATION);
    }
  }

  void _addToNotificationList({
    required String title,
    required String body,
    required String type,
    Map<String, dynamic>? data,
  }) {
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

    // Keep only last 50 notifications
    if (notifications.length > 50) {
      notifications.removeLast();
    }
  }

  // ============== PUBLIC METHODS FOR SHOWING NOTIFICATIONS ==============

  /// Show notification for new product
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

  /// Show notification for new chat message
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

  /// Show notification for new order (for admin)
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

  /// Show notification for order status update (for customer)
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

  /// Show notification for payment success
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

  /// Show notification for checkout success
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

  /// Show notification for low stock (admin only)
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

  /// Show notification for promo/discount (broadcast to all users)
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

  /// Generic show notification method with custom sound
  Future<void> showNotification({
    required String title,
    required String body,
    String type = 'general',
    Map<String, dynamic>? data,
  }) async {
    // Add to notification list
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
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
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

  // ============== NOTIFICATION LIST MANAGEMENT ==============

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
}

// ============== NOTIFICATION ITEM MODEL ==============

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    bool? isRead,
  }) {
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
        return Icons.discount;
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
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
