import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/services/payment_service.dart';
import 'package:_89_secondstufff/app/data/services/order_service.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/controllers/address_controller.dart';
import 'package:_89_secondstufff/app/modules/account/shipping_address/models/shipping_address_model.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/modules/checkout/checkout_view.dart';

class CheckoutController extends GetxController {
  final LocalStorageService _localStorage = Get.find<LocalStorageService>();
  final PaymentService _paymentService = Get.find<PaymentService>();
  final OrderService _orderService = Get.find<OrderService>();
  final SupabaseService _supabase = Get.find<SupabaseService>();
  final AddressController addressController = Get.find<AddressController>();

  Box<CartItem> get _cartBox => _localStorage.cartBox;

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble subtotal = 0.0.obs;
  final RxDouble shippingCost = 15000.0.obs;
  final RxDouble total = 0.0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxString? currentOrderId = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
    calculateTotal();
  }

  void loadCartItems() {
    cartItems.assignAll(_cartBox.values.toList());
  }

  void calculateTotal() {
    subtotal.value = cartItems.fold(
      0.0, 
      (sum, item) => sum + (item.price * item.quantity)
    );
    total.value = subtotal.value + shippingCost.value;
  }

  ShippingAddress? get selectedAddress => addressController.selectedAddress.value;
  bool get hasSelectedAddress => addressController.hasSelectedAddress;
  List<ShippingAddress> get allAddresses => addressController.addresses;

  void selectAddress(ShippingAddress address) {
    addressController.selectAddress(address);
  }

  void showAddressSelector() {
    if (allAddresses.isEmpty) {
      Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
      return;
    }
    
    Get.bottomSheet(
      AddressSelectorSheet(
        addresses: allAddresses,
        selectedAddress: selectedAddress,
        onSelect: (address) {
          selectAddress(address);
          Get.back();
        },
        onAddNew: () {
          Get.back();
          Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
        },
      ),
      isScrollControlled: true,
    );
  }

  String get userEmail => _supabase.currentUser?.email ?? '';

  Future<void> processPayment() async {
    if (!hasSelectedAddress) {
      Get.snackbar(
        'Alamat Belum Dipilih',
        'Silakan pilih alamat pengiriman terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (cartItems.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tidak ada item dalam keranjang',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isProcessingPayment.value = true;

      final orderId = _paymentService.generateOrderId();
      currentOrderId?.value = orderId;

      final snapResponse = await _paymentService.createSnapToken(
        orderId: orderId,
        grossAmount: total.value,
        items: cartItems.toList(),
        address: selectedAddress!,
        customerEmail: userEmail,
        shippingCost: shippingCost.value,
      );

      if (snapResponse == null) {
        throw Exception('Gagal membuat token pembayaran');
      }

      final order = await _orderService.createOrder(
        addressId: selectedAddress!.id,
        items: cartItems.toList(),
        total: total.value,
      );

      if (order == null) {
        throw Exception('Gagal membuat pesanan');
      }

      await _paymentService.startPayment(
        snapToken: snapResponse['token'],
        redirectUrl: snapResponse['redirect_url'],
        onSuccess: (result) => _handlePaymentSuccess(orderId, result),
        onPending: (result) => _handlePaymentPending(orderId, result, snapResponse['redirect_url']),
        onError: (result) => _handlePaymentError(orderId, result),
        onClosed: () => _handlePaymentClosed(orderId),
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  Future<void> _handlePaymentSuccess(String orderId, dynamic result) async {
    await _orderService.updatePaymentStatus(
      orderId: orderId,
      paymentStatus: 'settlement',
      transactionId: result?['transaction_id'],
      paymentMethod: result?['payment_type'],
    );

    _clearCart();

    Get.offAllNamed(
      AppRoutes.PAYMENT_STATUS,
      arguments: {'orderId': orderId, 'status': 'success'},
    );
  }

  Future<void> _handlePaymentPending(String orderId, dynamic result, [String? redirectUrl]) async {
    await _orderService.updatePaymentStatus(
      orderId: orderId,
      paymentStatus: 'pending',
      transactionId: result?['transaction_id'],
      paymentMethod: result?['payment_type'],
    );

    Get.offAllNamed(
      AppRoutes.PAYMENT_STATUS,
      arguments: {
        'orderId': orderId, 
        'status': 'pending',
        'redirectUrl': redirectUrl ?? result?['redirect_url'],
      },
    );
  }

  Future<void> _handlePaymentError(String orderId, dynamic result) async {
    await _orderService.updatePaymentStatus(
      orderId: orderId,
      paymentStatus: 'failed',
    );

    Get.snackbar(
      'Pembayaran Gagal',
      'Silakan coba lagi',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  void _handlePaymentClosed(String orderId) {
    Get.snackbar(
      'Pembayaran Dibatalkan',
      'Anda dapat melanjutkan pembayaran dari riwayat pesanan',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _clearCart() {
    _cartBox.clear();
    cartItems.clear();
  }
}
