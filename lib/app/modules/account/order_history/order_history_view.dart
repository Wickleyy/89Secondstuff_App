import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/data/models/order_model.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'order_history_controller.dart';

class OrderHistoryView extends GetView<OrderHistoryController> {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final currencyFormat =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm', 'id_ID');

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                      AppTheme.deepPurpleDark,
                      Color(0xFF251742),
                      AppTheme.deepPurpleDark
                    ])
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF8F5FF), Color(0xFFFFF9F0)]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              _buildFilterChips(isDark, colorScheme),
              // Di dalam OrderHistoryView, bagian Expanded child:
              Expanded(
                child: Obx(() {
                  // TIPS: Akses .value di awal agar Obx selalu memiliki dependency yang jelas
                  final bool loading = controller.isLoading.value;
                  final List<Order> orders = controller
                      .filteredOrders; // Getter ini mengakses .obs di controller

                  if (loading) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: isDark
                                ? AppTheme.accentMustard
                                : colorScheme.primary));
                  }

                  if (orders.isEmpty) {
                    // Pastikan state ini tetap dianggap reaktif oleh GetX
                    return _buildEmptyState(isDark, colorScheme);
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshOrders,
                    color:
                        isDark ? AppTheme.accentMustard : colorScheme.primary,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: orders.length,
                      itemBuilder: (context, index) => _buildOrderCard(
                          orders[index],
                          currencyFormat,
                          dateFormat,
                          isDark,
                          colorScheme),
                    ),
                  );
                }),
              ),
            ],
          ),
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
              gradient: isDark
                  ? LinearGradient(colors: [
                      AppTheme.glowPurple.withValues(alpha: 0.3),
                      AppTheme.deepPurpleLight.withValues(alpha: 0.3)
                    ])
                  : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
                icon: Icon(Icons.arrow_back_rounded,
                    color:
                        isDark ? AppTheme.accentMustard : colorScheme.primary),
                onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Riwayat Pesanan',
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : colorScheme.onSurface)),
                Obx(() => Row(
                      children: [
                        Icon(
                          controller.dataSource.value == 'cache'
                              ? Icons.storage
                              : Icons.cloud_done,
                          size: 12,
                          color: isDark
                              ? Colors.white38
                              : colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.dataSource.value == 'cache'
                              ? 'Dari cache'
                              : 'Tersinkronisasi',
                          style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: isDark
                                  ? Colors.white38
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.4)),
                        ),
                        if (controller.isSyncing.value) ...[
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: isDark
                                  ? AppTheme.accentMustard
                                  : colorScheme.primary,
                            ),
                          ),
                        ],
                      ],
                    )),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(colors: [
                      AppTheme.glowPurple.withValues(alpha: 0.3),
                      AppTheme.deepPurpleLight.withValues(alpha: 0.3)
                    ])
                  : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
                icon: Icon(Icons.refresh,
                    color:
                        isDark ? AppTheme.accentMustard : colorScheme.primary),
                onPressed: controller.refreshOrders),
          ),
        ],
      ),
    );
  }

