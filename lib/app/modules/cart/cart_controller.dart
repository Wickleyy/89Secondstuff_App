import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart'; // Import Service Notifikasi

class CartController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  Box<CartItem> get _cartBox => _localStorage.cartBox;

  // Method untuk menambah produk ke keranjang
  void addToCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;
      existingItem.quantity += 1;
      existingItem.save(); // Simpan perubahan ke Hive
    } else {
      final newItem = CartItem.fromProduct(product);
      _cartBox.put(product.id, newItem); // Tambah item baru ke Hive

      // [FITUR NOTIFIKASI]
      // Subscribe ke topik produk ini saat pertama kali masuk cart
      // Agar user dapat notif jika stok produk ini menipis
      NotificationService.to.subscribeToProduct(product.id.toString());
    }

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${product.title} ditambahkan ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Kita panggil update() agar getter (totalPrice/totalItemCount)
    // yang ada di dalam Obx() ikut diperbarui
    update();
  }

  // Method untuk menghapus produk dari keranjang
  void removeFromCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;

      if (existingItem.quantity > 1) {
        // Jika jumlah > 1, kurangi saja
        existingItem.quantity -= 1;
        existingItem.save();
      } else {
        // Jika jumlah sisa 1 dan dihapus, maka hapus dari Hive
        _cartBox.delete(product.id);

        // [FITUR NOTIFIKASI]
        // Unsubscribe dari topik produk ini karena sudah tidak ada di cart
        // User tidak akan diganggu lagi soal stok produk ini
        NotificationService.to.unsubscribeFromProduct(product.id.toString());
      }

      // Panggil update() untuk memperbarui UI
      update();
    }
  }

  // --- COMPUTED PROPERTY (Getter) ---
  double get totalPrice {
    return _cartBox.values
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, price) => prev + price);
  }

  int get totalItemCount {
    return _cartBox.values.fold(0, (prev, item) => prev + item.quantity);
  }
}
