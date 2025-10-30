import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';

class ProductDetailController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final cartController = Get.find<CartController>();

  var product = Rx<Product?>(null);
  var isLoadingCart = false.obs;
  var chainedProductResult = Rx<Product?>(null);
  var isChainedLoading = false.obs;
  var chainedLog = ''.obs;

  @override
  void onInit() {
    super.onInit();
    product.value = Get.arguments as Product;
  }

  void addToCart() async {
    if (product.value == null) return;

    // 1. Tambahkan ke keranjang lokal
    cartController.addToCart(product.value!);

    // 2. Opsional: sync ke API (FakeStore API tidak simpan permanen sebenarnya)
    isLoadingCart.value = true;
    try {
      await apiService.addToCart(2, product.value!.id, 1);
    } catch (e) {
      print("API Cart hanya simulasi, error: $e");
    } finally {
      isLoadingCart.value = false;
    }
  }

  void runChainedAsync() async {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Async/Await...\n';
    try {
      final result = await apiService.fetchFirstProductInCartAsync(2);
      chainedProductResult.value = result;
      chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
    } catch (e) {
      chainedLog.value += 'ERROR: $e';
    } finally {
      isChainedLoading.value = false;
    }
  }

  void runChainedCallback() {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Callback/Then...\n';
    apiService.fetchFirstProductInCartCallback(2).then((result) {
      chainedProductResult.value = result;
      chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
      isChainedLoading.value = false;
    }).catchError((e) {
      chainedLog.value += 'ERROR: $e';
      isChainedLoading.value = false;
    });
  }
}
