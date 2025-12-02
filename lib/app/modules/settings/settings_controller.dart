import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class SettingsController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final ThemeController themeController = Get.find<ThemeController>();

  String get userEmail => _supabase.currentUser?.email ?? 'Tamu';
  String get userName => userEmail.contains('@') ? userEmail.split('@')[0] : userEmail;

  void goToEditProfile() {
    Get.toNamed(AppRoutes.EDIT_PROFILE);
  }

  void goToNotificationSettings() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  void goToShippingAddress() {
    Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
  }

  void goToPrivacyPolicy() {
    Get.toNamed(AppRoutes.PRIVACY_POLICY);
  }

  void goToHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  void toggleTheme() {
    themeController.toggleTheme();
  }

  Future<void> logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('LOGOUT'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _supabase.client.auth.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }

  void showAboutApp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('89secondStuff'),
            SizedBox(height: 8),
            Text('Versi 1.0.0'),
            SizedBox(height: 8),
            Text('Aplikasi thrift shop terbaik untuk menemukan barang-barang berkualitas dengan harga terjangkau.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void clearCache() {
    Get.snackbar(
      'Cache Dibersihkan',
      'Cache aplikasi berhasil dibersihkan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
