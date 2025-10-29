import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/widgets/category_card.dart';
import 'categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kategori",
          style: GoogleFonts.poppins(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      // --- PERUBAHAN DARI LISTVIEW KE GRIDVIEW ---
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.categories.isEmpty) {
          return const Center(child: Text("Kategori tidak ditemukan"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0, // Kartu akan berbentuk persegi
          ),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final categoryName = controller.categories[index];
            final categoryIcon = controller.getCategoryIcon(categoryName);

            // Menggunakan CategoryCard yang sudah ada
            return CategoryCard(
              icon: categoryIcon,
              name: categoryName.capitalizeFirst ?? categoryName,
              onTap: () => controller.onCategoryTap(categoryName),
            );
          },
        );
      }),
      // --- AKHIR PERUBAHAN ---
    );
  }
}
