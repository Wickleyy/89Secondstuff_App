import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController themeController =
        Get.find(); // Ambil theme controller

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Section
          UserAccountsDrawerHeader(
            accountName: Text(
              'Username Anda',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              'user@89secondstuff.com',
              style: TextStyle(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              child: Text(
                'U',
                style: TextStyle(
                  fontSize: 40.0,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            decoration: BoxDecoration(color: theme.colorScheme.primary),
          ),
          _buildDrawerItem(
            icon: Icons.shopping_cart_outlined,
            text: 'Cart',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.CART);
            },
          ),
          _buildDrawerItem(
            icon: Icons.favorite_border,
            text: 'Wishlist',
            onTap: () {
              // Navigasi ke Wishlist
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Order History',
            onTap: () {
              // Navigasi ke Order History
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: 'News Info',
            onTap: () {
              // Navigasi ke News Info
            },
          ),
          _buildDrawerItem(
            icon: Icons.notifications_none,
            text: 'Notification',
            onTap: () {
              // Navigasi ke Notification
            },
          ),

          Divider(thickness: 1, indent: 16, endIndent: 16),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Others',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.integration_instructions_outlined,
            text: 'Instruction',
            onTap: () {
              // Navigasi ke Instruction
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Setting',
            onTap: () {
              // Navigasi ke Setting
            },
          ),

          // Theme Toggle
          Obx(
            () => SwitchListTile(
              title: Text(
                themeController.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
              ),
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
              secondary: Icon(
                themeController.isDarkMode.value
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
          ),

          // Logout (Contoh)
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () {
              // Kembali ke login
              Get.offAllNamed(AppRoutes.LOGIN);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Get.back(); // Tutup drawer
        onTap();
      },
    );
  }
}
