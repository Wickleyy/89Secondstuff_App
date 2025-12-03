import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUserListController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  var isLoading = true.obs;
  var users = <Map<String, dynamic>>[].obs;
  var searchQuery = ''.obs;

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
      
      final response = await _supabase.client
          .from('profiles')
          .select('*')
          .eq('role', 'user')
          .order('created_at', ascending: false);

      users.assignAll(List<Map<String, dynamic>>.from(response));
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow(Icons.phone, 'Telepon', user['phone'] ?? '-', isDark),
            _buildDetailRow(Icons.calendar_today, 'Bergabung', _formatDate(user['created_at']), isDark),
            _buildDetailRow(Icons.update, 'Update Terakhir', _formatDate(user['updated_at']), isDark),
          ],
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
