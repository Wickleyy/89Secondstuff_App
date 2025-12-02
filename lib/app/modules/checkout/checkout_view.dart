import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark]) : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.cartItems.isEmpty) return _buildEmptyState(isDark, colorScheme);
            return Column(
              children: [
                _buildAppBar(isDark, colorScheme),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildAddressSection(isDark, colorScheme),
                        const SizedBox(height: 16),
                        _buildItemsSection(isDark, colorScheme, currencyFormat),
                        const SizedBox(height: 16),
                        _buildShippingSection(isDark, colorScheme, currencyFormat),
                        const SizedBox(height: 16),
                        _buildPaymentSummary(isDark, colorScheme, currencyFormat),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(isDark, colorScheme, currencyFormat),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Checkout', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null, shape: BoxShape.circle),
            child: Icon(Icons.shopping_cart_outlined, size: 64, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.6) : Colors.grey[400]),
          ),
          const SizedBox(height: 24),
          Text('Keranjang Kosong', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required IconData icon, required Color iconColor, required Widget child, required bool isDark, required ColorScheme colorScheme}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isDark ? [iconColor.withValues(alpha: 0.2), iconColor.withValues(alpha: 0.1)] : [iconColor.withValues(alpha: 0.15), iconColor.withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : colorScheme.onSurface)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildAddressSection(bool isDark, ColorScheme colorScheme) {
    return _buildSection(
      title: 'Alamat Pengiriman',
      icon: Icons.location_on,
      iconColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
      isDark: isDark,
      colorScheme: colorScheme,
      child: Obx(() {
        final address = controller.selectedAddress;
        if (address == null) {
          return InkWell(
            onTap: () => Get.toNamed(AppRoutes.SHIPPING_ADDRESS),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.orange.withValues(alpha: 0.15), Colors.orange.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Pilih alamat pengiriman', style: GoogleFonts.poppins(color: Colors.orange[700], fontWeight: FontWeight.w500))),
                  const Icon(Icons.chevron_right, color: Colors.orange),
                ],
              ),
            ),
          );
        }
        return InkWell(
          onTap: () => Get.toNamed(AppRoutes.SHIPPING_ADDRESS),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.15), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(address.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface)),
                          if (address.isDefault)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.green, Colors.teal]), borderRadius: BorderRadius.circular(6)),
                              child: Text('Utama', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(address.phone, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
                      const SizedBox(height: 2),
                      Text(address.fullAddress, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5)), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Icon(Icons.edit_outlined, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildItemsSection(bool isDark, ColorScheme colorScheme, NumberFormat currencyFormat) {
    return _buildSection(
      title: 'Pesanan (${controller.cartItems.length} item)',
      icon: Icons.shopping_bag_outlined,
      iconColor: isDark ? AppTheme.accentRed : colorScheme.secondary,
      isDark: isDark,
      colorScheme: colorScheme,
      child: Column(
        children: controller.cartItems.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: Container(width: 65, height: 65, color: Colors.white)),
                      errorWidget: (_, __, ___) => Container(width: 65, height: 65, color: Colors.grey[200], child: const Icon(Icons.image_not_supported)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('${item.quantity}x ${currencyFormat.format(item.price)}', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                      color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(currencyFormat.format(item.price * item.quantity), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
                  ),
                ],
              ),
            )).toList(),
      ),
    );
  }

  Widget _buildShippingSection(bool isDark, ColorScheme colorScheme, NumberFormat currencyFormat) {
    return _buildSection(
      title: 'Pengiriman',
      icon: Icons.local_shipping_outlined,
      iconColor: Colors.blue,
      isDark: isDark,
      colorScheme: colorScheme,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue.withValues(alpha: 0.12), Colors.blue.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.blue, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pengiriman Reguler', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface)),
                  Text('Estimasi 3-5 hari kerja', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ),
            Obx(() => Text(currencyFormat.format(controller.shippingCost.value), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue))),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummary(bool isDark, ColorScheme colorScheme, NumberFormat currencyFormat) {
    return _buildSection(
      title: 'Ringkasan Pembayaran',
      icon: Icons.receipt_long_outlined,
      iconColor: Colors.green,
      isDark: isDark,
      colorScheme: colorScheme,
      child: Column(
        children: [
          _buildSummaryRow('Subtotal', currencyFormat.format(controller.subtotal.value), isDark, colorScheme),
          const SizedBox(height: 10),
          _buildSummaryRow('Ongkos Kirim', currencyFormat.format(controller.shippingCost.value), isDark, colorScheme),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: isDark ? Colors.white12 : colorScheme.outline.withValues(alpha: 0.2)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: isDark ? Colors.white : colorScheme.onSurface)),
              Obx(() => Text(currencyFormat.format(controller.total.value), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? AppTheme.accentMustard : colorScheme.primary))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
        Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: isDark ? Colors.white : colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildBottomBar(bool isDark, ColorScheme colorScheme, NumberFormat currencyFormat) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Total Pembayaran', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
                Obx(() => Text(currencyFormat.format(controller.total.value), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20, color: isDark ? AppTheme.accentMustard : colorScheme.primary))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(() => ElevatedButton(
                  onPressed: controller.isProcessingPayment.value ? null : controller.processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                    foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                    disabledBackgroundColor: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: isDark ? 8 : 2,
                    shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
                  ),
                  child: controller.isProcessingPayment.value
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('Bayar Sekarang', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
                )),
          ),
        ],
      ),
    );
  }
}
