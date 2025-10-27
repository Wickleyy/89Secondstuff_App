import 'package:flutter/material.dart';
import 'package:get/get.dart';
// --- FIX: Tambahkan import ini ---
import 'package:_89_secondstufff/app/routes/app_pages.dart';
// --- AKHIR FIX ---

class CategoriesController extends GetxController {
  final List<Map<String, dynamic>> categoryListItems = [
    {"name": "Baju Wanita", "apiName": "women's clothing", "icon": Icons.woman},
    {"name": "Baju Pria", "apiName": "men's clothing", "icon": Icons.man},
    {
      "name": "Perhiasan",
      "apiName": "jewelery",
      "icon": Icons.diamond_outlined
    },
  ];

  void onCategoryTap(String apiCategoryName) {
    // --- FIX: Gunakan 'AppRoutes' yang sudah di-import ---
    Get.toNamed(
      AppRoutes.CATEGORY_PRODUCTS,
      arguments: apiCategoryName,
    );
  }
}
