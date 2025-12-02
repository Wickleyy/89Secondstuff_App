import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/controllers/address_controller.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:intl/intl.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final Box<CartItem> cartBox = Get.find<LocalStorageService>().cartBox;

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
                child: ValueListenableBuilder(
                  valueListenable: cartBox.listenable(),
                  builder: (context, Box<CartItem> box, _) {
                    final items = box.values.toList();
                    if (items.isEmpty) return _buildEmptyCart(isDark, colorScheme);
                    return Column(
                      children: [
                        _buildAddressSection(theme, colorScheme, isDark),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: items.length,
                            itemBuilder: (context, index) => _buildCartItemTile(items[index], isDark, colorScheme),
                          ),
                        ),
                        _buildCheckoutSummary(isDark, colorScheme),
                      ],
                    );
                  },
                ),
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
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
          const SizedBox(width: 16),
          Text('Keranjang Saya', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
          const Spacer(),
          GetBuilder<CartController>(
            builder: (_) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('${_.totalItemCount} item', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart_outlined, size: 64, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.6) : colorScheme.primary.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 24),
          Text('Keranjang Kosong', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text('Ayo tambahkan produk favorit!', style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
              foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('Mulai Belanja', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(ThemeData theme, ColorScheme colorScheme, bool isDark) {
    return GetBuilder<AddressController>(
      init: Get.isRegistered<AddressController>() ? Get.find<AddressController>() : Get.put(AddressController()),
      builder: (addressController) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          padding: const EdgeInsets.all(16),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.location_on, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text('Alamat Pengiriman', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface)),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (addressController.isLoading.value) return const Center(child: Padding(padding: EdgeInsets.all(8), child: CircularProgressIndicator(strokeWidth: 2)));
                final selected = addressController.selectedAddress.value;
                if (selected == null) {
                  return InkWell(
                    onTap: () => _showAddressSelector(addressController, isDark),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.1), AppTheme.accentRed.withValues(alpha: 0.05)]) : null,
                        color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_location_alt, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
                          const SizedBox(width: 8),
                          Text('Pilih Alamat Pengiriman', style: GoogleFonts.poppins(color: isDark ? AppTheme.accentMustard : colorScheme.primary, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  );
                }
                return InkWell(
                  onTap: () => _showAddressSelector(addressController, isDark),
                  borderRadius: BorderRadius.circular(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(selected.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface)),
                                if (selected.isDefault)
                                  Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.green, Colors.teal]), borderRadius: BorderRadius.circular(6)),
                                    child: Text('Default', style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(selected.phone, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
                            const SizedBox(height: 2),
                            Text(selected.fullAddress, style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5)), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.4)),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showAddressSelector(AddressController addressController, bool isDark) {
    if (addressController.addresses.isEmpty) {
      Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
      return;
    }
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
          color: isDark ? null : Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pilih Alamat', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : null)),
                  TextButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
                    },
                    icon: Icon(Icons.add, size: 18, color: isDark ? AppTheme.accentMustard : null),
                    label: Text('Tambah', style: TextStyle(color: isDark ? AppTheme.accentMustard : null)),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? Colors.white12 : null),
            Flexible(
              child: Obx(() => ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: addressController.addresses.length,
                    itemBuilder: (context, index) {
                      final address = addressController.addresses[index];
                      final isSelected = addressController.selectedAddress.value?.id == address.id;
                      return ListTile(
                        leading: Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? (isDark ? AppTheme.accentMustard : Get.theme.colorScheme.primary) : Colors.grey),
                        title: Row(
                          children: [
                            Text(address.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: isDark ? Colors.white : null)),
                            if (address.isDefault)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4)),
                                child: Text('Default', style: GoogleFonts.poppins(color: Colors.green, fontSize: 10)),
                              ),
                          ],
                        ),
                        subtitle: Text(address.fullAddress, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: isDark ? Colors.white60 : null)),
                        onTap: () {
                          addressController.selectAddress(address);
                          Get.back();
                        },
                      );
                    },
                  )),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCartItemTile(CartItem item, bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.1), blurRadius: 8)] : null,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)]),
            child: Image.network(item.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, color: Colors.grey[400])),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                    color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(item.price), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.2)]) : null,
              color: isDark ? null : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                IconButton(icon: Icon(Icons.add, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20), onPressed: () => controller.addToCart(Product.fromJson(item.toJsonForProduct())), constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
                Text(item.quantity.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white : colorScheme.onSurface)),
                IconButton(icon: Icon(Icons.remove, color: AppTheme.accentRed, size: 20), onPressed: () => controller.removeFromCart(Product.fromJson(item.toJsonForProduct())), constraints: const BoxConstraints(minWidth: 36, minHeight: 36)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSummary(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<CartController>(builder: (_) => Text('Total (${_.totalItemCount} item)', style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7)))),
              GetBuilder<CartController>(
                builder: (_) => Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_.totalPrice), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.CHECKOUT),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isDark ? 8 : 2,
                shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_checkout, size: 22),
                  const SizedBox(width: 10),
                  Text('CHECKOUT', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
