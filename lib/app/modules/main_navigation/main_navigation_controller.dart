import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;
  var isFromAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if navigated from admin dashboard
    final args = Get.arguments;
    if (args != null && args is Map && args['fromAdmin'] == true) {
      isFromAdmin.value = true;
    }
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void goBackToAdmin() {
    Get.back();
  }
}
