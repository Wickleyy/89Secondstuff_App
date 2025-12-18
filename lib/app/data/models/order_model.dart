import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 2)
class OrderItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String orderId;

  @HiveField(2)
  final int productId;

  @HiveField(3)
  final String productTitle;

  @HiveField(4)
  final String productImage;

  @HiveField(5)
  final double price;

  @HiveField(6)
  final int quantity;

  @HiveField(7)
  final double subtotal;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.productTitle,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: _parseInt(json['id']),
      orderId: json['order_id']?.toString() ?? '',
      productId: _parseInt(json['product_id']),
      productTitle: json['product_title']?.toString() ?? 'Produk',
      productImage: json['product_image']?.toString() ?? '',
      price: _parseDouble(json['price']),
      quantity: _parseInt(json['quantity'], defaultValue: 1),
      subtotal: _parseDouble(json['subtotal']),
    );
  }

  factory OrderItem.fromJsonb(Map<String, dynamic> json) {
    final qty = _parseInt(json['quantity'], defaultValue: 1);
    final prc = _parseDouble(json['price']);
    return OrderItem(
      id: _parseInt(json['id']),
      orderId: '',
      productId: _parseInt(json['product_id'] ?? json['productId']),
      productTitle: json['product_title']?.toString() ??
          json['title']?.toString() ??
          'Produk',
      productImage:
          json['product_image']?.toString() ?? json['image']?.toString() ?? '',
      price: prc,
      quantity: qty,
      subtotal: _parseDouble(json['subtotal']) > 0
          ? _parseDouble(json['subtotal'])
          : prc * qty,
    );
  }

  factory OrderItem.empty() {
    return OrderItem(
      id: 0,
      orderId: '',
      productId: 0,
      productTitle: 'Unknown',
      productImage: '',
      price: 0,
      quantity: 0,
      subtotal: 0,
    );
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'product_title': productTitle,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  Map<String, dynamic> toJsonb() {
    return {
      'product_id': productId,
      'title': productTitle,
      'image': productImage,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

@HiveType(typeId: 3)
class Order extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String oderId;

  @HiveField(2)
  final String userId;

  @HiveField(3)
  final int? shippingAddressId;

  @HiveField(4)
  final double totalAmount;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.oderId,
    required this.userId,
    this.shippingAddressId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<OrderItem>? orderItems;

    if (json['order_items'] != null && json['order_items'] is List) {
      orderItems = (json['order_items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (orderItems == null && json['items'] != null) {
      if (json['items'] is List) {
        orderItems = (json['items'] as List).map((item) {
          if (item is Map<String, dynamic>) {
            return OrderItem.fromJsonb(item);
          }
          return OrderItem.empty();
        }).toList();
      }
    }

    return Order(
      id: json['id']?.toString() ?? '',
      oderId: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      shippingAddressId: _parseInt(json['shipping_address_id']),
      totalAmount: _parseDouble(json['total_amount']),
      status: json['status']?.toString() ?? 'Processing',
      createdAt: _parseDateTime(json['created_at']),
      items: orderItems,
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

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJsonForInsert(List<Map<String, dynamic>> itemsJson) {
    return {
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'items': itemsJson,
      'shipping_address_id': shippingAddressId,
    };
  }

  String get statusText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'processing':
        return 'Diproses';
      case 'shipped':
        return 'Dikirim';
      case 'delivered':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isProcessing => status.toLowerCase() == 'processing';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isDelivered => status.toLowerCase() == 'delivered';
  bool get isShipped => status.toLowerCase() == 'shipped';

  double get total => totalAmount;
  String get orderId => oderId;

  int get totalItems =>
      items?.fold(0, (sum, item) => sum! + item.quantity) ?? 0;
}
