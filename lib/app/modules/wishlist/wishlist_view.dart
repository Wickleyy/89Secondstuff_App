import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

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
                child: Obx(() {
                  final wishlistService = Get.find<WishlistService>();
                  final items = wishlistService.wishlistItems;
                  if (items.isEmpty) return _buildEmptyState(isDark, colorScheme);
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final product = items[index];
                      return Dismissible(
                        key: Key(product.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 24),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.accentRed.withValues(alpha: 0.8), AppTheme.accentRed]), borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                        ),
                        onDismissed: (_) {
                          controller.removeFromWishlist(product.id);
                          Get.snackbar('Dihapus', '${product.title} dihapus dari wishlist', snackPosition: SnackPosition.BOTTOM, backgroundColor: isDark ? AppTheme.deepPurpleLight : null, colorText: isDark ? Colors.white : null);
                        },
                        child: _buildWishlistItem(product, currencyFormat, isDark, colorScheme),
                      );
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
          Text('Wishlist', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
          const Spacer(),
          Obx(() {
            final count = Get.find<WishlistService>().wishlistItems.length;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.accentRed.withValues(alpha: 0.2), AppTheme.accentMustard.withValues(alpha: 0.1)]) : null,
                color: isDark ? null : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: isDark ? AppTheme.accentRed : Colors.red, size: 16),
                  const SizedBox(width: 6),
                  Text('$count', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentRed : Colors.red)),
                ],
              ),
            );
          }),
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.accentRed.withValues(alpha: 0.15), AppTheme.glowPurple.withValues(alpha: 0.1)]) : null,
              color: isDark ? null : Colors.red.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite_border, size: 64, color: isDark ? AppTheme.accentRed.withValues(alpha: 0.6) : Colors.red.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Wishlist Kosong', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text('Tambahkan produk favorit kamu!', style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.accentRed : Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: isDark ? 8 : 2,
              shadowColor: isDark ? AppTheme.accentRed.withValues(alpha: 0.5) : null,
            ),
            child: Text('Mulai Belanja', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(dynamic product, NumberFormat currencyFormat, bool isDark, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => controller.goToProductDetail(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
          color: isDark ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.1), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(width: 80, height: 80, color: isDark ? AppTheme.deepPurpleLight : Colors.grey[200], child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
                  errorWidget: (_, __, ___) => Container(width: 80, height: 80, color: isDark ? AppTheme.deepPurpleLight : Colors.grey[200], child: const Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.15)]) : null,
                      color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(product.category, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                      color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(currencyFormat.format(product.price), style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppTheme.accentRed.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () => controller.removeFromWishlist(product.id),
                icon: Icon(Icons.favorite, color: AppTheme.accentRed, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
