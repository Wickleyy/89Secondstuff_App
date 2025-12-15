import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';
import 'package:_89_secondstufff/app/data/models/order_model.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';

class OrderService extends GetxService {
  SupabaseService get _supabase => Get.find<SupabaseService>();
  LocalStorageService get _localStorage => Get.find<LocalStorageService>();

  Future<OrderService> init() async {
    return this;
  }

  // Get orders from Hive cache (instant, offline)
  List<Order> getCachedOrders() {
    return _localStorage.getCachedOrders();
  }

  Future<Order?> createOrder({
    required int? addressId,
    required List<CartItem> items,
    required double total,
  }) async {
    try {
      final user = _supabase.currentUser;
      if (user == null) throw Exception('User tidak login');

      debugPrint('[OrderService] Creating order for user: ${user.id}');

      // Convert items ke format jsonb
      final itemsJson = items.map((item) => {
        'product_id': item.id,
        'title': item.title,
        'image': item.image,
        'price': item.price,
        'quantity': item.quantity,
        'subtotal': item.price * item.quantity,
      }).toList();

      final orderData = {
        'user_id': user.id,
        'total_amount': total,
        'status': 'Processing',
        'items': itemsJson,
        'shipping_address_id': addressId,
      };

      final response = await _supabase.client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      debugPrint('[OrderService] Order created: ${response['id']}');

      final newOrderId = response['id'].toString();

      // Juga insert ke order_items untuk relasi
      for (final item in items) {
        await _supabase.client.from('order_items').insert({
          'order_id': response['id'], // UUID
          'product_id': item.id,
          'product_title': item.title,
          'product_image': item.image,
          'price': item.price,
          'quantity': item.quantity,
          'subtotal': item.price * item.quantity,
        });
      }

      debugPrint('[OrderService] Order items inserted: ${items.length}');

      final newOrder = await getOrderById(newOrderId);
      
      // Cache order ke Hive
      if (newOrder != null) {
        await _localStorage.addOrderToCache(newOrder);
        
        // Send notification to admin about new order
        if (Get.isRegistered<NotificationService>()) {
          // Get user profile for customer name
          final userProfile = await _supabase.client
              .from('profiles')
              .select('full_name')
              .eq('id', user.id)
              .maybeSingle();
          
          final customerName = userProfile?['full_name'] ?? 'Customer';
          
          NotificationService.to.showNewOrderNotification(
            orderId: newOrderId,
            customerName: customerName,
            total: total,
          );
        }
      }

      return newOrder;
    } catch (e) {
      debugPrint('[OrderService] Error creating order: $e');
      throw Exception('Gagal membuat pesanan: $e');
    }
  }

  Future<Order?> getOrderById(String id) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', id)
          .single();

      return Order.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Order?> getOrderByOrderId(String orderId) async {
    try {
      final response = await _supabase.client
          .from('orders')
          .select('*, order_items(*)')
          .eq('order_id', orderId)
          .single();

      return Order.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Fetch from Supabase and update cache
  Future<List<Order>> getUserOrders() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) {
        debugPrint('[OrderService] getUserOrders: No user logged in');
        return [];
      }

      debugPrint('[OrderService] Getting orders from Supabase for user: ${user.id}');

      final response = await _supabase.client
          .from('orders')
          .select('*, order_items(*)')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      debugPrint('[OrderService] Orders response: ${(response as List).length} orders');

      final orders = response.map((e) {
        try {
          return Order.fromJson(e);
        } catch (parseError) {
          debugPrint('[OrderService] Error parsing order: $parseError');
          debugPrint('[OrderService] Order data: $e');
          rethrow;
        }
      }).toList();

      // Update Hive cache dengan data terbaru dari Supabase
      await _localStorage.cacheOrders(orders);
      debugPrint('[OrderService] Orders synced to Hive cache');

      return orders;
    } catch (e) {
      debugPrint('[OrderService] Error getting orders: $e');
      return [];
    }
  }

  Future<bool> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
    String? transactionId,
    String? paymentMethod,
  }) async {
    try {
      String newStatus = 'Processing';
      
      if (paymentStatus == 'settlement' || paymentStatus == 'capture') {
        newStatus = 'Processing';
      } else if (paymentStatus == 'cancel' || 
                 paymentStatus == 'deny' || 
                 paymentStatus == 'expire') {
        newStatus = 'Cancelled';
      } else if (paymentStatus == 'pending') {
        newStatus = 'Processing';
      }

      await _supabase.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      return true;
    } catch (e) {
      debugPrint('[OrderService] Error updating payment status: $e');
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      await _supabase.client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId);

      // Send notification to customer about status update
      if (Get.isRegistered<NotificationService>()) {
        NotificationService.to.showOrderStatusNotification(
          orderId: orderId,
          status: status,
        );
      }

      return true;
    } catch (e) {
      debugPrint('[OrderService] Error updating order status: $e');
      return false;
    }
  }

  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, 'Cancelled');
  }
}
