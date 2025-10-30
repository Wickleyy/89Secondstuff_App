import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/modules/auth/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated spacing when keyboard is open
                SizedBox(height: isKeyboardOpen ? 20 : 60),

                // Logo Section
                _buildLogoSection(theme, colorScheme),
                SizedBox(height: isKeyboardOpen ? 20 : 50),

                // Form Section
                _buildFormSection(theme, colorScheme),
                SizedBox(height: isKeyboardOpen ? 20 : 30),

                // Social Login
                if (!isKeyboardOpen) ...[
                  _buildDivider(theme, colorScheme),
                  const SizedBox(height: 20),
                  _buildSocialLoginButtons(theme, colorScheme),
                  const SizedBox(height: 30),
                ],

                // Sign Up Link
                _buildSignUpSection(theme, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logo & Title Section
  Widget _buildLogoSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        // Logo/Icon Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primary,
                colorScheme.primary.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.shopping_bag_outlined,
            size: 48,
            color: colorScheme.onPrimary,
          ),
        ),
        const SizedBox(height: 24),
        // App Name
        Text(
          '89secondStuff',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        // Tagline
        Text(
          'Welcome back, find your style!',
          style: theme.textTheme.titleMedium?.copyWith(
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
        // Username TextField
        _buildTextFieldWithIcon(
          controller: controller.usernameController,
          label: 'Username',
          hint: 'Masukkan username Anda',
          icon: Icons.person_outline,
          theme: theme,
          colorScheme: colorScheme,
          obscure: false,
        ),
        const SizedBox(height: 20),

        // Password TextField
        _buildTextFieldWithIcon(
          controller: controller.passwordController,
          label: 'Password',
          hint: 'Masukkan password Anda',
          icon: Icons.lock_outline,
          theme: theme,
          colorScheme: colorScheme,
          obscure: true,
        ),
        const SizedBox(height: 12),

        // Remember Me & Forgot Password Row
        _buildRememberForgotRow(theme, colorScheme),
        const SizedBox(height: 30),

        // Login Button
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  controller.isLoading.value ? null : controller.login,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'LOGIN',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // Reusable TextField with Icon
  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required ThemeData theme,
    required ColorScheme colorScheme,
    required bool obscure,
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
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(
              icon,
              color: colorScheme.primary.withOpacity(0.7),
            ),
            suffixIcon: obscure
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_off_outlined,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    onPressed: () {},
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

  // Remember Me & Forgot Password
  Widget _buildRememberForgotRow(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: false,
                onChanged: (value) {},
                activeColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.snackbar(
              'Info',
              'Fitur Forgot Password belum tersedia',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text(
            'Forgot Password?',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // Divider dengan Text
  Widget _buildDivider(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'atau',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outline.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  // Social Login Buttons
  Widget _buildSocialLoginButtons(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          'Masuk dengan',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              theme,
              colorScheme,
              '𝓰',
              'Google',
              () {
                Get.snackbar(
                  'Info',
                  'Google Login belum tersedia',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
            const SizedBox(width: 16),
            _buildSocialButton(
              theme,
              colorScheme,
              '◆',
              'Apple',
              () {
                Get.snackbar(
                  'Info',
                  'Apple Login belum tersedia',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // Social Button Component
  Widget _buildSocialButton(
    ThemeData theme,
    ColorScheme colorScheme,
    String symbol,
    String label,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.3),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                symbol,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sign Up Section
  Widget _buildSignUpSection(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Belum punya akun? ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        TextButton(
          onPressed: controller.goToSignUp,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Daftar di sini',
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
}