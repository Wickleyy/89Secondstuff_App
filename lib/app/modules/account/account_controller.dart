import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/data/services/order_service.dart';

class AccountController extends GetxController {
  // Ambil theme controller yang sudah ada
  final ThemeController themeController = Get.find();

  // --- AMBIL Services ---
  final SupabaseService _supabase = Get.find<SupabaseService>();
  WishlistService get _wishlistService => Get.find<WishlistService>();
  OrderService get _orderService => Get.find<OrderService>();

  // --- DATA USER (OBSERVABLE / REAKTIF) ---
  var email = ''.obs;
  var username = 'User'.obs;
  var initial = 'U'.obs;
  var avatarUrl = ''.obs;

  // Observable untuk statistics (Real-time)
  var totalOrders = 0.obs;
  var totalReviews = 0.obs;
  var totalWishlist = 0.obs;
  var isVerified = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadStatistics();
    
    // Listen to wishlist changes
    ever(_wishlistService.wishlistItems, (_) {
      totalWishlist.value = _wishlistService.itemCount;
    });
  }

  // --- LOAD DATA DARI SUPABASE ---
  void loadUserData() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) return;

      // 1. Set Email dari Auth
      email.value = user.email ?? "Guest";

      // 2. Ambil Data Profil dari Database
      final response = await _supabase.client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        // Update Username (Full Name)
        String dbName = response['full_name'] ?? '';

        // Jika nama di DB kosong, pakai nama dari potongan email
        if (dbName.isEmpty && email.value.contains('@')) {
          username.value = email.value.split('@')[0];
        } else {
          username.value = dbName;
        }

        // Update Avatar URL
        avatarUrl.value = response['avatar_url'] ?? '';

        // Update Inisial (Huruf Depan)
        if (username.value.isNotEmpty) {
          initial.value = username.value[0].toUpperCase();
        } else {
          initial.value = "U";
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // --- NAVIGASI ---
  void goToEditProfile() async {
    // Kita pakai await agar saat kembali dari halaman edit, data direfresh
    await Get.toNamed(AppRoutes.EDIT_PROFILE);
    loadUserData();
  }

  void goToOrderHistory() {
    Get.toNamed(AppRoutes.ORDER_HISTORY);
  }

  void goToShippingAddress() {
    Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
  }

  void goToNotificationSettings() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  void goToHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  void goToPrivacyPolicy() {
    Get.toNamed(AppRoutes.PRIVACY_POLICY);
  }

  void showAboutApp() {
    Get.snackbar(
      'Tentang Aplikasi',
      '89secondStuff v1.0.0\nA stylish shopping experience',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  void logout() {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      content: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          textAlign: TextAlign.center,
        ),
      ),
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Tutup dialog
        try {
          await _supabase.client.auth.signOut();
          Get.offAllNamed(AppRoutes.LOGIN);
          Get.snackbar(
            'Logout',
            'Anda telah keluar dari akun.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal logout: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () {},
    );
  }

  // --- LOAD STATISTICS (Real-time) ---
  Future<void> loadStatistics() async {
    try {
      // Load orders count
      final orders = await _orderService.getUserOrders();
      totalOrders.value = orders.length;
      
      // Load wishlist count
      totalWishlist.value = _wishlistService.itemCount;
      
      // Reviews - untuk saat ini 0 (bisa ditambahkan table reviews nanti)
      totalReviews.value = 0;
    } catch (e) {
      debugPrint('Error loading statistics: $e');
    }
  }

  void refreshUserData() {
    loadUserData();
    loadStatistics();
  }
  
  // --- NAVIGASI STATISTICS ---
  void goToOrders() {
    Get.toNamed(AppRoutes.ORDER_HISTORY);
  }
  
  void goToReviews() {
    // Untuk saat ini, arahkan ke order history (bisa dibuat halaman reviews nanti)
    Get.snackbar(
      'Ulasan',
      'Fitur ulasan akan segera hadir!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  void goToWishlist() {
    Get.toNamed(AppRoutes.WISHLIST);
  }
}
