import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';

class AuthController extends GetxController {
  SupabaseService get _supabaseService => Get.find<SupabaseService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoadingLogin = false.obs;
  var isLoginPasswordHidden = true.obs;

  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  var isLoadingSignUp = false.obs;
  var isSignUpPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordHidden.value = !isLoginPasswordHidden.value;
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordHidden.value = !isSignUpPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<void> signInWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingLogin.value = true;
    try {
      debugPrint('[Login] Attempting login for: $email');
      
      final authResponse = await _supabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final userId = authResponse.user?.id;
      if (userId == null) {
        throw Exception("User tidak ditemukan setelah login.");
      }
      debugPrint('[Login] User ID: $userId');

      String role = 'user';
      try {
        final profileResponse = await _supabaseService.client
            .from('profiles')
            .select('id, email, role')
            .eq('id', userId)
            .maybeSingle();

        if (profileResponse != null) {
          final profile = Profile.fromJson(profileResponse);
          role = profile.role;
        } else {
          debugPrint('[Login] Creating missing profile...');
          await _supabaseService.client.from('profiles').upsert({
            'id': userId,
            'email': email,
            'role': 'user',
          });
        }
      } catch (profileError) {
        debugPrint('[Login] Profile check error: $profileError');
      }

      isLoadingLogin.value = false;
      
      Get.snackbar(
        'Login Berhasil',
        'Selamat datang!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      debugPrint('[Login] Role: $role, navigating...');
      if (role == 'admin') {
        Get.offAllNamed(AppRoutes.ADMIN_HOME);
      } else {
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      }
    } on AuthException catch (e) {
      isLoadingLogin.value = false;
      debugPrint('[Login] AuthException: ${e.message}');
      
      String message = e.message;
      if (e.message.contains('Invalid login credentials')) {
        message = 'Email atau password salah';
      } else if (e.message.contains('Email not confirmed')) {
        message = 'Email belum dikonfirmasi. Silakan cek inbox email Anda.';
      } else if (e.message.contains('too many requests')) {
        message = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      }
      
      Get.snackbar(
        'Login Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      isLoadingLogin.value = false;
      debugPrint('[Login] Error: $e');
      Get.snackbar(
        'Login Gagal',
        'Terjadi kesalahan. Periksa koneksi internet Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signUpWithEmail() async {
    final email = emailSignUpController.text.trim();
    final password = passwordSignUpController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar(
        'Error',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Error',
        'Password minimal 6 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoadingSignUp.value = true;
    try {
      debugPrint('[SignUp] Creating account for: $email');
      
      final response = await _supabaseService.client.auth.signUp(
        email: email,
        password: password,
      );

      debugPrint('[SignUp] Response user: ${response.user?.id}');
      debugPrint('[SignUp] Session exists: ${response.session != null}');

      if (response.user != null) {
        try {
          await Future.delayed(const Duration(milliseconds: 500));
          
          final existingProfile = await _supabaseService.client
              .from('profiles')
              .select('id')
              .eq('id', response.user!.id)
              .maybeSingle();

          if (existingProfile == null) {
            await _supabaseService.client.from('profiles').insert({
              'id': response.user!.id,
              'email': email,
              'role': 'user',
            });
            debugPrint('[SignUp] Profile created manually');
          }
        } catch (profileError) {
          debugPrint('[SignUp] Profile creation note: $profileError');
        }
      }

      isLoadingSignUp.value = false;

      if (response.session != null) {
        Get.snackbar(
          'Registrasi Berhasil',
          'Akun berhasil dibuat! Selamat datang!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        emailSignUpController.clear();
        passwordSignUpController.clear();
        
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      } else if (response.user != null) {
        Get.snackbar(
          'Registrasi Berhasil',
          'Silakan cek email Anda untuk verifikasi.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        
        emailSignUpController.clear();
        passwordSignUpController.clear();
        
        Get.back();
      } else {
        throw Exception('Gagal membuat akun');
      }
    } on AuthException catch (e) {
      isLoadingSignUp.value = false;
      debugPrint('[SignUp] AuthException: ${e.message}');
      
      String message = e.message;
      if (e.message.contains('User already registered')) {
        message = 'Email sudah terdaftar. Silakan login.';
      } else if (e.message.contains('Password should be')) {
        message = 'Password terlalu lemah. Gunakan kombinasi huruf dan angka.';
      } else if (e.message.contains('rate limit')) {
        message = 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      }
      
      Get.snackbar(
        'Registrasi Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      isLoadingSignUp.value = false;
      debugPrint('[SignUp] Error: $e');
      Get.snackbar(
        'Registrasi Gagal',
        'Terjadi kesalahan. Periksa koneksi internet Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goToSignUp() {
    emailSignUpController.clear();
    passwordSignUpController.clear();
    Get.toNamed(AppRoutes.SIGNUP);
  }

  void logout() async {
    try {
      await _supabaseService.client.auth.signOut();
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      debugPrint('[Logout] Error: $e');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailSignUpController.dispose();
    passwordSignUpController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
