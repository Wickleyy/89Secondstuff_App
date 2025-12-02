class ShippingAddress {
  final int id;
  final String userId;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? latitude;
  final double? longitude;

  ShippingAddress({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.latitude,
    this.longitude,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      province: json['province']?.toString() ?? '',
      postalCode: json['postal_code']?.toString() ?? '',
      isDefault: json['is_default'] == true,
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'user_id': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
      'is_default': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  ShippingAddress copyWith({
    int? id,
    String? userId,
    String? name,
    String? phone,
    String? address,
    String? city,
    String? province,
    String? postalCode,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? latitude,
    double? longitude,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  String get fullAddress {
    return '$address, $city, $province $postalCode';
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}