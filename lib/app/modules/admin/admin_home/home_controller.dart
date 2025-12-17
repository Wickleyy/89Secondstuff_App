import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart'; // Pastikan import ini ada
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class AdminHomeController extends GetxController {
  final SupabaseService _supabase = Get.find();

  // Statistics Variables
  var totalProducts = 0.obs;
  var totalOrders = 0.obs;
  var activeChats = 0.obs;
  var totalUsers = 0.obs;
  var totalRevenue = 0.0.obs;
  var isLoading = true.obs;

  // Admin Info
  var adminEmail = ''.obs;
  var adminName = 'Admin'.obs;
  var adminAvatarUrl = ''.obs;

  StreamSubscription? _productsSubscription;

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
    super.onClose();
  }

  // --- 1. LOAD STATISTICS (PERBAIKAN PRODUK 0) ---
  Future<void> loadStatistics() async {
    try {
      isLoading.value = true;

      // FIX: Hapus filter 'is_active' karena kolomnya tidak ada di database kamu
      final productsResponse =
          await _supabase.client.from('products').select('id');
      totalProducts.value = (productsResponse as List).length;

      // Hitung Orders & Revenue
      final ordersResponse = await _supabase.client
          .from('orders')
          .select('id, total_amount, status');

      final orders = ordersResponse as List;
      final paidOrders =
          orders.where((o) => o['status'] != 'cancelled').toList();

      totalOrders.value = paidOrders.length;
      totalRevenue.value = paidOrders.fold(
          0.0, (sum, item) => sum + (item['total_amount'] ?? 0).toDouble());

      // Hitung Users (Role User)
      final usersResponse = await _supabase.client
          .from('profiles')
          .select('id')
          .eq('role', 'user');
      totalUsers.value = (usersResponse as List).length;

      // Hitung Active Chats
      final chatsResponse =
          await _supabase.client.from('messages').select('sender_id');

      final uniqueSenders =
          (chatsResponse as List).map((e) => e['sender_id']).toSet();
      activeChats.value = uniqueSenders.length;
    } catch (e) {
      debugPrint('Error loading stats: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. FUNGSI YANG HILANG (PERBAIKAN ERROR VIEW) ---
  // Fungsi ini dipanggil dari home_view.dart, jadi WAJIB ADA
  void sendPromoNotification({
    required String title,
    required String message,
    String? promoCode,
  }) async {
    try {
      // 1. Simpan ke Database (Ini yang akan mentrigger notif di user lain)
      await _supabase.client.from('notification_history').insert({
        'title': title,
        'body': message,
        'promo_code': promoCode,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 2. Feedback Sukses ke Admin
      Get.snackbar(
        'Terkirim ke Server!',
        'Promo sedang dibroadcast ke seluruh user...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.cloud_done, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Kirim',
        'Error: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --- 3. SHOW PRODUCTS DIALOG (PERBAIKAN GAMBAR ERROR) ---
  void showProductsDialog() async {
    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);

    try {
      // FIX: Ganti 'image' menjadi 'image_url' sesuai database kamu
      final response = await _supabase.client
          .from('products')
          .select('id, title, price, image_url, stock')
          .order('id', ascending: false);

      Get.back(); // Tutup loading

      final products = List<Map<String, dynamic>>.from(response);
      final currencyFormat = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text('Daftar Produk (${products.length})',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: products.isEmpty
                ? const Center(child: Text('Tidak ada produk'))
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      // FIX: Ambil dari 'image_url'
                      final imgUrl = p['image_url'];

                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child:
                              (imgUrl != null && imgUrl.toString().isNotEmpty)
                                  ? Image.network(
                                      imgUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                          color: Colors.grey[300],
                                          width: 50,
                                          height: 50,
                                          child: const Icon(Icons.image)),
                                    )
                                  : Container(
                                      color: Colors.grey[300],
                                      width: 50,
                                      height: 50,
                                      child: const Icon(Icons.image)),
                        ),
                        title: Text(p['title'] ?? 'No Name',
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(currencyFormat.format(p['price'] ?? 0)),
                        trailing: Text("Stok: ${p['stock']}",
                            style: const TextStyle(fontSize: 12)),
                        onTap: () {
                          Get.back();
                          goToProducts();
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('Tutup')),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                  goToProducts();
                },
                child: const Text('Kelola Full')),
          ],
        ),
      );
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Gagal memuat produk: $e');
    }
  }

  // --- NAVIGATION & UTILS ---

  void _setupRealtimeSubscriptions() {
    // Listener sederhana untuk update realtime
    _productsSubscription = _supabase.client
        .from('products')
        .stream(primaryKey: ['id']).listen((data) {
      loadStatistics(); // Reload stats jika ada perubahan
    });
  }

  void loadAdminInfo() async {
    final user = _supabase.currentUser;
    if (user != null) {
      adminEmail.value = user.email ?? '';
      try {
        final res = await _supabase.client
            .from('profiles')
            .select()
            .eq('id', user.id)
            .maybeSingle();
        if (res != null) {
          adminName.value = res['full_name'] ?? 'Admin';
          adminAvatarUrl.value = res['avatar_url'] ?? '';
        }
      } catch (_) {}
    }
  }

  Future<void> refreshStatistics() async {
    await loadStatistics();
  }

  void goToUserApp() =>
      Get.toNamed(AppRoutes.MAIN_NAVIGATION, arguments: {'fromAdmin': true});
  void goToProducts() => Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST);
  void goToChats() => Get.toNamed(AppRoutes.ADMIN_CHAT_LIST);
  void goToAddProduct() => Get.toNamed(AppRoutes.ADMIN_PRODUCT_FORM);
  void goToUsers() => Get.toNamed(AppRoutes.ADMIN_USER_LIST);

  void logout() async {
    await _supabase.client.auth.signOut();
    Get.offAllNamed(AppRoutes.LOGIN);
  }
}
