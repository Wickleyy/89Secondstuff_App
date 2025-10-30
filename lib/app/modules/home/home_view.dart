import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/widgets/product_card.dart';
import 'package:_89_secondstufff/app/modules/main_navigation/main_navigation_controller.dart';
import 'package:_89_secondstufff/app/widgets/app_drawer.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  // --- FIX: Pindahkan GlobalKey ke sini ---
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // --- AKHIR FIX ---

  final MainNavigationController mainNavController =
      Get.find<MainNavigationController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      // --- FIX: Gunakan key lokal ---
      key: _scaffoldKey,
      drawer: AppDrawer(),
      // --- AKHIR FIX ---
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: colorScheme.onSurface),
          onPressed: () {
            // --- FIX: Panggil key lokal ---
            _scaffoldKey.currentState?.openDrawer();
            // --- AKHIR FIX ---
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            readOnly: true,
            onTap: () {
              // Navigasi ke tab Search (index 1)
              Get.find<MainNavigationController>().changePage(1);
            },
            decoration: InputDecoration(
              hintText: 'Cari di 89secondStuff...',
              hintStyle:
                  TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWhatsNewsSection(colorScheme),

            // --- GANTI BAGIAN KATEGORI ---
            _buildFeaturedProductsSection(context, colorScheme),
            // --- AKHIR GANTI ---
          ],
        ),
      ),
    );
  }

  Widget _buildWhatsNewsSection(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "What's News",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () {
              if (controller.isLoadingBanners.value) {
                return const Center(child: CircularProgressIndicator());
              }
              // --- FIX: Ganti nama variabel ---
              if (controller.sliderProducts.isEmpty) {
                return const Center(child: Text("Banner tidak ditemukan"));
              }
              return Column(
                children: [
                  CarouselSlider(
                    carouselController: controller.carouselController,
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.85,
                      enlargeCenterPage: true,
                      onPageChanged: controller.onSliderChanged,
                    ),
                    // --- FIX: Ganti nama variabel ---
                    items: controller.sliderProducts.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: NetworkImage(item),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        // --- FIX: Ganti nama variabel ---
                        controller.sliderProducts.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => controller.carouselController
                            .animateToPage(entry.key),
                        child: Container(
                          // --- FIX: Ganti nama variabel ---
                          width:
                              controller.currentSliderIndex.value == entry.key
                                  ? 12.0
                                  : 8.0,
                          height:
                              controller.currentSliderIndex.value == entry.key
                                  ? 12.0
                                  : 8.0,
                          // --- AKHIR FIX ---
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: (colorScheme.primary).withOpacity(
                                // --- FIX: Ganti nama variabel ---
                                controller.currentSliderIndex.value == entry.key
                                    ? 0.9
                                    : 0.4),
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
      ),
    );
  }

  // --- FUNGSI BARU: GRID PRODUK PILIHAN ---
  Widget _buildFeaturedProductsSection(
      BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Produk Pilihan",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Obx(() {
            // --- FIX: Ganti nama variabel ---
            if (controller.isLoadingGrid.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.featuredProductsGrid.isEmpty) {
              // --- FIX: Ganti nama variabel ---
              return const Center(
                  child: Text("Produk pilihan tidak ditemukan."));
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 kolom
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7, // Sesuaikan rasio untuk ProductCard
              ),
              // --- FIX: Ganti nama variabel ---
              itemCount: controller.featuredProductsGrid.length,
              itemBuilder: (context, index) {
                final Product product =
                    controller.featuredProductsGrid[index]; // --- FIX ---
                return ProductCard(
                  product: product,
                  // --- FIX: Ganti nama fungsi ---
                  onTap: () => controller.onProductTap(product),
                );
              },
            );
          }),
        ],
      ),
    );
  }
  // --- AKHIR FUNGSI BARU ---
}
