import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Address {
  final int id;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.isDefault,
  });
}

class ShippingAddressController extends GetxController {
  var addresses = <Address>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  void loadAddresses() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      addresses.assignAll([
        Address(
          id: 1,
          name: 'Rumah',
          phone: '+62 812-3456-7890',
          address: 'Jl. Merdeka No. 123',
          city: 'Malang',
          province: 'Jawa Timur',
          postalCode: '65111',
          isDefault: true,
        ),
        Address(
          id: 2,
          name: 'Kantor',
          phone: '+62 821-9876-5432',
          address: 'Jl. Ahmad Yani No. 456',
          city: 'Malang',
          province: 'Jawa Timur',
          postalCode: '65112',
          isDefault: false,
        ),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat alamat');
    } finally {
      isLoading.value = false;
    }
  }

  void deleteAddress(int id) {
    addresses.removeWhere((addr) => addr.id == id);
    Get.snackbar('Success', 'Alamat berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM);
  }

  void setAsDefault(int id) {
    for (var addr in addresses) {
      addr = Address(
        id: addr.id,
        name: addr.name,
        phone: addr.phone,
        address: addr.address,
        city: addr.city,
        province: addr.province,
        postalCode: addr.postalCode,
        isDefault: addr.id == id,
      );
    }
    addresses.refresh();
  }
}
