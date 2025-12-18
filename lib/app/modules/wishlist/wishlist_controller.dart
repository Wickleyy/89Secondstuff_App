import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();

  List<Product> get wishlistItems => _wishlistService.wishlistItems;
  bool isInWishlist(int productId) => _wishlistService.isInWishlist(productId);

  void toggleWishlist(Product product) {
    _wishlistService.toggleWishlist(product);

    if (_wishlistService.isInWishlist(product.id)) {
      NotificationService.to.subscribeToProduct(product.id.toString());

      Get.snackbar(
        'Wishlist',
        '${product.title} ditambahkan ke wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.pink,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.favorite, color: Colors.white),
      );
    } else {
      NotificationService.to.unsubscribeFromProduct(product.id.toString());

      Get.snackbar(
        'Wishlist',
        '${product.title} dihapus dari wishlist',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[800],
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        icon: const Icon(Icons.delete_outline, color: Colors.white),
      );
    }

    update();
  }

  void removeFromWishlist(int productId) {
    _wishlistService.removeFromWishlist(productId);
    NotificationService.to.unsubscribeFromProduct(productId.toString());
    update();
  }

  void goToProductDetail(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  int get itemCount => _wishlistService.itemCount;
}
