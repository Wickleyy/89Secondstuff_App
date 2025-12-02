import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'shipping_address_controller.dart';

class AddressFormView extends GetView<ShippingAddressController> {
  const AddressFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final addressId = Get.arguments as int?;
    final isEditMode = addressId != null;

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
              _buildAppBar(isEditMode, isDark, colorScheme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Nama Penerima', 'Masukkan nama penerima', Icons.person_outline, controller.nameController, isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildTextField('Nomor Telepon', '08123456789', Icons.phone_outlined, controller.phoneController, isDark, colorScheme, keyboardType: TextInputType.phone),
                      const SizedBox(height: 20),
                      _buildMapPicker(isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildTextField('Alamat Lengkap', 'Jalan, No. Rumah, RT/RW', Icons.home_outlined, controller.addressController, isDark, colorScheme, maxLines: 3),
                      const SizedBox(height: 20),
                      _buildTextField('Kota', 'Masukkan nama kota', Icons.location_city_outlined, controller.cityController, isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildTextField('Provinsi', 'Masukkan nama provinsi', Icons.map_outlined, controller.provinceController, isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildTextField('Kode Pos', '65141', Icons.markunread_mailbox_outlined, controller.postalCodeController, isDark, colorScheme, keyboardType: TextInputType.number),
                      const SizedBox(height: 24),
                      _buildDefaultCheckbox(isDark, colorScheme),
                      const SizedBox(height: 32),
                      _buildSaveButton(isEditMode, addressId, isDark, colorScheme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isEditMode, bool isDark, ColorScheme colorScheme) {
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
          Text(isEditMode ? 'Edit Alamat' : 'Tambah Alamat', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController textController, bool isDark, ColorScheme colorScheme, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
            color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: textController,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: maxLines > 1 ? 16 : 0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapPicker(bool isDark, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi di Peta', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
        const SizedBox(height: 10),
        Obx(() => InkWell(
              onTap: controller.openMapPicker,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? LinearGradient(colors: controller.hasLocation ? [AppTheme.accentMustard.withValues(alpha: 0.15), AppTheme.accentRed.withValues(alpha: 0.1)] : [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)])
                      : LinearGradient(colors: [colorScheme.primary.withValues(alpha: controller.hasLocation ? 0.12 : 0.06), colorScheme.primary.withValues(alpha: controller.hasLocation ? 0.06 : 0.02)]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: controller.hasLocation ? (isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : colorScheme.primary) : (isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.2))),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.25), AppTheme.accentRed.withValues(alpha: 0.15)] : [colorScheme.primary.withValues(alpha: 0.15), colorScheme.primary.withValues(alpha: 0.08)]),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(controller.hasLocation ? Icons.location_on : Icons.add_location_alt_outlined, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(controller.hasLocation ? 'Lokasi Terpilih' : 'Pilih Lokasi dari Peta', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
                          if (controller.hasLocation)
                            Text('${controller.selectedLatitude.value?.toStringAsFixed(6)}, ${controller.selectedLongitude.value?.toStringAsFixed(6)}', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: isDark ? AppTheme.accentMustard : colorScheme.primary),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildDefaultCheckbox(bool isDark, ColorScheme colorScheme) {
    return Obx(() => InkWell(
          onTap: () => controller.isDefaultAddress.value = !controller.isDefaultAddress.value,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
              color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: controller.isDefaultAddress.value ? LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]) : null,
                    color: controller.isDefaultAddress.value ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: controller.isDefaultAddress.value ? Colors.transparent : (isDark ? Colors.white38 : colorScheme.outline), width: 2),
                  ),
                  child: controller.isDefaultAddress.value ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
                const SizedBox(width: 12),
                Text('Jadikan sebagai alamat default', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: isDark ? Colors.white : colorScheme.onSurface)),
              ],
            ),
          ),
        ));
  }

  Widget _buildSaveButton(bool isEditMode, int? addressId, bool isDark, ColorScheme colorScheme) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => isEditMode ? controller.updateAddress(addressId!) : controller.createAddress(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
              foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
              disabledBackgroundColor: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.5),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: isDark ? 8 : 2,
              shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(isEditMode ? 'UPDATE ALAMAT' : 'SIMPAN ALAMAT', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ));
  }
}
