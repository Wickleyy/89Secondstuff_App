import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/main_navigation/main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Controller utama untuk navigasi
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
  }
}
