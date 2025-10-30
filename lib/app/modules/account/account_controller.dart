import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';

class AccountController extends GetxController {
  // Ambil theme controller yang sudah ada
  final ThemeController themeController = Get.find();

  // Data user (dummy) - bisa diganti dengan data dari API
  final String username = "mor_2314";
  final String email = "mor_2314@fakestore.com";
  final String initial = "M"; // Inisial untuk avatar

  // Observable untuk statistics
  var totalOrders = 12.obs;
  var totalReviews = 8.obs;
  var totalWishlist = 3.obs;

  // Observable untuk user profile
  var isVerified = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Bisa digunakan untuk load data dari API
    loadUserData();
  }

  // Load user data dari API (jika diperlukan)
  void loadUserData() {
    // TODO: Implementasi API call untuk load user data
    // Contoh:
    // try {
    //   final userData = await userService.getUserData();
    //   username.value = userData.username;
    //   email.value = userData.email;
    //   totalOrders.value = userData.totalOrders;
    //   totalReviews.value = userData.totalReviews;
    //   totalWishlist.value = userData.totalWishlist;
    // } catch (e) {
    //   Get.snackbar('Error', 'Gagal memuat data: $e',
    //       snackPosition: SnackPosition.BOTTOM);
    // }
  }

  // Navigasi ke Edit Profile
  void goToEditProfile() {
    Get.toNamed(AppRoutes.EDIT_PROFILE);
  }

  // Navigasi ke Order History
  void goToOrderHistory() {
    Get.toNamed(AppRoutes.ORDER_HISTORY);
  }

  // Navigasi ke Alamat Pengiriman
  void goToShippingAddress() {
    Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
  }

  // Navigasi ke Notifikasi Settings
  void goToNotificationSettings() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  // Navigasi ke Help Center
  void goToHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  // Navigasi ke Privacy Policy
  void goToPrivacyPolicy() {
    Get.toNamed(AppRoutes.PRIVACY_POLICY);
  }

  // Show About App
  void showAboutApp() {
    Get.snackbar(
      'Tentang Aplikasi',
      '89secondStuff v1.0.0\nA stylish shopping experience\n\nBuat Anda yang mencari gaya unik dan produk berkualitas.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  // Logout dengan konfirmasi
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
      onConfirm: () {
        // Hapus semua route dan kembali ke login
        Get.offAllNamed(AppRoutes.LOGIN);
        Get.snackbar(
          'Logout',
          'Anda telah keluar dari akun.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  // Update statistics (untuk test/demo)
  void updateStatistics({
    int? orders,
    int? reviews,
    int? wishlist,
  }) {
    if (orders != null) totalOrders.value = orders;
    if (reviews != null) totalReviews.value = reviews;
    if (wishlist != null) totalWishlist.value = wishlist;
  }

  // Refresh user data
  void refreshUserData() {
    Get.snackbar(
      'Loading',
      'Memperbarui data...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
    // TODO: Implementasi refresh dari API
    loadUserData();
  }
}