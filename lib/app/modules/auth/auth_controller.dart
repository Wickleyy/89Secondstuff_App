import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final TextEditingController usernameController = TextEditingController(
    text: 'mor_2314',
  );
  final TextEditingController passwordController = TextEditingController(
    text: '83r5^_',
  );

  var isLoading = false.obs;

  void login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final authToken = await _apiService.login(
        usernameController.text,
        passwordController.text,
      );

      isLoading.value = false;

      print('Login success, token: ${authToken.token}');
      Get.snackbar(
        'Success',
        'Login berhasil!',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goToSignUp() {
    Get.toNamed(AppRoutes.SIGNUP);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
