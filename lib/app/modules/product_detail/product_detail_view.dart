import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:_89_secondstufff/app/modules/product_detail/product_detail_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:intl/intl.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.deepPurpleDark,
                    Color(0xFF251742),
                    AppTheme.deepPurpleDark,
                  ],
                )
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: Obx(() {
          final product = controller.product.value;
          if (product == null) {
            return Center(
              child: Text(
                'Produk tidak ditemukan.',
                style: TextStyle(color: isDark ? Colors.white70 : colorScheme.onSurface),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // App Bar dengan gambar
              SliverAppBar(
                expandedHeight: 380,
                pinned: true,
                backgroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.surface,
                leading: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 400),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? LinearGradient(
                              colors: [
                                AppTheme.glowPurple.withValues(alpha: 0.4),
                                AppTheme.deepPurpleLight.withValues(alpha: 0.4),
                              ],
                            )
                          : null,
                      color: isDark ? null : colorScheme.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: isDark
                          ? [
                              BoxShadow(
                                color: AppTheme.glowPurple.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: isDark ? AppTheme.accentMustard : colorScheme.onSurface,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ),
                ),
                actions: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.scale(scale: value, child: child);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: isDark
                            ? LinearGradient(
                                colors: [
                                  AppTheme.glowPurple.withValues(alpha: 0.4),
                                  AppTheme.deepPurpleLight.withValues(alpha: 0.4),
                                ],
                              )
                            : null,
                        color: isDark ? null : colorScheme.surface.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: isDark
                            ? [
                                BoxShadow(
                                  color: AppTheme.glowPurple.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Obx(() {
                        final wishlistService = Get.find<WishlistService>();
                        final isInWishlist = wishlistService.isInWishlist(product.id);
                        return IconButton(
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              isInWishlist ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(isInWishlist),
                              color: isInWishlist
                                  ? AppTheme.accentRed
                                  : (isDark ? AppTheme.accentMustard : colorScheme.onSurface),
                            ),
                          ),
                          onPressed: () {
                            wishlistService.toggleWishlist(product);
                            Get.snackbar(
                              isInWishlist ? 'Dihapus' : 'Ditambahkan',
                              isInWishlist
                                  ? 'Produk dihapus dari wishlist'
                                  : 'Produk ditambahkan ke wishlist',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: isDark ? AppTheme.deepPurpleLight : null,
                              colorText: isDark ? Colors.white : null,
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Hero(
                        tag: 'product-${product.id}',
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppTheme.deepPurpleDark : Colors.white,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: isDark ? AppTheme.deepPurpleLight : Colors.grey[200],
                              child: Icon(
                                Icons.image_not_supported_rounded,
                                size: 80,
                                color: isDark ? AppTheme.glowPurple : Colors.grey[400],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Gradient overlay at bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 100,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: isDark
                                  ? [
                                      Colors.transparent,
                                      AppTheme.deepPurpleDark.withValues(alpha: 0.8),
                                      AppTheme.deepPurpleDark,
                                    ]
                                  : [
                                      Colors.transparent,
                                      colorScheme.surface.withValues(alpha: 0.8),
                                      colorScheme.surface,
                                    ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Badge dengan animasi
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]
                                  : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.05)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            product.category.capitalizeFirst ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Judul Produk
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          product.title,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : colorScheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Harga Card
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isDark
                                  ? [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.8)]
                                  : [colorScheme.primary.withValues(alpha: 0.1), colorScheme.primary.withValues(alpha: 0.03)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.1),
                            ),
                            boxShadow: isDark
                                ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 16, spreadRadius: 2)]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Harga',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    currencyFormat.format(product.price),
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Tersedia',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Info Cards
                      Row(
                        children: [
                          _buildInfoCard(icon: Icons.local_shipping_outlined, title: 'Pengiriman', subtitle: 'Gratis Ongkir', colorScheme: colorScheme, isDark: isDark),
                          const SizedBox(width: 12),
                          _buildInfoCard(icon: Icons.verified_user_outlined, title: 'Garansi', subtitle: '100% Original', colorScheme: colorScheme, isDark: isDark),
                          const SizedBox(width: 12),
                          _buildInfoCard(icon: Icons.replay_outlined, title: 'Return', subtitle: '7 Hari', colorScheme: colorScheme, isDark: isDark),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Deskripsi Header
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 20,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Deskripsi Produk',
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)])
                              : null,
                          color: isDark ? null : colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          product.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.8),
                            height: 1.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: _buildBottomBar(colorScheme, isDark),
    );
  }

  Widget _buildBottomBar(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(colors: [Color(0xFF2D1B4E), AppTheme.deepPurpleDark])
            : null,
        color: isDark ? null : colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Chat Button
            Container(
              decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)])
                    : null,
                border: Border.all(color: isDark ? AppTheme.accentMustard : colorScheme.primary, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () {
                  Get.snackbar('Info', 'Fitur chat segera hadir!', snackPosition: SnackPosition.BOTTOM);
                },
                icon: Icon(Icons.chat_bubble_outline, color: isDark ? AppTheme.accentMustard : colorScheme.primary),
              ),
            ),
            const SizedBox(width: 14),
            // Add to Cart Button
            Expanded(
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (controller.product.value != null) {
                              controller.addToCart(controller.product.value!);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                      foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: isDark ? 8 : 2,
                      shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_cart_outlined, size: 22),
                              const SizedBox(width: 10),
                              Text('Tambah ke Keranjang', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                            ],
                          ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)])
              : null,
          color: isDark ? null : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.25) : colorScheme.outline.withValues(alpha: 0.15)),
          boxShadow: isDark
              ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 10)]
              : null,
        ),
        child: Column(
          children: [
            Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 26),
            const SizedBox(height: 10),
            Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
            const SizedBox(height: 2),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
          ],
        ),
      ),
    );
  }
}
