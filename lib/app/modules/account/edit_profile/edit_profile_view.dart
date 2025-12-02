import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark],
                )
              : null,
          color: isDark ? null : colorScheme.surface,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildAvatarSection(isDark, colorScheme),
                      const SizedBox(height: 36),
                      _buildTextField('Nama Lengkap', 'Masukkan nama Anda', Icons.person_outline, controller.fullNameController, isDark, colorScheme),
                      const SizedBox(height: 20),
                      _buildTextField('Email', 'email@example.com', Icons.email_outlined, controller.emailController, isDark, colorScheme, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildTextField('Nomor Telepon', '08xx...', Icons.phone_outlined, controller.phoneController, isDark, colorScheme, keyboardType: TextInputType.phone),
                      const SizedBox(height: 36),
                      _buildSaveButton(isDark, colorScheme),
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

  Widget _buildAppBar(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)])
                  : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 8)] : null,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary),
              onPressed: () => Get.back(),
            ),
          ),
          const SizedBox(width: 16),
          Text('Edit Profil', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(bool isDark, ColorScheme colorScheme) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]),
                boxShadow: isDark ? [BoxShadow(color: AppTheme.accentMustard.withValues(alpha: 0.4), blurRadius: 20, spreadRadius: 2)] : null,
              ),
              child: Obx(() {
                ImageProvider? imageProvider;
                if (controller.selectedImage.value != null) {
                  imageProvider = FileImage(controller.selectedImage.value!);
                } else if (controller.avatarUrl.value.isNotEmpty) {
                  imageProvider = NetworkImage(controller.avatarUrl.value);
                }
                return CircleAvatar(
                  radius: 56,
                  backgroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.surface,
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Icon(Icons.person, size: 56, color: isDark ? AppTheme.accentMustard : colorScheme.primary)
                      : null,
                );
              }),
            ),
            Obx(() {
              if (controller.isUploadingImage.value) {
                return Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                    child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]),
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? AppTheme.deepPurpleDark : Colors.white, width: 3),
                    boxShadow: [BoxShadow(color: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.4), blurRadius: 8)],
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text('Tap kamera untuk ganti foto', style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white54 : Colors.grey)),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon, TextEditingController textController, bool isDark, ColorScheme colorScheme, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
            color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : Colors.transparent),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 10)] : null,
          ),
          child: TextField(
            controller: textController,
            keyboardType: keyboardType,
            style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
              prefixIcon: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]
                        : [colorScheme.primary.withValues(alpha: 0.1), colorScheme.primary.withValues(alpha: 0.05)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton(bool isDark, ColorScheme colorScheme) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
              foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: isDark ? 8 : 2,
              shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
            ),
            child: controller.isLoading.value
                ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('SIMPAN PERUBAHAN', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ));
  }
}
