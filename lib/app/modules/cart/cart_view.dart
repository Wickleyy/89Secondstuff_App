import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Keranjang Saya',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Keranjang Anda kosong',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ayo tambahkan beberapa produk!',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            );
          }
          // Jika keranjang tidak kosong, tampilkan list
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final product = controller.cartItems.keys.elementAt(index);
                    final quantity =
                        controller.cartItems.values.elementAt(index);
                    return _buildCartItemTile(theme, product, quantity);
                  },
                ),
              ),
              _buildCheckoutSummary(theme, colorScheme),
            ],
          );
        },
      ),
    );
  }

  // Widget untuk satu item di keranjang
  Widget _buildCartItemTile(ThemeData theme, dynamic product, int quantity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Gambar
            Container(
              width: 80,
              height: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.network(product.image, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            // Info Produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Kuantitas
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.add, color: theme.colorScheme.primary),
                  onPressed: () => controller.addToCart(product),
                ),
                Text(
                  quantity.toString(),
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.remove, color: theme.colorScheme.error),
                  onPressed: () => controller.removeFromCart(product),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk ringkasan di bawah
  Widget _buildCheckoutSummary(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Total Harga
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${controller.totalItemCount} item):',
                  style: theme.textTheme.bodyLarge,
                ),
                Obx(
                  () => Text(
                    '\$${controller.totalPrice.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tombol Checkout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.snackbar('Info', 'Fitur Checkout belum tersedia',
                      snackPosition: SnackPosition.BOTTOM);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('CHECKOUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
