import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Buat Akun',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: isKeyboardOpen ? 20 : 30),

              // Header Section
              _buildHeaderSection(theme, colorScheme),
              SizedBox(height: isKeyboardOpen ? 20 : 40),

              // Form Section
              _buildFormSection(theme, colorScheme),
              const SizedBox(height: 20),

              // Terms & Conditions
              _buildTermsSection(theme, colorScheme),
              const SizedBox(height: 30),

              // Create Account Button
              _buildCreateAccountButton(theme, colorScheme),
              const SizedBox(height: 20),

              // Login Link
              _buildLoginSection(theme, colorScheme),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bergabunglah dengan kami',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Daftar sekarang dan mulai belanja dengan gaya!',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Form Section
  Widget _buildFormSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Email TextField
        _buildTextFieldWithLabel(
          controller: emailController,
          label: 'Email',
          hint: 'Masukkan email Anda',
          icon: Icons.email_outlined,
          theme: theme,
          colorScheme: colorScheme,
          keyboardType: TextInputType.emailAddress,
          obscure: false,
          onToggleVisibility: null,
        ),
        const SizedBox(height: 20),

        // Username TextField
        _buildTextFieldWithLabel(
          controller: usernameController,
          label: 'Username',
          hint: 'Pilih username Anda',
          icon: Icons.person_outline,
          theme: theme,
          colorScheme: colorScheme,
          keyboardType: TextInputType.text,
          obscure: false,
          onToggleVisibility: null,
        ),
        const SizedBox(height: 20),

        // Password TextField
        _buildTextFieldWithLabel(
          controller: passwordController,
          label: 'Password',
          hint: 'Buat password yang kuat',
          icon: Icons.lock_outline,
          theme: theme,
          colorScheme: colorScheme,
          keyboardType: TextInputType.text,
          obscure: _obscurePassword,
          onToggleVisibility: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        const SizedBox(height: 12),

        // Password Requirements
        _buildPasswordRequirements(theme, colorScheme),
        const SizedBox(height: 20),

        // Confirm Password TextField
        _buildTextFieldWithLabel(
          controller: confirmPasswordController,
          label: 'Konfirmasi Password',
          hint: 'Ulangi password Anda',
          icon: Icons.lock_outline,
          theme: theme,
          colorScheme: colorScheme,
          keyboardType: TextInputType.text,
          obscure: _obscureConfirmPassword,
          onToggleVisibility: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
      ],
    );
  }

  // Reusable TextField with Label
  Widget _buildTextFieldWithLabel({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required TextInputType keyboardType,
    required bool obscure,
    required Function()? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: colorScheme.primary.withOpacity(0.7),
            ),
            suffixIcon: onToggleVisibility != null
                ? IconButton(
                    icon: Icon(
                      obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: colorScheme.background.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  // Password Requirements
  Widget _buildPasswordRequirements(ThemeData theme, ColorScheme colorScheme) {
    final password = passwordController.text;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasMinLength = password.length >= 8;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password harus mengandung:',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(
            theme,
            colorScheme,
            '• Minimal 8 karakter',
            hasMinLength,
          ),
          _buildRequirementItem(
            theme,
            colorScheme,
            '• Huruf besar (A-Z)',
            hasUppercase,
          ),
          _buildRequirementItem(
            theme,
            colorScheme,
            '• Huruf kecil (a-z)',
            hasLowercase,
          ),
          _buildRequirementItem(
            theme,
            colorScheme,
            '• Angka (0-9)',
            hasNumber,
          ),
        ],
      ),
    );
  }

  // Requirement Item
  Widget _buildRequirementItem(
    ThemeData theme,
    ColorScheme colorScheme,
    String text,
    bool isMet,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isMet ? Colors.green : colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isMet
                  ? Colors.green
                  : colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Terms & Conditions
  Widget _buildTermsSection(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
            activeColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              children: [
                const TextSpan(text: 'Saya setuju dengan '),
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const TextSpan(text: ' dan '),
                TextSpan(
                  text: 'Kebijakan Privasi',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Create Account Button
  Widget _buildCreateAccountButton(ThemeData theme, ColorScheme colorScheme) {
    final isFormValid = emailController.text.isNotEmpty &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text &&
        _agreeToTerms;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isFormValid
            ? () {
                // Validasi password match
                if (passwordController.text !=
                    confirmPasswordController.text) {
                  Get.snackbar(
                    'Error',
                    'Password tidak sesuai',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                Get.snackbar(
                  'Success',
                  'Akun berhasil dibuat! Silakan login.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Get.back();
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isFormValid
              ? colorScheme.primary
              : colorScheme.primary.withOpacity(0.5),
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Text(
          'BUAT AKUN',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Login Link
  Widget _buildLoginSection(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Sudah punya akun? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: () => Get.back(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Masuk di sini',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}