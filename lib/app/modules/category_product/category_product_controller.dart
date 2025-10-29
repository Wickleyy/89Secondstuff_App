import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class CategoryProductsController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  // Nama kategori yang diterima dari halaman sebelumnya
  var categoryName = ''.obs;

  // State untuk halaman
  var isLoading = true.obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil argumen (nama kategori) yang dikirim
    categoryName.value = Get.arguments as String;
    // Ambil data produk
    fetchProductsByCategory();
  }

  void fetchProductsByCategory() async {
    try {
      isLoading.value = true;
      var productList =
          await _apiService.getProductsByCategory(categoryName.value);
      products.assignAll(productList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigasi ke detail produk
  void onProductTap(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }
}
