import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/models/order_model.dart';

class LocalStorageService extends GetxService {
  late final Box<CartItem> _cartBox;
  late final Box<Order> _orderBox;

  Future<LocalStorageService> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(CartItemAdapter().typeId)) {
      Hive.registerAdapter(CartItemAdapter());
    }
    if (!Hive.isAdapterRegistered(OrderItemAdapter().typeId)) {
      Hive.registerAdapter(OrderItemAdapter());
    }
    if (!Hive.isAdapterRegistered(OrderAdapter().typeId)) {
      Hive.registerAdapter(OrderAdapter());
    }

    _cartBox = await Hive.openBox<CartItem>('shopping_cart');
    _orderBox = await Hive.openBox<Order>('order_history');

    debugPrint('[Hive] LocalStorageService initialized.');
    return this;
  }

  Box<CartItem> get cartBox => _cartBox;
  Box<Order> get orderBox => _orderBox;

  // Order cache methods
  Future<void> cacheOrders(List<Order> orders) async {
    await _orderBox.clear();
    for (var order in orders) {
      await _orderBox.put(order.id, order);
    }
    debugPrint('[Hive] Cached ${orders.length} orders');
  }

  List<Order> getCachedOrders() {
    final orders = _orderBox.values.toList();
    orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    debugPrint('[Hive] Retrieved ${orders.length} cached orders');
    return orders;
  }

  Future<void> addOrderToCache(Order order) async {
    await _orderBox.put(order.id, order);
    debugPrint('[Hive] Added order ${order.id} to cache');
  }

  Future<void> clearOrderCache() async {
    await _orderBox.clear();
    debugPrint('[Hive] Order cache cleared');
  }
}
