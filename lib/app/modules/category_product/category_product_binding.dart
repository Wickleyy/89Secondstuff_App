import 'package:get/get.dart';
import 'category_product_controller.dart';

class CategoryProductsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryProductsController>(
      () => CategoryProductsController(),
    );
  }
}
