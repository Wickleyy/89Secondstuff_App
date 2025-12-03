import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : colorScheme.primary));
                  }
                  if (controller.categories.isEmpty) {
                    return _buildEmptyState(isDark, colorScheme);
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 14, mainAxisSpacing: 14, childAspectRatio: 1.0),
                    itemCount: controller.categories.length,
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      final icon = controller.getCategoryIcon(category.name);
                      return _buildCategoryCard(category, icon, index, isDark, colorScheme);
                    },
                  );
                }),
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
          Text('Kategori', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                  color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${controller.categories.length} kategori', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null, shape: BoxShape.circle),
            child: Icon(Icons.category_outlined, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : colorScheme.primary.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 20),
          Text('Kategori tidak ditemukan', style: GoogleFonts.poppins(fontSize: 16, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category, IconData icon, int index, bool isDark, ColorScheme colorScheme) {
    final colors = [
      [AppTheme.accentMustard, AppTheme.accentRed],
      [Colors.blue, Colors.cyan],
      [Colors.green, Colors.teal],
      [Colors.purple, Colors.pink],
      [Colors.orange, Colors.deepOrange],
      [Colors.indigo, Colors.blue],
    ];
    final gradientColors = colors[index % colors.length];

    return GestureDetector(
      onTap: () => controller.onCategoryTap(category),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
          color: isDark ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 12)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [gradientColors[0].withValues(alpha: isDark ? 0.3 : 0.15), gradientColors[1].withValues(alpha: isDark ? 0.2 : 0.08)]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, size: 36, color: gradientColors[0]),
            ),
            const SizedBox(height: 14),
            Text(category.name.toString().capitalizeFirst ?? category.name, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
