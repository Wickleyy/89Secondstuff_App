import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final CarouselSliderController carouselController =
      CarouselSliderController();

  var currentSliderIndex = 0.obs;
  var sliderProducts = <String>[].obs;
  var isLoadingBanners = true.obs;
  var featuredProductsGrid = <Product>[].obs;
  var isLoadingGrid = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliderProducts();
    fetchFeaturedGrid();
  }

  void fetchSliderProducts() async {
    try {
      isLoadingBanners.value = true;
      var products = await apiService.getProductsByCategory("electronics");
      if (products.isNotEmpty) {
        sliderProducts.assignAll(products.take(5).map((p) => p.image).toList());
      }
    } catch (e) {
      print("Error fetch slider products: $e");
      Get.snackbar(
        "Error",
        "Gagal memuat banner: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingBanners.value = false;
    }
  }

  void fetchFeaturedGrid() async {
    try {
      isLoadingGrid.value = true;
      var products = await apiService.getProductsByCategory("jewelery");
      featuredProductsGrid.assignAll(products.take(6));
    } catch (e) {
      print("Error fetch featured grid: $e");
      Get.snackbar(
        "Error",
        "Gagal memuat produk: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingGrid.value = false;
    }
  }

  void onSliderChanged(int index, CarouselPageChangedReason reason) {
    currentSliderIndex.value = index;
  }

  void onProductTap(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }
}
