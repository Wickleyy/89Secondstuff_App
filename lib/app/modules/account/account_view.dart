import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_controller.dart';

// Ganti dari StatelessWidget ke GetView
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
            // 1. Profile Header
            _buildProfileHeader(theme, colorScheme),
            const SizedBox(height: 20),
            // 2. Menu List
            _buildMenuList(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  // Widget untuk header profil
  Widget _buildProfileHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      color: colorScheme.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: colorScheme.primary,
            child: Text(
              controller.initial,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            controller.username,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            controller.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk daftar menu
  Widget _buildMenuList(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildMenuTile(
            theme: theme,
            icon: Icons.person_outline,
            title: 'Edit Profil',
            onTap: controller.goToEditProfile,
          ),
          _buildMenuTile(
            theme: theme,
            icon: Icons.history,
            title: 'Riwayat Pesanan',
            onTap: controller.goToOrderHistory,
          ),

          // Theme Toggle
          Obx(
            () => SwitchListTile(
              title: Text(
                controller.themeController.isDarkMode.value
                    ? 'Mode Gelap'
                    : 'Mode Terang',
                style: theme.textTheme.bodyLarge,
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
              contentPadding: const EdgeInsets.symmetric(vertical: 4),
            ),
          ),

          const Divider(height: 20),

          _buildMenuTile(
            theme: theme,
            icon: Icons.logout,
            title: 'Logout',
            onTap: controller.logout,
            color: theme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  // Helper widget untuk satu baris menu
  Widget _buildMenuTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    final titleColor = color ?? theme.colorScheme.onBackground;
    final iconColor = color ?? theme.colorScheme.primary;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: titleColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurface.withOpacity(0.4),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
