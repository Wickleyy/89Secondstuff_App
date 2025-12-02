import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/account/account_view.dart';
import 'package:_89_secondstufff/app/modules/chat/chat_view.dart';
import 'package:_89_secondstufff/app/modules/home/home_view.dart';
import 'package:_89_secondstufff/app/modules/main_navigation/main_navigation_controller.dart';
import 'package:_89_secondstufff/app/modules/search/search_view.dart';
import 'package:_89_secondstufff/app/modules/categories/categories_view.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  MainNavigationView({super.key});

  final List<Widget> pages = [
    HomeView(),
    const CategoriesView(),
    const SearchView(),
    const ChatView(),
    const AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Obx(() => IndexedStack(index: controller.selectedIndex.value, children: pages)),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
            color: isDark ? null : colorScheme.surface,
            boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changePage,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
              unselectedItemColor: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4),
              selectedLabelStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(fontSize: 11),
              items: [
                _buildNavItem(Icons.home_outlined, Icons.home_rounded, 'Home', 0, isDark, colorScheme),
                _buildNavItem(Icons.category_outlined, Icons.category_rounded, 'Kategori', 1, isDark, colorScheme),
                _buildNavItem(Icons.search_outlined, Icons.search_rounded, 'Search', 2, isDark, colorScheme),
                _buildNavItem(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, 'Chat', 3, isDark, colorScheme),
                _buildNavItem(Icons.person_outline_rounded, Icons.person_rounded, 'Akun', 4, isDark, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, IconData activeIcon, String label, int index, bool isDark, ColorScheme colorScheme) {
    return BottomNavigationBarItem(
      icon: Obx(() => Container(
            padding: const EdgeInsets.all(8),
            decoration: controller.selectedIndex.value == index
                ? BoxDecoration(
                    gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.05)]),
                    borderRadius: BorderRadius.circular(12),
                  )
                : null,
            child: Icon(icon, size: 24),
          )),
      activeIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(activeIcon, size: 24),
      ),
      label: label,
    );
  }
}
