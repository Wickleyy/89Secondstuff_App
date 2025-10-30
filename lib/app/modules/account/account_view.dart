import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Akun Saya',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Profile Header dengan Background Gradient
            _buildProfileHeader(theme, colorScheme),
            const SizedBox(height: 24),
            // 2. Statistics Card
            _buildStatisticsSection(theme, colorScheme),
            const SizedBox(height: 24),
            // 3. Menu List
            _buildMenuList(theme, colorScheme),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Profile Header dengan Gradient Background
  Widget _buildProfileHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Avatar dengan Badge
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: colorScheme.onPrimary.withOpacity(0.2),
                child: Text(
                  controller.initial,
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.onPrimary,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: colorScheme.onPrimary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            controller.username,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.onPrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '✓ Verified Member',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Statistics Section
  Widget _buildStatisticsSection(ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildStatCard(
            theme,
            colorScheme,
            '12',
            'Pesanan',
            Icons.shopping_bag_outlined,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            theme,
            colorScheme,
            '8',
            'Diulas',
            Icons.star_outlined,
          ),
          const SizedBox(width: 12),
          _buildStatCard(
            theme,
            colorScheme,
            '3',
            'Wishlist',
            Icons.favorite_outline,
          ),
        ],
      ),
    );
  }

  // Stat Card Component
  Widget _buildStatCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String value,
    String label,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu List
  Widget _buildMenuList(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildMenuSection(
            theme: theme,
            title: 'Akun & Pesanan',
            children: [
              _buildMenuTile(
                theme: theme,
                icon: Icons.person_outline,
                title: 'Edit Profil',
                subtitle: 'Ubah informasi pribadi Anda',
                onTap: controller.goToEditProfile,
              ),
              _buildMenuTile(
                theme: theme,
                icon: Icons.history,
                title: 'Riwayat Pesanan',
                subtitle: 'Lihat semua pesanan Anda',
                onTap: controller.goToOrderHistory,
              ),
              _buildMenuTile(
                theme: theme,
                icon: Icons.location_on_outlined,
                title: 'Alamat Pengiriman',
                subtitle: 'Kelola alamat pengiriman',
                onTap: () => Get.snackbar('Info',
                    'Halaman Alamat Pengiriman belum tersedia.',
                    snackPosition: SnackPosition.BOTTOM),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMenuSection(
            theme: theme,
            title: 'Preferensi',
            children: [
              Obx(
                () => SwitchListTile(
                  title: Text(
                    controller.themeController.isDarkMode.value
                        ? 'Mode Gelap'
                        : 'Mode Terang',
                    style: theme.textTheme.bodyLarge,
                  ),
                  subtitle: Text(
                    controller.themeController.isDarkMode.value
                        ? 'Aktif'
                        : 'Aktif',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  value: controller.themeController.isDarkMode.value,
                  onChanged: (value) {
                    controller.themeController.toggleTheme();
                  },
                  secondary: Icon(
                    controller.themeController.isDarkMode.value
                        ? Icons.dark_mode_outlined
                        : Icons.light_mode_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  activeColor: theme.colorScheme.primary,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
              _buildMenuTile(
                theme: theme,
                icon: Icons.notifications_outlined,
                title: 'Notifikasi',
                subtitle: 'Kelola pengaturan notifikasi',
                onTap: () => Get.snackbar('Info',
                    'Halaman Notifikasi belum tersedia.',
                    snackPosition: SnackPosition.BOTTOM),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildMenuSection(
            theme: theme,
            title: 'Lainnya',
            children: [
              _buildMenuTile(
                theme: theme,
                icon: Icons.help_outline,
                title: 'Pusat Bantuan',
                subtitle: 'FAQ dan dukungan pelanggan',
                onTap: () => Get.snackbar('Info',
                    'Halaman Pusat Bantuan belum tersedia.',
                    snackPosition: SnackPosition.BOTTOM),
              ),
              _buildMenuTile(
                theme: theme,
                icon: Icons.privacy_tip_outlined,
                title: 'Kebijakan Privasi',
                subtitle: 'Ketentuan dan kebijakan kami',
                onTap: () => Get.snackbar('Info',
                    'Halaman Kebijakan Privasi belum tersedia.',
                    snackPosition: SnackPosition.BOTTOM),
              ),
              _buildMenuTile(
                theme: theme,
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                subtitle: 'Versi 1.0.0',
                onTap: () => Get.snackbar('Info',
                    '89secondStuff v1.0.0\nA stylish shopping experience',
                    snackPosition: SnackPosition.BOTTOM),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: Icon(Icons.logout, color: Colors.white),
              label: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              onPressed: controller.logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Menu Section Header
  Widget _buildMenuSection({
    required ThemeData theme,
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  // Menu Tile dengan Subtitle
  Widget _buildMenuTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final titleColor = color ?? theme.colorScheme.onBackground;
    final iconColor = color ?? theme.colorScheme.primary;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      dense: false,
    );
  }
}