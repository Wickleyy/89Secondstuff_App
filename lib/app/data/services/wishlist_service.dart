import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';

class WishlistService extends GetxService {
  late Box<Map> _wishlistBox;
  final RxList<Product> wishlistItems = <Product>[].obs;

  Future<WishlistService> init() async {
    _wishlistBox = await Hive.openBox<Map>('wishlist');
    _loadWishlist();
    return this;
  }

  void _loadWishlist() {
    try {
      final items = _wishlistBox.values.map((item) {
        return Product.fromJson(Map<String, dynamic>.from(item));
      }).toList();
      wishlistItems.assignAll(items);
    } catch (e) {
      debugPrint('[WishlistService] Error loading wishlist: $e');
    }
  }

  bool isInWishlist(int productId) {
    return wishlistItems.any((item) => item.id == productId);
  }

  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  Future<void> addToWishlist(Product product) async {
    try {
      if (!isInWishlist(product.id)) {
        await _wishlistBox.put(product.id.toString(), product.toJson());
        wishlistItems.add(product);
        debugPrint('[WishlistService] Added to wishlist: ${product.title}');
      }
    } catch (e) {
      debugPrint('[WishlistService] Error adding to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(int productId) async {
    try {
      await _wishlistBox.delete(productId.toString());
      wishlistItems.removeWhere((item) => item.id == productId);
      debugPrint('[WishlistService] Removed from wishlist: $productId');
    } catch (e) {
      debugPrint('[WishlistService] Error removing from wishlist: $e');
    }
  }

  Future<void> clearWishlist() async {
    try {
      await _wishlistBox.clear();
      wishlistItems.clear();
    } catch (e) {
      debugPrint('[WishlistService] Error clearing wishlist: $e');
    }
  }

  int get itemCount => wishlistItems.length;
}
