import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/modules/account/account_controller.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ThemeController themeController = Get.find();
    final SupabaseService supabase = Get.find<SupabaseService>();
    
    // Try to get AccountController for synced profile data
    AccountController? accountController;
    try {
      accountController = Get.find<AccountController>();
    } catch (_) {
      // AccountController not registered yet
    }

    return Drawer(
      backgroundColor: isDark ? AppTheme.deepPurpleDark : theme.colorScheme.surface,
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark],
                )
              : null,
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header dengan gradient - using Obx for reactive updates
            _buildHeader(context, isDark, theme, supabase, accountController),
            const SizedBox(height: 16),

            // Menu Items
            _buildDrawerItem(context, Icons.shopping_cart_outlined, 'Keranjang', () => Get.toNamed(AppRoutes.CART), isDark),
            _buildDrawerItem(context, Icons.favorite_border, 'Wishlist', () => Get.toNamed(AppRoutes.WISHLIST), isDark),
            _buildDrawerItem(context, Icons.history, 'Riwayat Pesanan', () => Get.toNamed(AppRoutes.ORDER_HISTORY), isDark),
            _buildDrawerItem(context, Icons.notifications_none, 'Notifikasi', () => Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS), isDark),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Divider(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : theme.dividerColor),
            ),

            // Section Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                'LAINNYA',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : theme.hintColor,
                ),
              ),
            ),

            _buildDrawerItem(context, Icons.settings_outlined, 'Pengaturan', () => Get.toNamed(AppRoutes.SETTINGS), isDark),
            _buildDrawerItem(context, Icons.help_outline, 'Pusat Bantuan', () => Get.toNamed(AppRoutes.HELP_CENTER), isDark),

            // Theme Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Obx(
                () => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: isDark
                        ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)])
                        : null,
                    color: isDark ? null : theme.colorScheme.primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
                  ),
                  child: SwitchListTile(
                    title: Text(
                      themeController.isDarkMode.value ? 'Mode Gelap' : 'Mode Terang',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : theme.colorScheme.onSurface,
                      ),
                    ),
                    value: themeController.isDarkMode.value,
                    onChanged: (_) => themeController.toggleTheme(),
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [theme.colorScheme.primary.withValues(alpha: 0.1), theme.colorScheme.primary.withValues(alpha: 0.05)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? AppTheme.accentMustard : theme.colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    activeTrackColor: AppTheme.accentMustard.withValues(alpha: 0.5),
                    activeThumbColor: AppTheme.accentMustard,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await supabase.client.auth.signOut();
                  Get.offAllNamed(AppRoutes.LOGIN);
                },
                icon: const Icon(Icons.logout, size: 20),
                label: Text('Keluar', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppTheme.accentRed : Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: isDark ? 8 : 2,
                  shadowColor: isDark ? AppTheme.accentRed.withValues(alpha: 0.5) : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String text, VoidCallback onTap, bool isDark) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.back();
            onTap();
          },
          borderRadius: BorderRadius.circular(14),
          splashColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.2) : theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.2)]
                          : [theme.colorScheme.primary.withValues(alpha: 0.1), theme.colorScheme.primary.withValues(alpha: 0.05)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: isDark ? AppTheme.accentMustard : theme.colorScheme.primary, size: 22),
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: isDark ? Colors.white30 : theme.colorScheme.onSurface.withValues(alpha: 0.3), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, ThemeData theme, SupabaseService supabase, AccountController? accountController) {
    // Fallback values from auth if AccountController not available
    final user = supabase.currentUser;
    final fallbackEmail = user?.email ?? "Tamu";
    final fallbackUsername = fallbackEmail.contains('@') ? fallbackEmail.split('@')[0] : fallbackEmail;
    final fallbackInitial = fallbackEmail.isNotEmpty ? fallbackEmail[0].toUpperCase() : "T";

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]
              : [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
        boxShadow: isDark
            ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8))]
            : null,
      ),
      child: accountController != null
          ? Obx(() {
              final avatarUrl = accountController.avatarUrl.value;
              final username = accountController.username.value.isNotEmpty 
                  ? accountController.username.value 
                  : fallbackUsername;
              final email = accountController.email.value.isNotEmpty 
                  ? accountController.email.value 
                  : fallbackEmail;
              final initial = accountController.initial.value.isNotEmpty 
                  ? accountController.initial.value 
                  : fallbackInitial;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar dengan glow
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [Colors.white, Colors.white70],
                      ),
                      boxShadow: isDark
                          ? [BoxShadow(color: AppTheme.accentMustard.withValues(alpha: 0.5), blurRadius: 16, spreadRadius: 2)]
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: isDark ? AppTheme.deepPurpleDark : theme.colorScheme.primary,
                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl.isEmpty
                          ? Text(
                              initial,
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: isDark ? AppTheme.accentMustard : Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    username,
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
                  ),
                ],
              );
            })
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [Colors.white, Colors.white70],
                    ),
                    boxShadow: isDark
                        ? [BoxShadow(color: AppTheme.accentMustard.withValues(alpha: 0.5), blurRadius: 16, spreadRadius: 2)]
                        : null,
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: isDark ? AppTheme.deepPurpleDark : theme.colorScheme.primary,
                    child: Text(
                      fallbackInitial,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.accentMustard : Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  fallbackUsername,
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  fallbackEmail,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
                ),
              ],
            ),
    );
  }
}
