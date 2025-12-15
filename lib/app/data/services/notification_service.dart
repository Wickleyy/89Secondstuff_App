// lib/app/data/services/notification_service.dart
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotif = FlutterLocalNotificationsPlugin();

  static const String _channelId = '89secondstuff_channel';
  static const String _channelName = '89SecondStuff Alerts';
  static const String _channelDesc = 'Notifikasi real-time dari 89SecondStuff';

  Future<void> init() async {
    // Minta izin notifikasi
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Notifikasi diizinkan oleh pengguna');
    } else {
      print('❌ Notifikasi ditolak');
    }

    // Setup Local Notification
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotif.initialize(
      InitializationSettings(android: androidInit, iOS: iosInit),
    );

    // Buat channel notifikasi (Android 8+)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );
    await _localNotif.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    // Dapatkan FCM token
    String? token = await _fcm.getToken();
    print('🔑 FCM Token: $token');

    // --- HANDLE NOTIFIKASI SAAT FOREGROUND ---
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📌 [FOREGROUND] Notifikasi diterima: ${message.notification?.title}');
      print('📦 Payload: ${message.data}');

      // Tampilkan sebagai Heads-up Notification
      _showHeadsUpNotification(
        title: message.notification?.title ?? '89SecondStuff',
        body: message.notification?.body ?? 'Ada pembaruan untukmu!',
        payload: message.data,
      );
    });
  }

  // Tampilkan notifikasi modern ala e-commerce
  Future<void> _showHeadsUpNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload, // Ubah ke dynamic
  }) async {
    await _localNotif.show(
      payload.hashCode, // ID unik berdasarkan isi
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          icon: '@drawable/ic_notification',
          largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // Ikon besar
          sound: RawResourceAndroidNotificationSound('notif_sound'), // SUARA CUSTOM!
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'Notifikasi baru dari 89SecondStuff',
          color: const ui.Color.fromARGB(255, 76, 45, 120), // 🔵 WARNA UNGU BRAND
          styleInformation: const BigTextStyleInformation(''), // Dukung teks panjang
          autoCancel: true, // Auto-dismiss setelah diklik
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: jsonEncode(payload), // Encode payload ke string
    );
  }
}