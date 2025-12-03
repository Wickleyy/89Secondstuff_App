import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

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
  var adminAvatarUrl = ''.obs;

  // Real-time subscriptions
  StreamSubscription? _productsSubscription;
  StreamSubscription? _ordersSubscription;
  StreamSubscription? _chatsSubscription;
  StreamSubscription? _usersSubscription;

  @override
  void onInit() {
    super.onInit();
    loadAdminInfo();
    loadStatistics();
    _setupRealtimeSubscriptions();
  }

  @override
  void onClose() {
    _productsSubscription?.cancel();
    _ordersSubscription?.cancel();
    _chatsSubscription?.cancel();
    _usersSubscription?.cancel();
    super.onClose();
  }

  void _setupRealtimeSubscriptions() {
    // Real-time products subscription
    _productsSubscription = _supabase.client
        .from('products')
        .stream(primaryKey: ['id'])
        .listen((data) {
      final activeProducts = data.where((p) => p['is_active'] == true).length;
      totalProducts.value = activeProducts;
    });

    // Real-time orders subscription (only checkout/paid orders)
    _ordersSubscription = _supabase.client
        .from('orders')
        .stream(primaryKey: ['id'])
        .listen((data) {
      // Filter orders that have been checked out (not pending/cancelled)
      final checkoutOrders = data.where((o) => 
        o['status'] != null && o['status'] != 'cancelled'
      ).toList();
      totalOrders.value = checkoutOrders.length;
      
      // Calculate revenue from completed orders
      double revenue = 0;
      for (var order in checkoutOrders) {
        revenue += (order['total_amount'] ?? 0).toDouble();
      }
      totalRevenue.value = revenue;
    });

    // Real-time messages/chats subscription
    _chatsSubscription = _supabase.client
        .from('messages')
        .stream(primaryKey: ['id'])
        .listen((data) {
      final uniqueSenders = <String>{};
      final adminId = _supabase.currentUser?.id ?? '';
      for (var msg in data) {
        if (msg['sender_id'] != adminId) {
          uniqueSenders.add(msg['sender_id']);
        }
      }
      activeChats.value = uniqueSenders.length;
    });

    // Real-time users subscription
    _usersSubscription = _supabase.client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .listen((data) {
      final users = data.where((p) => p['role'] == 'user').length;
      totalUsers.value = users;
    });
  }

  void loadAdminInfo() async {
    final user = _supabase.currentUser;
    if (user != null) {
      adminEmail.value = user.email ?? '';
      adminName.value = user.email?.split('@')[0] ?? 'Admin';
      
      // Load profile data from database
      try {
        final response = await _supabase.client
            .from('profiles')
            .select('full_name, avatar_url')
            .eq('id', user.id)
            .maybeSingle();
        
        if (response != null) {
          if (response['full_name'] != null && response['full_name'].toString().isNotEmpty) {
            adminName.value = response['full_name'];
          }
          adminAvatarUrl.value = response['avatar_url'] ?? '';
        }
      } catch (e) {
        debugPrint('Error loading admin profile: $e');
      }
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
    Get.toNamed(AppRoutes.MAIN_NAVIGATION, arguments: {'fromAdmin': true});
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

  void goToUsers() {
    Get.toNamed(AppRoutes.ADMIN_USER_LIST);
  }

  // Show products dialog
  void showProductsDialog() async {
    final isDark = Get.isDarkMode;
    
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final response = await _supabase.client
          .from('products')
          .select('id, title, price, image, is_active')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      Get.back(); // Close loading

      final products = List<Map<String, dynamic>>.from(response);
      final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

      Get.dialog(
        AlertDialog(
          backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.inventory_2, color: isDark ? AppTheme.accentMustard : Colors.orange),
              const SizedBox(width: 10),
              Text('Daftar Produk (${products.length})', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: products.isEmpty
                ? Center(child: Text('Tidak ada produk', style: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey)))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(product['image'] ?? '', width: 50, height: 50, fit: BoxFit.cover, 
                            errorBuilder: (_, __, ___) => Container(width: 50, height: 50, color: Colors.grey[300], child: const Icon(Icons.image))),
                        ),
                        title: Text(product['title'] ?? '', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(currencyFormat.format(product['price'] ?? 0), style: GoogleFonts.poppins(fontSize: 12, color: isDark ? AppTheme.accentMustard : Colors.orange, fontWeight: FontWeight.w600)),
                        onTap: () {
                          Get.back();
                          goToProducts();
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('TUTUP', style: TextStyle(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary))),
            ElevatedButton(
              onPressed: () { Get.back(); goToProducts(); },
              style: ElevatedButton.styleFrom(backgroundColor: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
              child: const Text('KELOLA PRODUK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Gagal memuat produk: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Show orders dialog
  void showOrdersDialog() async {
    final isDark = Get.isDarkMode;
    
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final response = await _supabase.client
          .from('orders')
          .select('id, total_amount, status, created_at, user_id, profiles!orders_user_id_fkey(email, full_name)')
          .order('created_at', ascending: false);

      Get.back(); // Close loading

      final orders = List<Map<String, dynamic>>.from(response);
      final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

      Get.dialog(
        AlertDialog(
          backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.shopping_bag, color: Colors.blue),
              const SizedBox(width: 10),
              Text('Daftar Pesanan (${orders.length})', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : Colors.black87)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: orders.isEmpty
                ? Center(child: Text('Tidak ada pesanan', style: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey)))
                : ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final profile = order['profiles'] as Map<String, dynamic>?;
                      final userEmail = profile?['email'] ?? 'Unknown';
                      final userName = profile?['full_name'] ?? userEmail.split('@')[0];
                      final status = order['status'] ?? 'pending';
                      final statusColor = _getStatusColor(status);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.deepPurpleDark.withValues(alpha: 0.5) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('#${order['id'].toString().substring(0, 8)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                                  child: Text(status.toUpperCase(), style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.w600, color: statusColor)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(userName, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white70 : Colors.grey[700])),
                            Text(userEmail, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(currencyFormat.format(order['total_amount'] ?? 0), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
                                Text(dateFormat.format(DateTime.parse(order['created_at'])), style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('TUTUP', style: TextStyle(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary))),
          ],
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Gagal memuat pesanan: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
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