// 1. Perbaikan pada Filter Chips
  Widget _buildFilterChips(bool isDark, ColorScheme colorScheme) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.filterOptions.length,
        itemBuilder: (context, index) {
          final option = controller.filterOptions[index];
          // Pindahkan Obx ke SINI (hanya membungkus chip yang butuh perubahan warna)
          return Obx(() {
            final isSelected =
                controller.selectedFilter.value == option['value'];
            return Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => controller.setFilter(option['value']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: isDark
                                ? [AppTheme.accentMustard, AppTheme.accentRed]
                                : [colorScheme.primary, colorScheme.secondary])
                        : null,
                    color: isSelected
                        ? null
                        : (isDark
                            ? AppTheme.deepPurpleLight.withValues(alpha: 0.3)
                            : colorScheme.surface),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(option['label']!,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? Colors.white70
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.7)))),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
                gradient: isDark
                    ? LinearGradient(colors: [
                        AppTheme.glowPurple.withValues(alpha: 0.15),
                        AppTheme.deepPurpleLight.withValues(alpha: 0.1)
                      ])
                    : null,
                color:
                    isDark ? null : colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle),
            child: Icon(Icons.receipt_long_outlined,
                size: 64,
                color: isDark
                    ? AppTheme.accentMustard.withValues(alpha: 0.6)
                    : colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Tidak Ada Pesanan',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white70
                      : colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text('Mulai berbelanja sekarang!',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: isDark
                      ? Colors.white54
                      : colorScheme.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, NumberFormat currencyFormat,
      DateFormat dateFormat, bool isDark, ColorScheme colorScheme) {
    final statusColor = controller.getStatusColor(order.status);
    final statusIcon = controller.getStatusIcon(order.status);
    final statusText = controller.getStatusText(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: isDark
            ? LinearGradient(colors: [
                AppTheme.deepPurpleLight.withValues(alpha: 0.3),
                AppTheme.deepPurpleDark.withValues(alpha: 0.5)
              ])
            : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDark
                ? AppTheme.glowPurple.withValues(alpha: 0.2)
                : colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isDark
            ? [
                BoxShadow(
                    color: AppTheme.glowPurple.withValues(alpha: 0.15),
                    blurRadius: 12)
              ]
            : [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
              ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                statusColor.withValues(alpha: 0.15),
                statusColor.withValues(alpha: 0.05)
              ]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        statusColor.withValues(alpha: 0.25),
                        statusColor.withValues(alpha: 0.1)
                      ]),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(statusIcon, color: statusColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${order.id.substring(0, 8)}',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: isDark
                                  ? Colors.white
                                  : colorScheme.onSurface)),
                      Text(dateFormat.format(order.createdAt),
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white54
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.5))),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        statusColor.withValues(alpha: 0.25),
                        statusColor.withValues(alpha: 0.15)
                      ]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(statusText,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (order.items != null && order.items!.isNotEmpty)
                  ...order.items!.take(2).map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(item.productImage,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: isDark
                                              ? AppTheme.deepPurpleLight
                                              : Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(Icons.image,
                                          size: 24,
                                          color: isDark
                                              ? Colors.white38
                                              : Colors.grey))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productTitle,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: isDark
                                              ? Colors.white
                                              : colorScheme.onSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  Text(
                                      '${item.quantity}x ${currencyFormat.format(item.price)}',
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: isDark
                                              ? Colors.white54
                                              : colorScheme.onSurface
                                                  .withValues(alpha: 0.5))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                if (order.items != null && order.items!.length > 2)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('+${order.items!.length - 2} produk lainnya',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isDark
                                ? AppTheme.accentMustard
                                : colorScheme.primary,
                            fontWeight: FontWeight.w500)),
                  ),
                Divider(
                    color: isDark
                        ? Colors.white12
                        : colorScheme.outline.withValues(alpha: 0.1)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Pembayaran',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: isDark
                                    ? Colors.white54
                                    : colorScheme.onSurface
                                        .withValues(alpha: 0.5))),
                        Text(currencyFormat.format(order.total),
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppTheme.accentMustard
                                    : colorScheme.primary)),
                      ],
                    ),
                    order.isPending
                        ? ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppTheme.accentMustard
                                  : colorScheme.primary,
                              foregroundColor: isDark
                                  ? AppTheme.deepPurpleDark
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: isDark ? 6 : 2,
                              shadowColor: isDark
                                  ? AppTheme.accentMustard
                                      .withValues(alpha: 0.4)
                                  : null,
                            ),
                            child: Text('Bayar',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                          )
                        : OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: isDark
                                  ? AppTheme.accentMustard
                                  : colorScheme.primary,
                              side: BorderSide(
                                  color: isDark
                                      ? AppTheme.accentMustard
                                      : colorScheme.primary,
                                  width: 1.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text('Detail',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
