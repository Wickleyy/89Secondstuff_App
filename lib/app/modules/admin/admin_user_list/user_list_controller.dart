import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUserListController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var isLoading = true.obs;
  var users = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

  final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  List<Map<String, dynamic>> get filteredUsers {
    if (searchQuery.value.isEmpty) return users;
    return users.where((user) {
      final email = (user['email'] ?? '').toString().toLowerCase();
      final name = (user['full_name'] ?? '').toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();
      return email.contains(query) || name.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      
      // Ambil semua user dengan role = 'user'
      final profilesResponse = await _supabase.client
          .from('profiles')
          .select('*')
          .eq('role', 'user')
          .order('created_at', ascending: false);

      final profilesList = List<Map<String, dynamic>>.from(profilesResponse);

      // Untuk setiap user, ambil statistik order mereka
      for (var i = 0; i < profilesList.length; i++) {
        final userId = profilesList[i]['id'];
        
        // Ambil orders user ini dengan order_items (tabel terpisah)
        final ordersResponse = await _supabase.client
            .from('orders')
            .select('id, total_amount, status, order_items(quantity)')
            .eq('user_id', userId);

        final ordersList = List<Map<String, dynamic>>.from(ordersResponse);
        
        // Hitung statistik
        int totalOrders = ordersList.length;
        int totalItems = 0;
        double totalSpent = 0;

        for (var order in ordersList) {
          totalSpent += (order['total_amount'] ?? 0).toDouble();
          // order_items adalah relasi ke tabel order_items
          final items = order['order_items'] as List? ?? [];
          for (var item in items) {
            totalItems += (item['quantity'] as int? ?? 1);
          }
        }

        // Tambahkan statistik ke profile
        profilesList[i]['total_orders'] = totalOrders;
        profilesList[i]['total_items'] = totalItems;
        profilesList[i]['total_spent'] = totalSpent;
      }

      users.assignAll(profilesList);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data user: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshUsers() async {
    await fetchUsers();
  }

  void showUserDetail(Map<String, dynamic> user) {
    final isDark = Get.isDarkMode;
    final totalOrders = user['total_orders'] ?? 0;
    final totalItems = user['total_items'] ?? 0;
    final totalSpent = (user['total_spent'] ?? 0).toDouble();
    
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: isDark ? AppTheme.deepPurpleDark : AppTheme.lightPrimary,
              backgroundImage: user['avatar_url'] != null && user['avatar_url'].toString().isNotEmpty
                  ? NetworkImage(user['avatar_url'])
                  : null,
              child: user['avatar_url'] == null || user['avatar_url'].toString().isEmpty
                  ? Text(
                      (user['email'] ?? 'U')[0].toUpperCase(),
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppTheme.accentMustard : Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user['full_name'] ?? 'Tanpa Nama',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    user['email'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Statistik Order
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  gradient: isDark 
                      ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)])
                      : LinearGradient(colors: [AppTheme.lightPrimary.withValues(alpha: 0.1), AppTheme.lightSupport.withValues(alpha: 0.1)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text('Statistik Belanja', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[700])),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.shopping_bag, '$totalOrders', 'Pesanan', isDark),
                        _buildStatItem(Icons.inventory_2, '$totalItems', 'Barang', isDark),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.2) : AppTheme.lightPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.payments, size: 16, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
                          const SizedBox(width: 6),
                          Text('Total: ${currencyFormat.format(totalSpent)}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Info Profil
              _buildDetailRow(Icons.phone, 'Telepon', user['phone'] ?? '-', isDark),
              _buildDetailRow(Icons.calendar_today, 'Bergabung', _formatDate(user['created_at']), isDark),
              _buildDetailRow(Icons.update, 'Update Terakhir', _formatDate(user['updated_at']), isDark),
              // Tombol Aksi
              const SizedBox(height: 12),
              // Tombol Chat User
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    chatWithUser(user);
                  },
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('CHAT USER'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              // Tombol Lihat Pesanan
              if (totalOrders > 0) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.back();
                      showUserOrders(user);
                    },
                    icon: const Icon(Icons.receipt_long, size: 18),
                    label: const Text('LIHAT PESANAN'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
                      side: BorderSide(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('TUTUP', style: TextStyle(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              _confirmDeleteUser(user);
            },
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('HAPUS'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Chat dengan user - navigasi ke halaman chat detail
  void chatWithUser(Map<String, dynamic> user) {
    Get.toNamed(AppRoutes.ADMIN_CHAT_DETAIL, arguments: {
      'recipientId': user['id'],
      'recipientEmail': user['email'] ?? '',
      'recipientName': user['full_name'] ?? user['email']?.split('@')[0] ?? 'User',
    });
  }

  Widget _buildStatItem(IconData icon, String value, String label, bool isDark) {
    return Column(
      children: [
        Icon(icon, size: 20, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
        const SizedBox(height: 4),
        Text(value, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
        Text(label, style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white54 : Colors.grey)),
      ],
    );
  }

  // Tampilkan daftar pesanan user
  void showUserOrders(Map<String, dynamic> user) async {
    final isDark = Get.isDarkMode;
    final userId = user['id'];

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // Ambil orders dengan order_items (tabel terpisah)
      final ordersResponse = await _supabase.client
          .from('orders')
          .select('id, total_amount, status, created_at, order_items(product_title, product_image, quantity, price)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      Get.back(); // Close loading

      final orders = List<Map<String, dynamic>>.from(ordersResponse);

      Get.dialog(
        AlertDialog(
          backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.receipt_long, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesanan ${user['full_name'] ?? user['email']}', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: isDark ? Colors.white : Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${orders.length} pesanan', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey)),
                  ],
                ),
              ),
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
                      // order_items adalah relasi ke tabel order_items
                      final items = order['order_items'] as List? ?? [];
                      final status = order['status'] ?? 'Processing';
                      final statusColor = _getStatusColor(status);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.deepPurpleDark.withValues(alpha: 0.5) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
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
                            const SizedBox(height: 6),
                            // Items (dari tabel order_items)
                            ...items.take(3).map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(item['product_image'] ?? '', width: 30, height: 30, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 30, height: 30, color: Colors.grey[300], child: const Icon(Icons.image, size: 16))),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text('${item['product_title'] ?? 'Item'} x${item['quantity'] ?? 1}', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white70 : Colors.grey[700]), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            )),
                            if (items.length > 3)
                              Text('+${items.length - 3} item lainnya', style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 6),
                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDate(order['created_at']), style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white38 : Colors.grey)),
                                Text(currencyFormat.format(order['total_amount'] ?? 0), style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
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
      Get.snackbar('Error', 'Gagal memuat pesanan: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'paid':
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'failed':
        return Colors.red;
      case 'processing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey)),
                Text(value, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '-';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  void _confirmDeleteUser(Map<String, dynamic> user) {
    final isDark = Get.isDarkMode;
    
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.accentRed, size: 28),
            const SizedBox(width: 10),
            Text('Hapus User', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus akun "${user['email']}"?\n\nTindakan ini tidak dapat dibatalkan dan akan menghapus semua data user termasuk pesanan dan chat.',
          style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('BATAL', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              deleteUser(user['id']);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed),
            child: const Text('HAPUS', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> deleteUser(String userId) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Delete user's messages
      await _supabase.client.from('messages').delete().eq('sender_id', userId);
      await _supabase.client.from('messages').delete().eq('receiver_id', userId);

      // Delete user's orders
      await _supabase.client.from('orders').delete().eq('user_id', userId);

      // Delete user profile
      await _supabase.client.from('profiles').delete().eq('id', userId);

      Get.back(); // Close loading

      users.removeWhere((u) => u['id'] == userId);

      Get.snackbar(
        'Berhasil',
        'User berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading
      Get.snackbar(
        'Gagal',
        'Error menghapus user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
