import 'package:get/get.dart';
import 'user_list_controller.dart';

class AdminUserListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminUserListController>(() => AdminUserListController());
  }
}
