import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';

class AccountController extends GetxController {
  // Ambil theme controller yang sudah ada
  final ThemeController themeController = Get.find();

  // Data user (dummy)
  final String username = "mor_2314";
  final String email = "mor_2314@fakestore.com";
  final String initial = "M"; // Inisial untuk avatar

  void logout() {
    // Tampilkan konfirmasi (di aplikasi nyata)
    // Untuk sekarang, langsung logout dan kembali ke login
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  void goToOrderHistory() {
    Get.snackbar('Info', 'Halaman Riwayat Pesanan belum tersedia.',
        snackPosition: SnackPosition.BOTTOM);
  }

  void goToEditProfile() {
    Get.snackbar('Info', 'Halaman Edit Profil belum tersedia.',
        snackPosition: SnackPosition.BOTTOM);
  }
}
