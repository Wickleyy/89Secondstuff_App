import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/order_model.dart';
import 'package:_89_secondstufff/app/data/services/order_service.dart';

class OrderHistoryController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();
  
  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var isSyncing = false.obs; // For background sync indicator
  var selectedFilter = 'all'.obs;
  var dataSource = ''.obs; // 'cache' or 'server'

  final List<Map<String, String>> filterOptions = [
    {'value': 'all', 'label': 'Semua'},
    {'value': 'pending', 'label': 'Menunggu'},
    {'value': 'paid', 'label': 'Dibayar'},
    {'value': 'processing', 'label': 'Diproses'},
    {'value': 'shipped', 'label': 'Dikirim'},
    {'value': 'delivered', 'label': 'Selesai'},
    {'value': 'cancelled', 'label': 'Dibatalkan'},
  ];

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    isLoading.value = true;
    
    try {
      // 1. Load dari Hive cache dulu (instant, offline)
      final cachedOrders = _orderService.getCachedOrders();
      if (cachedOrders.isNotEmpty) {
        orders.assignAll(cachedOrders);
        dataSource.value = 'cache';
        isLoading.value = false;
        debugPrint('[OrderHistory] Loaded ${cachedOrders.length} orders from Hive cache');
        
        // 2. Background sync dari Supabase
        _syncFromServer();
      } else {
        // Tidak ada cache, langsung fetch dari server
        debugPrint('[OrderHistory] No cache, fetching from server...');
        await _fetchFromServer();
      }
    } catch (e) {
      debugPrint('[OrderHistory] Error loading orders: $e');
      isLoading.value = false;
      Get.snackbar(
        'Error', 
        'Gagal memuat riwayat pesanan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _fetchFromServer() async {
    try {
      final result = await _orderService.getUserOrders();
      orders.assignAll(result);
      dataSource.value = 'server';
      debugPrint('[OrderHistory] Loaded ${result.length} orders from Supabase');
    } catch (e) {
      debugPrint('[OrderHistory] Error fetching from server: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncFromServer() async {
    isSyncing.value = true;
    try {
      final result = await _orderService.getUserOrders();
      
      // Check if data changed
      if (result.length != orders.length) {
        orders.assignAll(result);
        dataSource.value = 'server';
        debugPrint('[OrderHistory] Synced ${result.length} orders from Supabase');
      }
    } catch (e) {
      debugPrint('[OrderHistory] Background sync failed: $e');
      // Silent fail - we already have cache data
    } finally {
      isSyncing.value = false;
    }
  }

  List<Order> get filteredOrders {
    if (selectedFilter.value == 'all') {
      return orders;
    }
    return orders.where((o) => o.status == selectedFilter.value).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Dibayar';
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

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.access_time;
      case 'paid':
        return Icons.payment;
      case 'processing':
        return Icons.inventory;
      case 'shipped':
        return Icons.local_shipping;
      case 'delivered':
        return Icons.check_circle;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Future<void> refreshOrders() async {
    // Force fetch from server on pull-to-refresh
    isLoading.value = true;
    await _fetchFromServer();
  }
}