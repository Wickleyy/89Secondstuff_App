import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart'; // 1. Import Service Notifikasi
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();

  // Getter untuk mengambil data dari service
  List<Product> get wishlistItems => _wishlistService.wishlistItems;

  bool isInWishlist(int productId) => _wishlistService.isInWishlist(productId);

  // Method Toggle (Tambah/Hapus) dengan Logika Notifikasi
  void toggleWishlist(Product product) {
    // 1. Lakukan aksi toggle di service (Simpan/Hapus dari DB/Hive)
    _wishlistService.toggleWishlist(product);

    // 2. Cek statusnya SEKARANG (Setelah di-toggle)
    if (_wishlistService.isInWishlist(product.id)) {
      // KASUS: BERHASIL DITAMBAHKAN KE WISHLIST

      // [FITUR NOTIFIKASI]
      // Subscribe ke topik produk ini agar dapat info diskon/stok
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
      // KASUS: BERHASIL DIHAPUS DARI WISHLIST

      // [FITUR NOTIFIKASI]
      // Unsubscribe agar tidak menyampah notifikasi user
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

    // Update UI
    update();
  }

  // Method Hapus Manual (misal swipe to delete)
  void removeFromWishlist(int productId) {
    _wishlistService.removeFromWishlist(productId);

    // [FITUR NOTIFIKASI]
    // Unsubscribe produk ini
    NotificationService.to.unsubscribeFromProduct(productId.toString());

    update();
  }

  void goToProductDetail(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  int get itemCount => _wishlistService.itemCount;
}
