import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/widgets/product_card.dart';
import 'package:_89_secondstufff/app/modules/main_navigation/main_navigation_controller.dart';
import 'package:_89_secondstufff/app/widgets/app_drawer.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final MainNavigationController mainNavController =
      Get.find<MainNavigationController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
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
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Custom App Bar dengan gradient
              SliverToBoxAdapter(
                child: _buildCustomAppBar(context, colorScheme, isDark),
              ),
              // What's News Section
              SliverToBoxAdapter(
                child: _buildWhatsNewsSection(colorScheme, isDark),
              ),
              // Featured Products Section Header
              SliverToBoxAdapter(
                child: _buildSectionHeader('Produk Pilihan', colorScheme, isDark),
              ),
              // Featured Products Grid
              _buildFeaturedProductsGrid(context, colorScheme, isDark),
              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          // Menu Button dengan animasi
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: isDark 
                  ? LinearGradient(
                      colors: [
                        AppTheme.glowPurple.withValues(alpha: 0.3),
                        AppTheme.deepPurpleLight.withValues(alpha: 0.3),
                      ],
                    )
                  : null,
                color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                boxShadow: isDark ? [
                  BoxShadow(
                    color: AppTheme.glowPurple.withValues(alpha: 0.2),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ] : null,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                ),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Search Bar dengan glow effect
          Expanded(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: GestureDetector(
                onTap: () => Get.find<MainNavigationController>().changePage(1),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: isDark 
                      ? LinearGradient(
                          colors: [
                            AppTheme.deepPurpleLight.withValues(alpha: 0.4),
                            AppTheme.deepPurpleDark.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                    color: isDark ? null : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark 
                        ? AppTheme.glowPurple.withValues(alpha: 0.3)
                        : colorScheme.outline.withValues(alpha: 0.2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark 
                          ? AppTheme.glowPurple.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: isDark 
                          ? AppTheme.accentMustard.withValues(alpha: 0.8)
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Cari di 89secondStuff...',
                        style: GoogleFonts.poppins(
                          color: isDark 
                            ? Colors.white.withValues(alpha: 0.5)
                            : colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ColorScheme colorScheme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                  ? [AppTheme.accentMustard, AppTheme.accentRed]
                  : [colorScheme.primary, colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhatsNewsSection(ColorScheme colorScheme, bool isDark) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("What's New", colorScheme, isDark),
        const SizedBox(height: 8),
        Obx(
          () {
            if (controller.isLoadingBanners.value) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: CircularProgressIndicator(
                    color: isDark ? AppTheme.accentMustard : colorScheme.primary,
                  ),
                ),
              );
            }
            if (controller.whatsNewProducts.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    "Produk tidak ditemukan",
                    style: TextStyle(color: isDark ? Colors.white70 : colorScheme.onSurface),
                  ),
                ),
              );
            }
            return Column(
              children: [
                CarouselSlider.builder(
                  carouselController: controller.carouselController,
                  itemCount: controller.whatsNewProducts.length,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.88,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    onPageChanged: controller.onSliderChanged,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final product = controller.whatsNewProducts[index];
                    return GestureDetector(
                      onTap: () => controller.onWhatsNewTap(index),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.deepPurpleLight : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Product Image
                              Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: isDark ? AppTheme.deepPurpleLight : Colors.grey[200],
                                  child: Icon(Icons.image, size: 48, color: isDark ? Colors.white38 : Colors.grey),
                                ),
                              ),
                              // Gradient Overlay
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                    stops: const [0.0, 0.4, 1.0],
                                  ),
                                ),
                              ),
                              // Product Info
                              Positioned(
                                left: 16,
                                right: 16,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // NEW Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [AppTheme.accentMustard, AppTheme.accentRed]),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text('NEW', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                    const SizedBox(height: 8),
                                    // Product Title
                                    Text(
                                      product.title,
                                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    // Price & Category
                                    Row(
                                      children: [
                                        Text(
                                          currencyFormat.format(product.price),
                                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.accentMustard),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withValues(alpha: 0.2),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(product.category, style: GoogleFonts.poppins(fontSize: 10, color: Colors.white70)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Tap indicator
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.touch_app, color: Colors.white.withValues(alpha: 0.8), size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                // Animated dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: controller.whatsNewProducts.asMap().entries.map((entry) {
                    final isActive = controller.currentSliderIndex.value == entry.key;
                    return GestureDetector(
                      onTap: () => controller.carouselController.animateToPage(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 24.0 : 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: isActive 
                            ? LinearGradient(
                                colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary],
                              )
                            : null,
                          color: isActive ? null : (isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.3)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeaturedProductsGrid(BuildContext context, ColorScheme colorScheme, bool isDark) {
    return Obx(() {
      if (controller.isLoadingGrid.value) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                color: isDark ? AppTheme.accentMustard : colorScheme.primary,
              ),
            ),
          ),
        );
      }
      if (controller.featuredProductsGrid.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                "Produk pilihan tidak ditemukan.",
                style: TextStyle(
                  color: isDark ? Colors.white70 : colorScheme.onSurface,
                ),
              ),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.68,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final Product product = controller.featuredProductsGrid[index];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400 + (index * 100)),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: ProductCard(
                  product: product,
                  onTap: () => controller.onProductTap(product),
                ),
              );
            },
            childCount: controller.featuredProductsGrid.length,
          ),
        ),
      );
    });
  }
}
