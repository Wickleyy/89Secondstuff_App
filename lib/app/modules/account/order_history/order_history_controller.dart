import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/order_model.dart';
import 'package:_89_secondstufff/app/data/services/order_service.dart';

class OrderHistoryController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();
  
  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var selectedFilter = 'all'.obs;

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
      final result = await _orderService.getUserOrders();
      orders.assignAll(result);
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Gagal memuat riwayat pesanan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
    switch (status) {
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
    switch (status) {
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
    switch (status) {
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
    await loadOrders();
  }
}