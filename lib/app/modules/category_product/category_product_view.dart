import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/widgets/product_card.dart';
import 'category_product_controller.dart';

class CategoryProductsView extends GetView<CategoryProductsController> {
  const CategoryProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Judul AppBar dinamis berdasarkan kategori
        title: Obx(() => Text(
              controller.categoryName.value.capitalizeFirst ?? 'Produk',
            )),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text('Produk tidak ditemukan.'));
        }

        // Tampilkan GridView produk
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7, // Sesuaikan rasio untuk ProductCard
          ),
          itemCount: controller.products.length,
          itemBuilder: (context, index) {
            final Product product = controller.products[index];
            return ProductCard(
              product: product,
              onTap: () => controller.onProductTap(product),
            );
          },
        );
      }),
    );
  }
}
