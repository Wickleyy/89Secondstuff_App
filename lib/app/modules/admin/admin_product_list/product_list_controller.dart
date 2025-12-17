import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class AdminProductListController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var isLoading = true.obs;
  var productList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;

      // [PERBAIKAN] Select kolom secara eksplisit sesuai tabel DB
      // Perhatikan: kolom di DB adalah 'image_url', bukan 'image'
      final response = await _supabase.client
          .from('products')
          .select(
              'id, title, price, stock, description, image_url, category_id, categories(id, name)')
          .order('id', ascending: false);

      final products =
          (response as List).map((data) => Product.fromJson(data)).toList();

      productList.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat produk: $e');
      print("Product Error: $e"); // Cek debug console jika masih error
    } finally {
      isLoading.value = false;
    }
  }

  void deleteProduct(int id) async {
    try {
      await _supabase.client.from('products').delete().eq('id', id);
      fetchProducts();
      Get.snackbar('Sukses', 'Produk berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus produk: $e');
    }
  }

  void goToAddProduct() {
    Get.toNamed(AppRoutes.ADMIN_PRODUCT_FORM)?.then((_) => fetchProducts());
  }

  void goToEditProduct(Product product) {
    Get.toNamed(AppRoutes.ADMIN_PRODUCT_FORM, arguments: product)
        ?.then((_) => fetchProducts());
  }
}
