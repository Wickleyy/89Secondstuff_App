import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController(text: 'mor_2314');
    emailController = TextEditingController(text: 'mor_2314@fakestore.com');
    phoneController = TextEditingController(text: '+62 812-3456-7890');
  }

  void saveProfile() async {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Semua field harus diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Simulasi API call
      await Future.delayed(const Duration(seconds: 1));

      Get.snackbar(
        'Success',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui profil: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}