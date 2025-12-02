import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'shipping_address_controller.dart';
import 'models/shipping_address_model.dart';

class ShippingAddressView extends GetView<ShippingAddressController> {
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.addresses.isEmpty) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : colorScheme.primary));
                  }
                  if (controller.addresses.isEmpty) {
                    return _buildEmptyState(isDark, colorScheme);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: controller.addresses.length,
                    itemBuilder: (context, index) => _buildAddressCard(controller.addresses[index], isDark, colorScheme),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.showAddAddressForm,
        backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
        foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
        elevation: isDark ? 8 : 4,
        icon: const Icon(Icons.add_location_alt),
        label: Text('Tambah Alamat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
          Text('Alamat Pengiriman', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null, color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Icon(Icons.location_off_outlined, size: 64, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.6) : colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Belum Ada Alamat', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text('Tambahkan alamat pengiriman Anda', style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
        ],
      ),
    );
  }

  Widget _buildAddressCard(ShippingAddress address, bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
                  gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.location_on, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(child: Text(address.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: isDark ? Colors.white : colorScheme.onSurface), overflow: TextOverflow.ellipsis)),
                        if (address.isDefault)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.green, Colors.teal]), borderRadius: BorderRadius.circular(8)),
                            child: Text('Default', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(address.phone, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5)),
                color: isDark ? AppTheme.deepPurpleLight : colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(children: [Icon(Icons.edit, size: 20, color: isDark ? AppTheme.accentMustard : colorScheme.primary), const SizedBox(width: 10), Text('Edit', style: TextStyle(color: isDark ? Colors.white : null))]),
                    onTap: () => Future.delayed(const Duration(milliseconds: 100), () => controller.showEditAddressForm(address)),
                  ),
                  if (!address.isDefault)
                    PopupMenuItem(
                      child: Row(children: [Icon(Icons.check_circle_outline, size: 20, color: Colors.green), const SizedBox(width: 10), Text('Jadikan Default', style: TextStyle(color: isDark ? Colors.white : null))]),
                      onTap: () => Future.delayed(const Duration(milliseconds: 100), () => controller.setAsDefault(address.id)),
                    ),
                  PopupMenuItem(
                    child: Row(children: [Icon(Icons.delete, size: 20, color: AppTheme.accentRed), const SizedBox(width: 10), Text('Hapus', style: TextStyle(color: AppTheme.accentRed))]),
                    onTap: () => Future.delayed(const Duration(milliseconds: 100), () => controller.deleteAddress(address.id)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.15), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null,
              color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address.address, style: GoogleFonts.poppins(fontSize: 13, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text('${address.city}, ${address.province} ${address.postalCode}', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
