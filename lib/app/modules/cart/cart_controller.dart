import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';

class CartController extends GetxController {
  // Kita akan simpan item sebagai Map<Product, int> (Produk, Kuantitas)
  // .obs membuat Map ini reaktif
  var cartItems = <Product, int>{}.obs;

  // Method untuk menambah produk ke keranjang
  void addToCart(Product product) {
    if (cartItems.containsKey(product)) {
      // Jika produk sudah ada, tambah kuantitasnya
      cartItems[product] = cartItems[product]! + 1;
    } else {
      // Jika produk baru, tambahkan ke map dengan kuantitas 1
      cartItems[product] = 1;
    }
    // Tampilkan snackbar konfirmasi
    Get.snackbar(
      'Berhasil Ditambahkan',
      '${product.title} ditambahkan ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Method untuk menghapus produk dari keranjang
  void removeFromCart(Product product) {
    if (cartItems.containsKey(product)) {
      if (cartItems[product]! > 1) {
        // Jika kuantitas > 1, kurangi 1
        cartItems[product] = cartItems[product]! - 1;
      } else {
        // Jika kuantitas 1, hapus produk dari map
        cartItems.remove(product);
      }
    }
  }

  // Computed property untuk menghitung total harga
  // 'totalPrice' akan otomatis update setiap kali 'cartItems' berubah
  double get totalPrice => cartItems.entries
      .map((entry) => entry.key.price * entry.value)
      .fold(0, (prev, price) => prev + price);

  // Computed property untuk total item (bukan total produk unik)
  int get totalItemCount => cartItems.values.fold(0, (prev, qty) => prev + qty);
}
