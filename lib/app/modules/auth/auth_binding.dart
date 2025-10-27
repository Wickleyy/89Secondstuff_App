import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inisialisasi ApiService di sini
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
