import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';

class CartController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  Box<CartItem> get _cartBox => _localStorage.cartBox;

  void addToCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;
      existingItem.quantity += 1;
      existingItem.save();
    } else {
      final newItem = CartItem.fromProduct(product);
      _cartBox.put(product.id, newItem);

      NotificationService.to.subscribeToProduct(product.id.toString());
    }

    Get.snackbar(
      'Berhasil Ditambahkan',
      '${product.title} ditambahkan ke keranjang.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    update();
  }

  void removeFromCart(Product product) {
    if (_cartBox.containsKey(product.id)) {
      final existingItem = _cartBox.get(product.id)!;

      if (existingItem.quantity > 1) {
        existingItem.quantity -= 1;
        existingItem.save();
      } else {
        _cartBox.delete(product.id);
        NotificationService.to.unsubscribeFromProduct(product.id.toString());
      }
      update();
    }
  }

  double get totalPrice {
    return _cartBox.values
        .map((item) => item.price * item.quantity)
        .fold(0.0, (prev, price) => prev + price);
  }

  int get totalItemCount {
    return _cartBox.values.fold(0, (prev, item) => prev + item.quantity);
  }
}
