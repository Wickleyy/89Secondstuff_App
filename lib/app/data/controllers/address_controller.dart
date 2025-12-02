import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/modules/account/shipping_address/models/shipping_address_model.dart';

class AddressController extends GetxController {
  SupabaseService get _supabase => Get.find<SupabaseService>();

  final RxList<ShippingAddress> addresses = <ShippingAddress>[].obs;
  final Rx<ShippingAddress?> selectedAddress = Rx<ShippingAddress?>(null);
  final Rx<ShippingAddress?> defaultAddress = Rx<ShippingAddress?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<SupabaseService>()) {
      loadAddresses();
    }
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) return;

      final response = await _supabase.client
          .from('shipping_addresses')
          .select()
          .eq('user_id', user.id)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);

      final List<dynamic> data = response;
      final addressList = data
          .map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
          .toList();

      addresses.assignAll(addressList);

      defaultAddress.value = addressList.firstWhereOrNull((a) => a.isDefault);
      
      if (selectedAddress.value == null && defaultAddress.value != null) {
        selectedAddress.value = defaultAddress.value;
      }
    } catch (e) {
      print('Error loading addresses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(ShippingAddress address) {
    selectedAddress.value = address;
  }

  void clearSelectedAddress() {
    selectedAddress.value = null;
  }

  ShippingAddress? getAddressById(int id) {
    return addresses.firstWhereOrNull((a) => a.id == id);
  }

  bool get hasAddresses => addresses.isNotEmpty;
  
  bool get hasSelectedAddress => selectedAddress.value != null;

  String get selectedAddressDisplay {
    if (selectedAddress.value == null) return 'Pilih alamat pengiriman';
    return selectedAddress.value!.fullAddress;
  }

  @override
  void refresh() {
    loadAddresses();
  }
}
