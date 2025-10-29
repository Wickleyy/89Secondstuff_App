import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class CategoriesController extends GetxController {
  // --- PERUBAHAN DI SINI ---
  final ApiService apiService = Get.find<ApiService>();

  var isLoading = true.obs;
  var categories = <String>[].obs;
  // --- AKHIR PERUBAHAN ---

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // --- FUNGSI BARU ---
  void fetchCategories() async {
    try {
      isLoading.value = true;
      var fetchedCategories = await apiService.getCategories();

      // --- PERBAIKAN: Tampilkan semua kategori, jangan difilter ---
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat kategori: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCategoryTap(String apiCategoryName) {
    // Navigasi ke halaman produk berdasarkan kategori
    Get.toNamed(
      AppRoutes.CATEGORY_PRODUCTS,
      arguments: apiCategoryName,
    );
  }

  // --- TAMBAHAN BARU: Metode yang hilang ---
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case "electronics":
        return Icons.devices_other; // Icon untuk elektronik
      case "jewelery":
        return Icons.diamond_outlined;
      case "men's clothing":
        return Icons.man;
      case "women's clothing":
        return Icons.woman;
      default:
        return Icons.category; // Icon default
    }
  }
  // --- AKHIR TAMBAHAN ---
}
