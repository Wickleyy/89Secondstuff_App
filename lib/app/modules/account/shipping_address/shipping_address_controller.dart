import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/controllers/address_controller.dart';
import 'models/shipping_address_model.dart';
import 'address_form_view.dart';
import 'map_picker/map_picker_view.dart';
import 'map_picker/map_picker_binding.dart';

class ShippingAddressController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var addresses = <ShippingAddress>[].obs;
  var isLoading = false.obs;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController cityController;
  late TextEditingController provinceController;
  late TextEditingController postalCodeController;
  var isDefaultAddress = false.obs;
  
  final Rx<double?> selectedLatitude = Rx<double?>(null);
  final Rx<double?> selectedLongitude = Rx<double?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    loadAddresses();
  }

  void _initializeControllers() {
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();
    cityController = TextEditingController();
    provinceController = TextEditingController();
    postalCodeController = TextEditingController();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) {
        debugPrint('[Address] No user found, cannot load addresses');
        return;
      }

      debugPrint('[Address] Loading addresses for user: ${user.id}');

      final response = await _supabase.client
          .from('shipping_addresses')
          .select()
          .eq('user_id', user.id)
          .order('is_default', ascending: false)
          .order('created_at', ascending: false);

      debugPrint('[Address] Load response: $response');

      final List<dynamic> data = response;
      final addressList = data
          .map((e) => ShippingAddress.fromJson(e as Map<String, dynamic>))
          .toList();

      addresses.assignAll(addressList);
      debugPrint('[Address] Loaded ${addressList.length} addresses');
    } catch (e) {
      debugPrint('[Address] Error loading addresses: $e');
      _showErrorSnackbar('Gagal memuat alamat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createAddress() async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) {
        _showErrorSnackbar('Anda harus login terlebih dahulu');
        return;
      }

      debugPrint('[Address] Creating address for user: ${user.id}');

      if (isDefaultAddress.value) {
        await _setAllAddressesNonDefault(user.id);
      }

      final addressData = {
        'user_id': user.id,
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'city': cityController.text.trim(),
        'province': provinceController.text.trim(),
        'postal_code': postalCodeController.text.trim(),
        'is_default': isDefaultAddress.value,
        'latitude': selectedLatitude.value,
        'longitude': selectedLongitude.value,
      };

      debugPrint('[Address] Insert data: $addressData');

      final response = await _supabase.client
          .from('shipping_addresses')
          .insert(addressData)
          .select();

      debugPrint('[Address] Insert response: $response');

      Get.back();
      await loadAddresses();
      _syncToGlobalAddressController();
      _showSuccessSnackbar('Alamat berhasil ditambahkan');
      _clearForm();
    } catch (e) {
      debugPrint('[Address] Error creating address: $e');
      _showErrorSnackbar('Gagal menambahkan alamat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(int addressId) async {
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      if (isDefaultAddress.value) {
        await _setAllAddressesNonDefault(user.id, excludeId: addressId);
      }

      final updatedData = {
        'name': nameController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'city': cityController.text,
        'province': provinceController.text,
        'postal_code': postalCodeController.text,
        'is_default': isDefaultAddress.value,
        'updated_at': DateTime.now().toIso8601String(),
        'latitude': selectedLatitude.value,
        'longitude': selectedLongitude.value,
      };

      // PERBAIKAN 2: Gunakan .select()
      await _supabase.client
          .from('shipping_addresses')
          .update(updatedData)
          .eq('id', addressId)
          .select();

      Get.back();
      await loadAddresses();
      _syncToGlobalAddressController();
      _showSuccessSnackbar('Alamat berhasil diperbarui');
      _clearForm();
    } catch (e) {
      _showErrorSnackbar('Gagal memperbarui alamat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteAddress(int addressId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Hapus Alamat'),
        content: const Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('BATAL'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('HAPUS'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      isLoading.value = true;

      // PERBAIKAN 2: Gunakan .select()
      await _supabase.client
          .from('shipping_addresses')
          .delete()
          .eq('id', addressId)
          .select();

      await loadAddresses();
      _syncToGlobalAddressController();
      _showSuccessSnackbar('Alamat berhasil dihapus');
    } catch (e) {
      _showErrorSnackbar('Gagal menghapus alamat: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setAsDefault(int addressId) async {
    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      await _setAllAddressesNonDefault(user.id);

      // PERBAIKAN 2: Gunakan .select()
      await _supabase.client
          .from('shipping_addresses')
          .update({'is_default': true})
          .eq('id', addressId)
          .select();

      await loadAddresses();
      _syncToGlobalAddressController();
      _showSuccessSnackbar('Alamat default telah diubah');
    } catch (e) {
      _showErrorSnackbar('Gagal mengubah alamat default: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // PERBAIKAN 1: Helper juga harus Future<void> agar bisa di-await
  Future<void> _setAllAddressesNonDefault(String userId,
      {int? excludeId}) async {
    if (excludeId != null) {
      await _supabase.client
          .from('shipping_addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .neq('id', excludeId)
          .select(); // PERBAIKAN 2: Gunakan .select()
    } else {
      await _supabase.client
          .from('shipping_addresses')
          .update({'is_default': false})
          .eq('user_id', userId)
          .select(); // PERBAIKAN 2: Gunakan .select()
    }
  }

  void showAddAddressForm() {
    _clearForm();
    Get.to(() => const AddressFormView());
  }

  void showEditAddressForm(ShippingAddress address) {
    _fillFormWithAddress(address);
    Get.to(() => const AddressFormView(), arguments: address.id);
  }

  void _fillFormWithAddress(ShippingAddress address) {
    nameController.text = address.name;
    phoneController.text = address.phone;
    addressController.text = address.address;
    cityController.text = address.city;
    provinceController.text = address.province;
    postalCodeController.text = address.postalCode;
    isDefaultAddress.value = address.isDefault;
    selectedLatitude.value = address.latitude;
    selectedLongitude.value = address.longitude;
  }

  bool _validateForm() {
    if (nameController.text.isEmpty) {
      _showErrorSnackbar('Nama penerima tidak boleh kosong');
      return false;
    }
    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      _showErrorSnackbar('Nomor telepon minimal 10 digit');
      return false;
    }
    if (addressController.text.isEmpty) {
      _showErrorSnackbar('Alamat lengkap tidak boleh kosong');
      return false;
    }
    if (cityController.text.isEmpty) {
      _showErrorSnackbar('Kota tidak boleh kosong');
      return false;
    }
    if (provinceController.text.isEmpty) {
      _showErrorSnackbar('Provinsi tidak boleh kosong');
      return false;
    }
    if (postalCodeController.text.isEmpty) {
      _showErrorSnackbar('Kode pos tidak boleh kosong');
      return false;
    }
    return true;
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    cityController.clear();
    provinceController.clear();
    postalCodeController.clear();
    isDefaultAddress.value = false;
    selectedLatitude.value = null;
    selectedLongitude.value = null;
  }

  Future<void> openMapPicker() async {
    final result = await Get.to<Map<String, dynamic>>(
      () => const MapPickerView(),
      binding: MapPickerBinding(),
      arguments: {
        'latitude': selectedLatitude.value,
        'longitude': selectedLongitude.value,
      },
    );

    if (result != null) {
      selectedLatitude.value = result['latitude'];
      selectedLongitude.value = result['longitude'];
      
      // Build alamat lengkap dari komponen
      final road = result['road']?.toString() ?? '';
      final houseNumber = result['house_number']?.toString() ?? '';
      final neighbourhood = result['neighbourhood']?.toString() ?? '';
      final village = result['village']?.toString() ?? '';
      
      // Build address string
      List<String> addressParts = [];
      if (road.isNotEmpty) {
        if (houseNumber.isNotEmpty) {
          addressParts.add('$road No. $houseNumber');
        } else {
          addressParts.add(road);
        }
      }
      if (neighbourhood.isNotEmpty) addressParts.add(neighbourhood);
      if (village.isNotEmpty) addressParts.add(village);
      
      // Set alamat lengkap
      if (addressParts.isNotEmpty) {
        addressController.text = addressParts.join(', ');
      } else if (result['full_address'] != null && result['full_address'].toString().isNotEmpty) {
        addressController.text = result['full_address'];
      }
      
      // Set kota
      final city = result['city']?.toString() ?? '';
      if (city.isNotEmpty) {
        cityController.text = city;
      }
      
      // Set provinsi
      final state = result['state']?.toString() ?? '';
      if (state.isNotEmpty) {
        provinceController.text = state;
      }
      
      // Set kode pos
      final postcode = result['postcode']?.toString() ?? '';
      if (postcode.isNotEmpty) {
        postalCodeController.text = postcode;
      }
      
      debugPrint('[MapPicker] Address filled: ${addressController.text}');
      debugPrint('[MapPicker] City: ${cityController.text}');
      debugPrint('[MapPicker] Province: ${provinceController.text}');
      debugPrint('[MapPicker] Postal: ${postalCodeController.text}');
    }
  }

  bool get hasLocation => selectedLatitude.value != null && selectedLongitude.value != null;

  void _syncToGlobalAddressController() {
    if (Get.isRegistered<AddressController>()) {
      Get.find<AddressController>().refresh();
    }
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar('Berhasil', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    provinceController.dispose();
    postalCodeController.dispose();
    super.onClose();
  }
}
