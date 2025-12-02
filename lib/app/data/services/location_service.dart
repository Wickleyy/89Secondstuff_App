import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationService extends GetxService {
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  StreamSubscription<Position>? _positionStreamSubscription;
  final RxBool isLiveLocationActive = false.obs;

  Future<LocationService> init() async {
    return this;
  }

  Future<bool> checkAndRequestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      errorMessage.value = 'Layanan lokasi tidak aktif. Silakan aktifkan GPS.';
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorMessage.value = 'Izin lokasi ditolak.';
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      errorMessage.value = 'Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan.';
      return false;
    }

    return true;
  }

  Future<Position?> getCurrentPosition() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      currentPosition.value = position;
      return position;
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan lokasi: $e';
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void startLiveLocation({
    void Function(Position)? onPositionUpdate,
    int distanceFilter = 10,
  }) async {
    final hasPermission = await checkAndRequestPermission();
    if (!hasPermission) return;

    stopLiveLocation();

    isLiveLocationActive.value = true;

    final locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: distanceFilter,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        currentPosition.value = position;
        onPositionUpdate?.call(position);
      },
      onError: (error) {
        errorMessage.value = 'Error live location: $error';
        isLiveLocationActive.value = false;
      },
    );
  }

  void stopLiveLocation() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    isLiveLocationActive.value = false;
  }

  Future<Map<String, String>?> getAddressFromCoordinates(LatLng latLng) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?'
        'format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&addressdetails=1&zoom=18',
      );

      final response = await http.get(url, headers: {
        'User-Agent': '89SecondStuff/1.0',
        'Accept-Language': 'id',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>?;

        if (address != null) {
          // Extract road/street name
          String road = address['road'] ?? 
                       address['pedestrian'] ?? 
                       address['footway'] ?? 
                       address['path'] ??
                       address['street'] ?? '';
          
          // Extract house number
          String houseNumber = address['house_number'] ?? '';
          
          // Extract neighbourhood/area
          String neighbourhood = address['neighbourhood'] ?? 
                                address['suburb'] ?? 
                                address['hamlet'] ??
                                address['residential'] ?? '';
          
          // Extract village/kelurahan
          String village = address['village'] ?? 
                          address['city_district'] ?? 
                          address['subdistrict'] ??
                          address['quarter'] ?? '';
          
          // Extract city/kota - try multiple fields
          String city = address['city'] ?? 
                       address['town'] ?? 
                       address['municipality'] ??
                       address['county'] ?? 
                       address['city_district'] ??
                       address['regency'] ?? '';
          
          // Extract state/province
          String state = address['state'] ?? 
                        address['province'] ??
                        address['region'] ?? '';
          
          // Extract postal code
          String postcode = address['postcode'] ?? '';
          
          // Build full address
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
          
          String fullAddress = addressParts.isNotEmpty 
              ? addressParts.join(', ') 
              : data['display_name'] ?? '';

          return {
            'display_name': data['display_name'] ?? '',
            'full_address': fullAddress,
            'road': road,
            'house_number': houseNumber,
            'neighbourhood': neighbourhood,
            'village': village,
            'city': city,
            'state': state,
            'postcode': postcode,
            'country': address['country'] ?? '',
          };
        }
      }
      return null;
    } catch (e) {
      errorMessage.value = 'Gagal mendapatkan alamat: $e';
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> searchAddress(String query) async {
    try {
      if (query.length < 3) return [];

      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?'
        'format=json&q=$query&countrycodes=id&limit=5&addressdetails=1',
      );

      final response = await http.get(url, headers: {
        'User-Agent': '89SecondStuff/1.0',
        'Accept-Language': 'id',
      });

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => {
          'display_name': item['display_name'],
          'lat': double.parse(item['lat']),
          'lon': double.parse(item['lon']),
          'address': item['address'],
        }).toList();
      }
      return [];
    } catch (e) {
      errorMessage.value = 'Gagal mencari alamat: $e';
      return [];
    }
  }

  double calculateDistance(LatLng from, LatLng to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  @override
  void onClose() {
    stopLiveLocation();
    super.onClose();
  }
}
