import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'product_list_controller.dart';

class AdminProductListView extends GetView<AdminProductListController> {
  const AdminProductListView({super.key});

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
          child: Column(
            children: [
              _buildAppBar(isDark),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary));
                  }
                  if (controller.productList.isEmpty) {
                    return _buildEmptyState(isDark);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.productList.length,
                    itemBuilder: (context, index) => _buildProductCard(controller.productList[index], isDark),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddProduct,
        backgroundColor: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: isDark ? 8 : 4,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8)],
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Kelola Produk', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.lightOnText)),
          const Spacer(),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                  color: isDark ? null : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: isDark ? null : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
                ),
                child: Text('${controller.productList.length} produk', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary)),
              )),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : LinearGradient(colors: [Colors.orange.withValues(alpha: 0.1), Colors.orange.withValues(alpha: 0.05)]), shape: BoxShape.circle),
            child: Icon(Icons.inventory_2_outlined, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : AppTheme.lightPrimary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 20),
          Text('Belum ada produk', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey[600])),
          const SizedBox(height: 8),
          Text('Tap + untuk menambah produk baru', style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white38 : Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product, bool isDark) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 65,
          height: 65,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: isDark ? AppTheme.deepPurpleLight : AppTheme.lightBackground, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6)]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              product.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Icon(Icons.broken_image_rounded, color: isDark ? Colors.white38 : Colors.grey[400]),
              loadingBuilder: (_, child, loadingProgress) => loadingProgress == null ? child : Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : AppTheme.lightPrimary.withValues(alpha: 0.5)))),
            ),
          ),
        ),
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15, color: isDark ? Colors.white : AppTheme.lightOnText)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : LinearGradient(colors: [AppTheme.lightPrimary.withValues(alpha: 0.1), AppTheme.lightPrimary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(currencyFormat.format(product.price), style: GoogleFonts.poppins(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(Icons.edit_rounded, Colors.blue, () => controller.goToEditProduct(product), isDark),
            const SizedBox(width: 8),
            _buildActionButton(Icons.delete_outline_rounded, AppTheme.accentRed, () => _showDeleteDialog(product, isDark), isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onTap, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.08)]), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }

  void _showDeleteDialog(dynamic product, bool isDark) {
    Get.defaultDialog(
      title: 'Hapus Produk',
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87),
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      middleText: 'Apakah Anda yakin ingin menghapus "${product.title}"?',
      middleTextStyle: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.grey[700]),
      backgroundColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
      radius: 20,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        onPressed: () {
          Get.back();
          controller.deleteProduct(product.id);
        },
        child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(side: BorderSide(color: isDark ? Colors.white38 : Colors.grey[400]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        onPressed: () => Get.back(),
        child: Text('Batal', style: GoogleFonts.poppins(color: isDark ? Colors.white70 : Colors.black87)),
      ),
    );
  }
}
