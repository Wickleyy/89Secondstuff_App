import 'package:get/get.dart';

class Order {
  final String id;
  final String date;
  final double total;
  final String status;
  final int itemCount;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.itemCount,
  });
}

class OrderHistoryController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));

      orders.assignAll([
        Order(
          id: 'ORD-001',
          date: '25 Oktober 2024',
          total: 450000,
          status: 'Delivered',
          itemCount: 3,
        ),
        Order(
          id: 'ORD-002',
          date: '20 Oktober 2024',
          total: 250000,
          status: 'Processing',
          itemCount: 2,
        ),
        Order(
          id: 'ORD-003',
          date: '15 Oktober 2024',
          total: 150000,
          status: 'Shipped',
          itemCount: 1,
        ),
        Order(
          id: 'ORD-004',
          date: '10 Oktober 2024',
          total: 320000,
          status: 'Delivered',
          itemCount: 4,
        ),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat pesanan');
    } finally {
      isLoading.value = false;
    }
  }

  String getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return 'Terkirim';
      case 'Shipped':
        return 'Dalam Pengiriman';
      case 'Processing':
        return 'Diproses';
      default:
        return status;
    }
  }
}