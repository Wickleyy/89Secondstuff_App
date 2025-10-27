// --- FIX: Tambahkan 'hide' untuk menghindari konflik ---
//import 'package:flutter/material.dart';
import 'package:get/get.dart';
// --- FIX: Hapus prefix 'as slider' ---
import 'package:carousel_slider/carousel_slider.dart';
// --- IMPORT YANG BENAR ---
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
// --- FIX: Import ini wajib ada ---
import 'package:_89_secondstufff/app/routes/app_pages.dart';
// --- AKHIR IMPORT ---

class HomeController extends GetxController {
  final ApiService apiService;
  HomeController({required this.apiService});

  // --- FIX: Hapus prefix 'slider.' ---
  final CarouselSliderController carouselController =
      CarouselSliderController();
  var currentSliderIndex = 0.obs;
  // --- AKHIR FIX ---

  var sliderProducts = <String>[].obs; // Untuk What's News
  var isLoadingBanners = true.obs;

  var featuredProductsGrid = <Product>[].obs; // Untuk Produk Pilihan
  var isLoadingGrid = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliderProducts();
    fetchFeaturedGrid(); // Panggil fungsi untuk grid
  }

  void fetchSliderProducts() async {
    try {
      isLoadingBanners.value = true;
      // Ambil produk elektronik untuk slider
      var products = await apiService.getProductsByCategory("electronics");
      if (products.isNotEmpty) {
        sliderProducts.assignAll(products.take(5).map((p) => p.image).toList());
      }
    } catch (e) {
      print("Error fetch slider products: $e");
    } finally {
      isLoadingBanners.value = false;
    }
  }

  void fetchFeaturedGrid() async {
    try {
      isLoadingGrid.value = true;
      // Ambil produk perhiasan untuk grid
      var products = await apiService.getProductsByCategory("jewelery");
      featuredProductsGrid.assignAll(products.take(6)); // Ambil 6 produk
    } catch (e) {
      print("Error fetch featured grid: $e");
    } finally {
      isLoadingGrid.value = false;
    }
  }

  // --- FIX: Hapus prefix 'slider.' ---
  void onSliderChanged(int index, CarouselPageChangedReason reason) {
    currentSliderIndex.value = index;
  }
  // --- AKHIR FIX ---

  void onProductTap(Product product) {
    // --- FIX: 'AppRoutes' sekarang terdefinisi ---
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }
}
