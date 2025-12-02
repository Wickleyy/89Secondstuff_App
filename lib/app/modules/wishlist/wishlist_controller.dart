import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/wishlist_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class WishlistController extends GetxController {
  final WishlistService _wishlistService = Get.find<WishlistService>();

  List<Product> get wishlistItems => _wishlistService.wishlistItems;
  
  bool isInWishlist(int productId) => _wishlistService.isInWishlist(productId);

  void toggleWishlist(Product product) {
    _wishlistService.toggleWishlist(product);
  }

  void removeFromWishlist(int productId) {
    _wishlistService.removeFromWishlist(productId);
  }

  void goToProductDetail(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  int get itemCount => _wishlistService.itemCount;
}
