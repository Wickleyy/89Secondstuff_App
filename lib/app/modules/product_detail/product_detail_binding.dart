import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/product_detail/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(),
    );
  }
}
