import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final ProductProvider _productProvider = Get.find<ProductProvider>();
  final CarouselSliderController carouselController = CarouselSliderController();

  var currentSliderIndex = 0.obs;
  
  // Simpan produk lengkap (bukan hanya image) untuk carousel
  var whatsNewProducts = <Product>[].obs;
  var isLoadingBanners = true.obs;
  
  var featuredProductsGrid = <Product>[].obs;
  var isLoadingGrid = true.obs;

  // Untuk backward compatibility
  List<String> get sliderProducts => whatsNewProducts.map((p) => p.image).toList();

  @override
  void onInit() {
    super.onInit();
    fetchWhatsNewProducts();
    fetchFeaturedGrid();
  }

  // Fetch produk terbaru untuk What's New (dari semua kategori, limit 5)
  void fetchWhatsNewProducts() async {
    try {
      isLoadingBanners.value = true;
      
      // Ambil semua produk, lalu ambil 5 terbaru
      var products = await _productProvider.getAllProducts();
      
      if (products.isNotEmpty) {
        // Ambil 5 produk pertama (terbaru) untuk carousel
        final latestProducts = products.take(5).toList();
        whatsNewProducts.assignAll(latestProducts);
      }
    } catch (e) {
      debugPrint("Error fetch what's new products: $e");
    } finally {
      isLoadingBanners.value = false;
    }
  }

  void fetchFeaturedGrid() async {
    try {
      isLoadingGrid.value = true;
      
      // Ambil semua produk untuk grid
      var products = await _productProvider.getAllProducts();
      
      if (products.isNotEmpty) {
        // Skip 5 produk pertama (yang sudah di carousel), ambil sisanya
        final gridProducts = products.skip(5).take(10).toList();
        
        // Jika tidak cukup, ambil dari awal
        if (gridProducts.isEmpty) {
          featuredProductsGrid.assignAll(products.take(10).toList());
        } else {
          featuredProductsGrid.assignAll(gridProducts);
        }
      }
    } catch (e) {
      debugPrint("Error fetch featured grid: $e");
    } finally {
      isLoadingGrid.value = false;
    }
  }

  void onSliderChanged(int index, CarouselPageChangedReason reason) {
    currentSliderIndex.value = index;
  }

  // Navigate ke product detail dari carousel
  void onWhatsNewTap(int index) {
    if (index >= 0 && index < whatsNewProducts.length) {
      Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: whatsNewProducts[index]);
    }
  }

  void onProductTap(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  // Refresh semua data
  Future<void> refreshData() async {
    await Future.wait([
      Future(() => fetchWhatsNewProducts()),
      Future(() => fetchFeaturedGrid()),
    ]);
  }
}
