import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class SearchController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final TextEditingController searchC = TextEditingController();

  // Menyimpan semua produk dari API
  final _allProducts = <Product>[].obs;
  // Menyimpan hasil filter pencarian
  var searchResults = <Product>[].obs;

  var isLoading = false.obs;
  // Menandai apakah pencarian sudah pernah dilakukan
  var hasSearched = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil semua produk saat controller pertama kali di-load
    _fetchAllProducts();
  }

  void _fetchAllProducts() async {
    try {
      isLoading.value = true;
      var products = await _apiService.getAllProducts();
      _allProducts.assignAll(products);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data produk: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Dipanggil ketika user menekan 'submit' di keyboard
  void performSearch(String query) {
    if (query.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    hasSearched.value = true;
    // Filter dari daftar _allProducts
    var results = _allProducts.where((product) {
      // Cek apakah judul mengandung query (case-insensitive)
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    searchResults.assignAll(results);
  }

  // Membersihkan search bar
  void clearSearch() {
    searchC.clear();
    searchResults.clear();
    hasSearched.value = false;
  }

  // Navigasi ke detail produk
  void goToProductDetail(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
