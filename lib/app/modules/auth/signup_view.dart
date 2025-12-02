import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/auth/auth_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
              : LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [colorScheme.surface, colorScheme.surface]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(isDark, colorScheme),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SizedBox(height: isKeyboardOpen ? 10 : 30),
                      _buildHeader(isDark, colorScheme),
                      SizedBox(height: isKeyboardOpen ? 30 : 50),
                      _buildFormSection(isDark, colorScheme),
                      SizedBox(height: isKeyboardOpen ? 20 : 30),
                      _buildLoginSection(isDark, colorScheme),
                      SizedBox(height: isKeyboardOpen ? 20 : 40),
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
              gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.3)]) : null,
              color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(icon: Icon(Icons.arrow_back_rounded, color: isDark ? AppTheme.accentMustard : colorScheme.primary), onPressed: () => Get.back()),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark] : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.3), blurRadius: 16)] : [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12)],
          ),
          child: Icon(Icons.person_add_outlined, size: 44, color: isDark ? AppTheme.accentMustard : Colors.white),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]).createShader(bounds),
          child: Text('Create Account', style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
        const SizedBox(height: 8),
        Text('Start your thrifting journey!', style: GoogleFonts.poppins(fontSize: 15, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
      ],
    );
  }

  Widget _buildFormSection(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 16)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          _buildTextField(controller.emailSignUpController, 'Email', 'Masukkan email Anda', Icons.email_outlined, false, isDark, colorScheme, keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),
          Obx(() => _buildTextField(controller.passwordSignUpController, 'Password', 'Minimal 6 karakter', Icons.lock_outline, controller.isSignUpPasswordHidden.value, isDark, colorScheme, isPassword: true, onToggle: controller.toggleSignUpPasswordVisibility)),
          const SizedBox(height: 16),
          _buildTermsCheckbox(isDark, colorScheme),
          const SizedBox(height: 24),
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoadingSignUp.value ? null : controller.signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                    foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                    disabledBackgroundColor: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: isDark ? 8 : 2,
                    shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : null,
                  ),
                  child: controller.isLoadingSignUp.value
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text('CREATE ACCOUNT', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController textController, String label, String hint, IconData icon, bool obscure, bool isDark, ColorScheme colorScheme, {TextInputType keyboardType = TextInputType.text, bool isPassword = false, VoidCallback? onToggle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
            color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.2)),
          ),
          child: TextField(
            controller: textController,
            obscureText: obscure,
            keyboardType: keyboardType,
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
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
                      onPressed: onToggle,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(bool isDark, ColorScheme colorScheme) {
    return Row(
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: true,
            onChanged: (v) {},
            activeColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
            side: BorderSide(color: isDark ? Colors.white38 : colorScheme.outline.withValues(alpha: 0.4)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6)),
              children: [
                const TextSpan(text: 'Saya setuju dengan '),
                TextSpan(text: 'Syarat & Ketentuan', style: TextStyle(color: isDark ? AppTheme.accentMustard : colorScheme.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginSection(bool isDark, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Sudah punya akun? ', style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6))),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text('Login di sini', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: isDark ? AppTheme.accentMustard : colorScheme.primary, decoration: TextDecoration.underline, decorationColor: isDark ? AppTheme.accentMustard : colorScheme.primary)),
        ),
      ],
    );
  }
}
