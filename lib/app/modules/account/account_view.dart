import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark],
                )
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: CustomScrollView(
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: _buildProfileHeader(theme, colorScheme, isDark),
            ),
            // Statistics
            SliverToBoxAdapter(
              child: _buildStatisticsSection(theme, colorScheme, isDark),
            ),
            // Menu
            SliverToBoxAdapter(
              child: _buildMenuList(theme, colorScheme, isDark),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]
              : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: isDark
            ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))]
            : [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              // App Bar Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Akun Saya',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                      onPressed: () => Get.toNamed('/settings'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Avatar dengan glow
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [Colors.white, Colors.white70],
                      ),
                      boxShadow: isDark
                          ? [BoxShadow(color: AppTheme.accentMustard.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 3)]
                          : null,
                    ),
                    child: Obx(() => CircleAvatar(
                          radius: 48,
                          backgroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.primary,
                          backgroundImage: controller.avatarUrl.value.isNotEmpty ? NetworkImage(controller.avatarUrl.value) : null,
                          child: controller.avatarUrl.value.isEmpty
                              ? Text(
                                  controller.initial.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? AppTheme.accentMustard : Colors.white,
                                  ),
                                )
                              : null,
                        )),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.5), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.check, color: Colors.white, size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => Text(
                    controller.username.value,
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  )),
              const SizedBox(height: 4),
              Obx(() => Text(
                    controller.email.value,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
                  )),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.accentMustard.withValues(alpha: 0.3), AppTheme.accentRed.withValues(alpha: 0.2)]
                        : [Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.1)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified, color: isDark ? AppTheme.accentMustard : Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Verified Member',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppTheme.accentMustard : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(() => Row(
        children: [
          _buildStatCard(controller.totalOrders.value.toString(), 'Pesanan', Icons.shopping_bag_outlined, isDark, colorScheme, onTap: controller.goToOrders),
          const SizedBox(width: 12),
          _buildStatCard(controller.totalReviews.value.toString(), 'Diulas', Icons.star_outlined, isDark, colorScheme, onTap: controller.goToReviews),
          const SizedBox(width: 12),
          _buildStatCard(controller.totalWishlist.value.toString(), 'Wishlist', Icons.favorite_outline, isDark, colorScheme, onTap: controller.goToWishlist),
        ],
      )),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, bool isDark, ColorScheme colorScheme, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.7)])
                : null,
            color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.2),
            ),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 12)] : null,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]
                        : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuList(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildMenuSection(
            title: 'Akun & Pesanan',
            isDark: isDark,
            colorScheme: colorScheme,
            children: [
              _buildMenuTile(Icons.person_outline, 'Edit Profil', 'Ubah informasi pribadi', controller.goToEditProfile, isDark, colorScheme),
              _buildMenuTile(Icons.history, 'Riwayat Pesanan', 'Lihat semua pesanan Anda', controller.goToOrderHistory, isDark, colorScheme),
              _buildMenuTile(Icons.location_on_outlined, 'Alamat Pengiriman', 'Kelola alamat pengiriman', controller.goToShippingAddress, isDark, colorScheme),
            ],
          ),
          const SizedBox(height: 20),
          _buildMenuSection(
            title: 'Preferensi',
            isDark: isDark,
            colorScheme: colorScheme,
            children: [
              _buildThemeToggle(isDark, colorScheme),
              _buildMenuTile(Icons.notifications_outlined, 'Notifikasi', 'Kelola pengaturan notifikasi', controller.goToNotificationSettings, isDark, colorScheme),
            ],
          ),
          const SizedBox(height: 20),
          _buildMenuSection(
            title: 'Lainnya',
            isDark: isDark,
            colorScheme: colorScheme,
            children: [
              _buildMenuTile(Icons.help_outline, 'Pusat Bantuan', 'FAQ dan dukungan', controller.goToHelpCenter, isDark, colorScheme),
              _buildMenuTile(Icons.privacy_tip_outlined, 'Kebijakan Privasi', 'Ketentuan dan kebijakan', controller.goToPrivacyPolicy, isDark, colorScheme),
              _buildMenuTile(Icons.info_outline, 'Tentang Aplikasi', 'Versi 1.5.4', controller.showAboutApp, isDark, colorScheme),
            ],
          ),
          const SizedBox(height: 24),
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, size: 20),
              label: Text('Keluar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
              onPressed: controller.logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.accentRed : Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isDark ? 8 : 2,
                shadowColor: isDark ? AppTheme.accentRed.withValues(alpha: 0.5) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required bool isDark,
    required ColorScheme colorScheme,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)])
                : null,
            color: isDark ? null : colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : null,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, VoidCallback onTap, bool isDark, ColorScheme colorScheme) {
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
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.2)]
                        : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)],
                  ),
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
                    const SizedBox(height: 2),
                    Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.3), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark, ColorScheme colorScheme) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.2)]
                      : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                controller.themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.themeController.isDarkMode.value ? 'Mode Gelap' : 'Mode Terang',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface),
                  ),
                  Text('Ubah tampilan aplikasi', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
            Switch(
              value: controller.themeController.isDarkMode.value,
              onChanged: (_) => controller.themeController.toggleTheme(),
              activeTrackColor: AppTheme.accentMustard.withValues(alpha: 0.4),
              thumbColor: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.selected) ? AppTheme.accentMustard : null),
            ),
          ],
        ),
      ),
    );
  }
}
