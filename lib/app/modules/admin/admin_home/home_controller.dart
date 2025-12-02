import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class AdminHomeController extends GetxController {
  final SupabaseService _supabase = Get.find();

  // Statistics
  var totalProducts = 0.obs;
  var totalOrders = 0.obs;
  var activeChats = 0.obs;
  var totalUsers = 0.obs;
  var totalRevenue = 0.0.obs;
  var isLoading = true.obs;

  // Admin info
  var adminEmail = ''.obs;
  var adminName = 'Admin'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAdminInfo();
    loadStatistics();
  }

  void loadAdminInfo() {
    final user = _supabase.currentUser;
    if (user != null) {
      adminEmail.value = user.email ?? '';
      adminName.value = user.email?.split('@')[0] ?? 'Admin';
    }
  }

  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;

      // Load total products
      final productsResponse = await _supabase.client
          .from('products')
          .select('id')
          .eq('is_active', true);
      totalProducts.value = (productsResponse as List).length;

      // Load total orders
      final ordersResponse = await _supabase.client
          .from('orders')
          .select('id, total_amount');
      totalOrders.value = (ordersResponse as List).length;
      
      // Calculate total revenue
      double revenue = 0;
      for (var order in ordersResponse) {
        revenue += (order['total_amount'] ?? 0).toDouble();
      }
      totalRevenue.value = revenue;

      // Load active chats (unique users who sent messages)
      final chatsResponse = await _supabase.client
          .from('messages')
          .select('sender_id')
          .neq('sender_id', _supabase.currentUser?.id ?? '');
      final uniqueSenders = <String>{};
      for (var msg in (chatsResponse as List)) {
        uniqueSenders.add(msg['sender_id']);
      }
      activeChats.value = uniqueSenders.length;

      // Load total users
      final usersResponse = await _supabase.client
          .from('profiles')
          .select('id')
          .eq('role', 'user');
      totalUsers.value = (usersResponse as List).length;

    } catch (e) {
      debugPrint('Error loading statistics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshStatistics() async {
    await loadStatistics();
  }

  // Navigation ke halaman user (untuk monitoring)
  void goToUserApp() {
    Get.toNamed(AppRoutes.MAIN_NAVIGATION);
  }

  void goToProducts() {
    Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST);
  }

  void goToChats() {
    Get.toNamed(AppRoutes.ADMIN_CHAT_LIST);
  }

  void goToAddProduct() {
    Get.toNamed(AppRoutes.ADMIN_PRODUCT_FORM);
  }

  void logout() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun admin?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('BATAL')),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('KELUAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _supabase.client.auth.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
