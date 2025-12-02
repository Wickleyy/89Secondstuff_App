import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark]) : null,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserCard(isDark, colorScheme),
                      const SizedBox(height: 24),
                      _buildSection('AKUN', [
                        _buildTile(Icons.person_outline, 'Edit Profil', 'Ubah nama, foto profil', controller.goToEditProfile, isDark, colorScheme),
                        _buildTile(Icons.location_on_outlined, 'Alamat Pengiriman', 'Kelola alamat pengiriman', controller.goToShippingAddress, isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildSection('PREFERENSI', [
                        _buildTile(Icons.notifications_outlined, 'Notifikasi', 'Atur notifikasi aplikasi', controller.goToNotificationSettings, isDark, colorScheme),
                        _buildThemeToggle(isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildSection('BANTUAN', [
                        _buildTile(Icons.help_outline, 'Pusat Bantuan', 'FAQ dan panduan', controller.goToHelpCenter, isDark, colorScheme),
                        _buildTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', 'Baca kebijakan privasi', controller.goToPrivacyPolicy, isDark, colorScheme),
                        _buildTile(Icons.info_outline, 'Tentang Aplikasi', 'Versi dan informasi', controller.showAboutApp, isDark, colorScheme),
                      ], isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildSection('LAINNYA', [
                        _buildTile(Icons.cleaning_services_outlined, 'Bersihkan Cache', 'Hapus data sementara', controller.clearCache, isDark, colorScheme),
                        _buildTile(Icons.logout, 'Keluar', 'Logout dari akun', controller.logout, isDark, colorScheme, isDestructive: true),
                      ], isDark, colorScheme),
                      const SizedBox(height: 32),
                      Center(child: Text('89secondStuff v1.0.0', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)))),
                      const SizedBox(height: 16),
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
          Text('Pengaturan', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildUserCard(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark] : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.3), blurRadius: 16)] : [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [Colors.white, Colors.white70])),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.primary,
              child: Text(controller.userName.isNotEmpty ? controller.userName[0].toUpperCase() : 'U', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : Colors.white)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.userName, style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(controller.userEmail, style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: IconButton(onPressed: controller.goToEditProfile, icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 20)),
          ),
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
          child: Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
            color: isDark ? null : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(IconData icon, String title, String subtitle, VoidCallback onTap, bool isDark, ColorScheme colorScheme, {bool isDestructive = false}) {
    final color = isDestructive ? AppTheme.accentRed : (isDark ? AppTheme.accentMustard : colorScheme.primary);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDestructive ? AppTheme.accentRed : (isDark ? Colors.white : colorScheme.onSurface))),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark, ColorScheme colorScheme) {
    return Obx(() {
      final themeController = Get.find<ThemeController>();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mode Gelap', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
                  Text('Ubah tampilan aplikasi', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
            Switch(
              value: themeController.isDarkMode.value,
              onChanged: (_) => controller.toggleTheme(),
              activeTrackColor: AppTheme.accentMustard.withValues(alpha: 0.4),
              thumbColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppTheme.accentMustard : null),
            ),
          ],
        ),
      );
    });
  }
}
