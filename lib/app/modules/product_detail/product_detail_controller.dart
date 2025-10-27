import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';

class ProductDetailController extends GetxController {
  final ApiService apiService;
  ProductDetailController({required this.apiService});

  // Produk yang ditampilkan di halaman ini
  var product = Rx<Product?>(null);

  // Untuk hasil chained request
  var chainedProductResult = Rx<Product?>(null);
  var isChainedLoading = false.obs;
  var chainedLog = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data produk yang dikirim dari halaman sebelumnya
    product.value = Get.arguments as Product;
  }

  // Fungsi untuk memicu chained request (Async/Await)
  void runChainedAsync() async {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Async/Await...\n';
    try {
      // User ID 2 sebagai contoh
      final result = await apiService.fetchFirstProductInCartAsync(2);
      chainedProductResult.value = result;
      chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
    } catch (e) {
      chainedLog.value += 'ERROR: $e';
    } finally {
      isChainedLoading.value = false;
    }
  }

  // Fungsi untuk memicu chained request (Callback/Then)
  void runChainedCallback() {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Callback/Then...\n';
    apiService
        .fetchFirstProductInCartCallback(2)
        .then((result) {
          chainedProductResult.value = result;
          chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
          isChainedLoading.value = false;
        })
        .catchError((e) {
          chainedLog.value += 'ERROR: $e';
          isChainedLoading.value = false;
        });
  }
}
