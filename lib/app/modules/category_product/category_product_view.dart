import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/widgets/product_card.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'category_product_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({super.key});

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
                  if (controller.products.isEmpty) {
                    return _buildEmptyState(isDark, colorScheme);
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.7),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final Product product = controller.products[index];
                      return ProductCard(product: product, onTap: () => controller.onProductTap(product));
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
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Obx(() => Text(controller.category.value?.name.capitalizeFirst ?? 'Produk', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface))),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                  color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${controller.products.length} produk', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
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
            child: Icon(Icons.inventory_2_outlined, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : colorScheme.primary.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 20),
          Text('Produk tidak ditemukan', style: GoogleFonts.poppins(fontSize: 16, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 8),
          Text('Coba kategori lain', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4))),
        ],
      ),
    );
  }
}
