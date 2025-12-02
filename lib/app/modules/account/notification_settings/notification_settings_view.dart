import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'notification_settings_controller.dart';

class NotificationSettingsView extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSection('Pesanan', [
                        _buildNotificationTile('Notifikasi Pesanan', 'Status pesanan Anda', Icons.shopping_bag_outlined, controller.orderNotification, controller.toggleOrderNotification, isDark, colorScheme),
                        _buildNotificationTile('Promosi & Diskon', 'Promo eksklusif', Icons.local_offer_outlined, controller.promoNotification, controller.togglePromoNotification, isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildSection('Produk', [
                        _buildNotificationTile('Review Produk', 'Review dari pembeli', Icons.rate_review_outlined, controller.reviewNotification, controller.toggleReviewNotification, isDark, colorScheme),
                        _buildNotificationTile('Produk Tersedia', 'Produk favorit kembali', Icons.inventory_outlined, controller.accountNotification, controller.toggleAccountNotification, isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildSection('Informasi', [
                        _buildNotificationTile('Berita & Update', 'Update terbaru', Icons.newspaper, controller.newsNotification, controller.toggleNewsNotification, isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 24),
                      _buildResetButton(isDark, colorScheme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Pengaturan Notifikasi', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isDark, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
            color: isDark ? null : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(String title, String subtitle, IconData icon, RxBool value, Function(bool) onChanged, bool isDark, ColorScheme colorScheme) {
    return Obx(() => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isDark ? [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.2)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              Switch(value: value.value, onChanged: onChanged, activeThumbColor: AppTheme.accentMustard, activeTrackColor: AppTheme.accentMustard.withValues(alpha: 0.4)),
            ],
          ),
        ));
  }

  Widget _buildResetButton(bool isDark, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          controller.resetToDefault();
          Get.snackbar('Berhasil', 'Pengaturan direset ke default', snackPosition: SnackPosition.BOTTOM, backgroundColor: isDark ? AppTheme.deepPurpleLight : null, colorText: isDark ? Colors.white : null);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
          side: BorderSide(color: isDark ? AppTheme.accentMustard : colorScheme.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Text('RESET KE DEFAULT', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }
}
