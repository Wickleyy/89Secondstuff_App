import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFF8F5FF), Color(0xFFFFF9F0)]),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshStatistics,
            color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildHeader(isDark),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatsGrid(isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle('MENU UTAMA', isDark),
                        const SizedBox(height: 12),
                        _buildMenuGrid(isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle('MONITORING APLIKASI', isDark),
                        const SizedBox(height: 12),
                        _buildMonitoringCard(isDark),
                        const SizedBox(height: 24),
                        _buildSectionTitle('AKSI CEPAT', isDark),
                        const SizedBox(height: 12),
                        _buildQuickActions(isDark),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : AppTheme.lightPrimary.withValues(alpha: 0.6),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark] : [AppTheme.lightPrimary, AppTheme.lightPrimary.withValues(alpha: 0.8)],
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
        boxShadow: [BoxShadow(color: (isDark ? AppTheme.glowPurple : AppTheme.lightPrimary).withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppTheme.accentMustard, AppTheme.accentRed]),
                ),
                child: Obx(() => CircleAvatar(
                  radius: 24,
                  backgroundColor: isDark ? AppTheme.deepPurpleDark : AppTheme.lightPrimary,
                  backgroundImage: controller.adminAvatarUrl.value.isNotEmpty 
                      ? NetworkImage(controller.adminAvatarUrl.value) 
                      : null,
                  child: controller.adminAvatarUrl.value.isEmpty
                      ? Text(
                          controller.adminName.value.isNotEmpty ? controller.adminName.value[0].toUpperCase() : 'A',
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.accentMustard),
                        )
                      : null,
                )),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dashboard Admin', style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70)),
                    Obx(() => Text(
                      'Halo, ${controller.adminName.value}!',
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
                  onPressed: controller.refreshStatistics,
                  tooltip: 'Refresh',
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [AppTheme.accentRed.withValues(alpha: 0.8), AppTheme.accentRed]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
                  onPressed: controller.logout,
                  tooltip: 'Keluar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings, color: AppTheme.accentMustard, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kelola toko, produk, dan chat pelanggan dari sini.',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDark) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary));
      }
      return Column(
        children: [
          Row(
            children: [
              _buildStatCard('Produk', controller.totalProducts.value.toString(), Icons.inventory_2_rounded, isDark ? AppTheme.accentMustard : Colors.orange, isDark, onTap: controller.showProductsDialog),
              const SizedBox(width: 12),
              _buildStatCard('Chat', controller.activeChats.value.toString(), Icons.chat_bubble_rounded, Colors.green, isDark, onTap: controller.goToChats),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('User', controller.totalUsers.value.toString(), Icons.people_rounded, Colors.purple, isDark, onTap: controller.goToUsers),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
            color: isDark ? null : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)]), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                    Text(label, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                  ],
                ),
              ),
              if (onTap != null) Icon(Icons.arrow_forward_ios, size: 14, color: isDark ? Colors.white38 : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.15,
      children: [
        _buildMenuCard('Kelola Produk', 'Edit/Hapus Barang', Icons.inventory_2_rounded, isDark ? AppTheme.accentMustard : Colors.orange, controller.goToProducts, isDark),
        _buildMenuCard('Chat Pelanggan', 'Balas Pesan', Icons.chat_bubble_rounded, Colors.green, controller.goToChats, isDark),
        _buildMenuCard('Kelola User', 'Lihat/Hapus Akun', Icons.people_rounded, Colors.purple, controller.goToUsers, isDark),
        _buildMenuCard('Pengaturan', 'Akun & Preferensi', Icons.settings_rounded, Colors.grey, () => _showSettingsDialog(isDark), isDark),
      ],
    );
  }

  Widget _buildMenuCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
          color: isDark ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)]), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 26),
            ),
            const Spacer(),
            Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
            Text(subtitle, style: GoogleFonts.poppins(fontSize: 10, color: isDark ? Colors.white54 : Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringCard(bool isDark) {
    return GestureDetector(
      onTap: controller.goToUserApp,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isDark
              ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.4)])
              : LinearGradient(colors: [AppTheme.lightPrimary.withValues(alpha: 0.1), AppTheme.lightSupport.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : AppTheme.lightPrimary.withValues(alpha: 0.2)),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 12)] : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.25), AppTheme.accentRed.withValues(alpha: 0.15)] : [AppTheme.lightPrimary.withValues(alpha: 0.15), AppTheme.lightPrimary.withValues(alpha: 0.08)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.phone_android_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lihat Aplikasi User', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 2),
                  Text('Akses beranda & fitur seperti user untuk monitoring', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [AppTheme.lightPrimary, AppTheme.lightSupport]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
        boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          _buildQuickActionTile(Icons.add_box_rounded, 'Tambah Produk Baru', 'Buat listing produk', controller.goToAddProduct, isDark ? AppTheme.accentMustard : Colors.orange, isDark),
          Divider(color: isDark ? Colors.white12 : Colors.grey[200], height: 24),
          _buildQuickActionTile(Icons.campaign_rounded, 'Kirim Promo', 'Broadcast notifikasi promo', () => _showPromoDialog(isDark), Colors.pink, isDark),
          Divider(color: isDark ? Colors.white12 : Colors.grey[200], height: 24),
          _buildQuickActionTile(Icons.category_rounded, 'Lihat Kategori', 'Kelola kategori produk', () => Get.toNamed(AppRoutes.CATEGORIES), Colors.teal, isDark),
          Divider(color: isDark ? Colors.white12 : Colors.grey[200], height: 24),
          _buildQuickActionTile(Icons.search_rounded, 'Cari Produk', 'Pencarian cepat', () => Get.toNamed(AppRoutes.SEARCH), Colors.blue, isDark),
        ],
      ),
    );
  }

  Widget _buildQuickActionTile(IconData icon, String title, String subtitle, VoidCallback onTap, Color color, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)]), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black87)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : Colors.grey[600])),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: isDark ? Colors.white30 : Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.settings_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
            const SizedBox(width: 10),
            Text('Pengaturan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSettingsTile(Icons.person_outline, 'Profil Admin', () { Get.back(); Get.toNamed(AppRoutes.EDIT_PROFILE); }, isDark),
            _buildSettingsTile(Icons.notifications_outlined, 'Notifikasi', () { Get.back(); Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS); }, isDark),
            _buildSettingsTile(Icons.help_outline, 'Bantuan', () { Get.back(); Get.toNamed(AppRoutes.HELP_CENTER); }, isDark),
            _buildSettingsTile(Icons.info_outline, 'Tentang Aplikasi', () { Get.back(); Get.snackbar('89secondStuff', 'Versi 1.0.0\nAdmin Dashboard', snackPosition: SnackPosition.BOTTOM); }, isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('TUTUP', style: TextStyle(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, VoidCallback onTap, bool isDark) {
    return ListTile(
      leading: Icon(icon, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white : Colors.black87)),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white30 : Colors.grey),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }

  void _showPromoDialog(bool isDark) {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final promoCodeController = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.campaign_rounded, color: Colors.pink),
            const SizedBox(width: 10),
            Text('Kirim Promo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Judul Promo',
                  labelStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey),
                  hintText: 'Contoh: Flash Sale 50%!',
                  hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white30 : Colors.grey[400]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Pesan Promo',
                  labelStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey),
                  hintText: 'Contoh: Diskon 50% untuk semua produk!',
                  hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white30 : Colors.grey[400]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: promoCodeController,
                style: GoogleFonts.poppins(color: isDark ? Colors.white : Colors.black87),
                decoration: InputDecoration(
                  labelText: 'Kode Promo (Opsional)',
                  labelStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey),
                  hintText: 'Contoh: PROMO50',
                  hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white30 : Colors.grey[400]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('BATAL', style: TextStyle(color: isDark ? Colors.white70 : Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isEmpty || messageController.text.isEmpty) {
                Get.snackbar('Error', 'Judul dan pesan harus diisi', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                return;
              }
              controller.sendPromoNotification(
                title: titleController.text,
                message: messageController.text,
                promoCode: promoCodeController.text.isEmpty ? null : promoCodeController.text,
              );
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: Text('KIRIM', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
