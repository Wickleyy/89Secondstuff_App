import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_settings_controller.dart';

class NotificationSettingsView
    extends GetView<NotificationSettingsController> {
  const NotificationSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengaturan Notifikasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildNotificationSection(
              theme,
              colorScheme,
              'Pesanan',
              [
                _buildNotificationTile(
                  theme,
                  colorScheme,
                  'Notifikasi Pesanan',
                  'Terima notifikasi tentang status pesanan Anda',
                  Icons.shopping_bag_outlined,
                  controller.orderNotification,
                  (value) =>
                      controller.toggleOrderNotification(value),
                ),
                _buildNotificationTile(
                  theme,
                  colorScheme,
                  'Promosi & Diskon',
                  'Dapatkan update tentang promo eksklusif',
                  Icons.local_offer_outlined,
                  controller.promoNotification,
                  (value) =>
                      controller.togglePromoNotification(value),
                ),
              ],
            ),
            _buildNotificationSection(
              theme,
              colorScheme,
              'Produk',
              [
                _buildNotificationTile(
                  theme,
                  colorScheme,
                  'Review Produk',
                  'Dapatkan review dari pembeli lain',
                  Icons.rate_review_outlined,
                  controller.reviewNotification,
                  (value) =>
                      controller.toggleReviewNotification(value),
                ),
                _buildNotificationTile(
                  theme,
                  colorScheme,
                  'Produk Kembali Tersedia',
                  'Notifikasi ketika produk favorit tersedia kembali',
                  Icons.inventory_outlined,
                  controller.accountNotification,
                  (value) =>
                      controller.toggleAccountNotification(value),
                ),
              ],
            ),
            _buildNotificationSection(
              theme,
              colorScheme,
              'Informasi Umum',
              [
                _buildNotificationTile(
                  theme,
                  colorScheme,
                  'Berita & Update',
                  'Terima berita dan update terbaru dari 89secondStuff',
                  Icons.newspaper,
                  controller.newsNotification,
                  (value) =>
                      controller.toggleNewsNotification(value),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    controller.resetToDefault();
                    Get.snackbar('Success',
                        'Pengaturan telah direset ke default',
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'RESET KE DEFAULT',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String subtitle,
    IconData icon,
    RxBool value,
    Function(bool) onChanged,
  ) {
    return Obx(
      () => ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        trailing: Switch(
          value: value.value,
          onChanged: onChanged,
          activeColor: colorScheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}