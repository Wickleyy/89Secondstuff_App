import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:_89_secondstufff/app/data/services/location_service.dart';

class MapPickerController extends GetxController {
  final LocationService _locationService = Get.find<LocationService>();
  
  late MapController mapController;
  
  final Rx<LatLng> selectedLocation = LatLng(-6.2088, 106.8456).obs;
  final RxMap<String, String> addressDetails = <String, String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isFetchingAddress = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    mapController = MapController();
    
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      if (args['latitude'] != null && args['longitude'] != null) {
        selectedLocation.value = LatLng(args['latitude'], args['longitude']);
      }
    }
    
    ever(selectedLocation, (_) => _fetchAddressForLocation());
  }

  @override
  void onReady() {
    super.onReady();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final args = Get.arguments;
    if (args != null && args['latitude'] != null) {
      await _fetchAddressForLocation();
      return;
    }
    
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final position = await _locationService.getCurrentPosition();
      
      if (position != null) {
        selectedLocation.value = LatLng(position.latitude, position.longitude);
        mapController.move(selectedLocation.value, 17.0);
      } else {
        errorMessage.value = _locationService.errorMessage.value;
      }
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan lokasi: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void onMapTap(TapPosition tapPosition, LatLng point) {
    selectedLocation.value = point;
  }

  Future<void> _fetchAddressForLocation() async {
    try {
      isFetchingAddress.value = true;
      
      final address = await _locationService.getAddressFromCoordinates(selectedLocation.value);
      
      if (address != null) {
        addressDetails.value = address;
      } else {
        addressDetails.value = {
          'display_name': 'Alamat tidak ditemukan',
        };
      }
    } catch (e) {
      addressDetails.value = {
        'display_name': 'Gagal memuat alamat',
      };
    } finally {
      isFetchingAddress.value = false;
    }
  }

  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () {
      searchAddress(query);
    });
  }

  Future<void> searchAddress(String query) async {
    if (query.length < 3) {
      searchResults.clear();
      return;
    }

    try {
      isSearching.value = true;
      final results = await _locationService.searchAddress(query);
      searchResults.assignAll(results);
    } catch (e) {
      errorMessage.value = 'Gagal mencari alamat: $e';
    } finally {
      isSearching.value = false;
    }
  }

  void selectSearchResult(Map<String, dynamic> result) {
    final lat = result['lat'] as double;
    final lon = result['lon'] as double;
    
    selectedLocation.value = LatLng(lat, lon);
    mapController.move(selectedLocation.value, 17.0);
    
    searchResults.clear();
    searchController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void confirmLocation() {
    final result = {
      'latitude': selectedLocation.value.latitude,
      'longitude': selectedLocation.value.longitude,
      'address': addressDetails['display_name'] ?? '',
      'full_address': addressDetails['full_address'] ?? addressDetails['display_name'] ?? '',
      'road': addressDetails['road'] ?? '',
      'house_number': addressDetails['house_number'] ?? '',
      'neighbourhood': addressDetails['neighbourhood'] ?? '',
      'village': addressDetails['village'] ?? '',
      'city': addressDetails['city'] ?? '',
      'state': addressDetails['state'] ?? '',
      'postcode': addressDetails['postcode'] ?? '',
    };
    
    Get.back(result: result);
  }

  void startLiveLocation() {
    _locationService.startLiveLocation(
      onPositionUpdate: (position) {
        selectedLocation.value = LatLng(position.latitude, position.longitude);
        mapController.move(selectedLocation.value, 17.0);
      },
      distanceFilter: 5,
    );
  }

  void stopLiveLocation() {
    _locationService.stopLiveLocation();
  }

  bool get isLiveLocationActive => _locationService.isLiveLocationActive.value;

  @override
  void onClose() {
    _debounce?.cancel();
    searchController.dispose();
    stopLiveLocation();
    super.onClose();
  }
}
