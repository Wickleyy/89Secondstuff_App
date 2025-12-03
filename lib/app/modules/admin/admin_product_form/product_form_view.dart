import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'product_form_controller.dart';

class AdminProductFormView extends GetView<AdminProductFormController> {
  const AdminProductFormView({super.key});

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
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildImageSection(isDark),
                          const SizedBox(height: 32),
                          Text('INFORMASI PRODUK', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : AppTheme.lightPrimary.withValues(alpha: 0.6))),
                          const SizedBox(height: 16),
                          _buildTextField(controller.titleC, 'Nama Produk', Icons.label_outline, isDark, validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null),
                          const SizedBox(height: 16),
                          _buildTextField(controller.priceC, 'Harga', Icons.attach_money, isDark, prefix: 'Rp ', keyboardType: TextInputType.number, validator: (v) => v == null || v.isEmpty ? 'Harga wajib diisi' : null),
                          const SizedBox(height: 16),
                          _buildCategoryDropdown(isDark),
                          const SizedBox(height: 16),
                          _buildTextField(controller.descriptionC, 'Deskripsi Produk', Icons.description_outlined, isDark, maxLines: 4, validator: (v) => v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null),
                          const SizedBox(height: 40),
                          _buildSaveButton(isDark),
                          const SizedBox(height: 20),
                        ],
                      ),
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
          Text(controller.productToEdit == null ? 'Tambah Produk' : 'Edit Produk', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.lightOnText)),
        ],
      ),
    );
  }

  Widget _buildImageSection(bool isDark) {
    return Center(
      child: GestureDetector(
        onTap: controller.pickImage,
        child: Stack(
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.5), AppTheme.deepPurpleDark.withValues(alpha: 0.7)]) : null,
                color: isDark ? null : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.transparent),
                boxShadow: [BoxShadow(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(borderRadius: BorderRadius.circular(24), child: _buildImagePreview(isDark)),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [AppTheme.lightPrimary, AppTheme.lightSupport]),
                  shape: BoxShape.circle,
                  border: Border.all(color: isDark ? AppTheme.deepPurpleDark : Colors.white, width: 3),
                  boxShadow: [BoxShadow(color: (isDark ? AppTheme.accentMustard : AppTheme.lightPrimary).withValues(alpha: 0.4), blurRadius: 8)],
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(bool isDark) {
    if (controller.selectedImage.value != null) {
      return Image.file(controller.selectedImage.value!, fit: BoxFit.cover);
    } else if (controller.existingImageUrl.value.isNotEmpty) {
      return Image.network(controller.existingImageUrl.value, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Center(child: Icon(Icons.broken_image, color: isDark ? Colors.white38 : Colors.grey[400], size: 40)));
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 48, color: isDark ? Colors.white30 : Colors.grey[300]),
          const SizedBox(height: 8),
          Text('Tambah Foto', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey[400])),
        ],
      );
    }
  }

  Widget _buildTextField(TextEditingController textController, String label, IconData icon, bool isDark, {String? prefix, int maxLines = 1, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.1), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: TextFormField(
        controller: textController,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: isDark ? Colors.white : AppTheme.lightOnText),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey[600]),
          prefixText: prefix,
          prefixStyle: GoogleFonts.poppins(color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary, fontWeight: FontWeight.bold),
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [AppTheme.lightPrimary.withValues(alpha: 0.12), AppTheme.lightPrimary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: maxLines > 1 ? 16 : 0),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : Colors.transparent),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.1), blurRadius: 10)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Obx(() => DropdownButtonFormField<int>(
            initialValue: controller.selectedCategoryId.value,
            style: GoogleFonts.poppins(color: isDark ? Colors.white : AppTheme.lightOnText),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary),
            dropdownColor: isDark ? AppTheme.deepPurpleLight : Colors.white,
            borderRadius: BorderRadius.circular(16),
            decoration: InputDecoration(
              labelText: 'Pilih Kategori',
              labelStyle: GoogleFonts.poppins(color: isDark ? Colors.white54 : Colors.grey[600]),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [AppTheme.lightPrimary.withValues(alpha: 0.12), AppTheme.lightPrimary.withValues(alpha: 0.05)]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.category_outlined, color: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary, size: 20),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            items: controller.categories.map((cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name, style: GoogleFonts.poppins(color: isDark ? Colors.white : AppTheme.lightOnText)))).toList(),
            onChanged: (value) => controller.selectedCategoryId.value = value,
            validator: (value) => controller.productToEdit == null && value == null ? 'Kategori wajib dipilih' : null,
          )),
    );
  }

  Widget _buildSaveButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? AppTheme.accentMustard : AppTheme.lightPrimary,
          foregroundColor: Colors.white,
          elevation: isDark ? 8 : 4,
          shadowColor: (isDark ? AppTheme.accentMustard : AppTheme.lightPrimary).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Text('SIMPAN PRODUK', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1)),
      ),
    );
  }
}
