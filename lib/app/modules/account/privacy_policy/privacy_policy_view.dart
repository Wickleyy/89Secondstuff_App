import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});

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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSection('1. Pengumpulan Informasi', 'Kami mengumpulkan informasi yang Anda berikan secara sukarela melalui formulir pendaftaran, profil pengguna, dan riwayat transaksi. Informasi ini termasuk nama, email, nomor telepon, dan alamat pengiriman.', Icons.info_outline, isDark, colorScheme),
                      _buildSection('2. Penggunaan Informasi', 'Informasi Anda digunakan untuk memproses pesanan, mengirim notifikasi, meningkatkan layanan, dan mengirimkan promosi (jika Anda setuju). Kami tidak akan membagikan informasi Anda kepada pihak ketiga tanpa persetujuan.', Icons.assignment_outlined, isDark, colorScheme),
                      _buildSection('3. Keamanan Data', 'Kami menggunakan enkripsi dan protokol keamanan terbaru untuk melindungi data pribadi Anda. Semua transaksi dilindungi dengan SSL certificate untuk memastikan keamanan maksimal.', Icons.security_outlined, isDark, colorScheme),
                      _buildSection('4. Cookie dan Tracking', 'Aplikasi kami menggunakan cookies untuk meningkatkan pengalaman pengguna dan menganalisis pola penggunaan. Anda dapat menonaktifkan cookies melalui pengaturan perangkat Anda.', Icons.cookie_outlined, isDark, colorScheme),
                      _buildSection('5. Hak Pengguna', 'Anda memiliki hak untuk mengakses, mengubah, atau menghapus data pribadi Anda. Hubungi tim support kami untuk permintaan perubahan data.', Icons.person_outline, isDark, colorScheme),
                      _buildSection('6. Hubungi Kami', 'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami di support@89secondstuff.com atau +62 812-3456-7890.', Icons.support_agent_outlined, isDark, colorScheme),
                      const SizedBox(height: 8),
                      _buildAgreementSection(isDark, colorScheme),
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
          const SizedBox(width: 16),
          Text('Kebijakan Privasi', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
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
                child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface))),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: GoogleFonts.poppins(fontSize: 13, height: 1.6, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
        ],
      ),
    );
  }

  Widget _buildAgreementSection(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Obx(() => _buildCheckbox('Saya setuju dengan Syarat & Ketentuan', controller.agreeToTerms.value, (v) => controller.toggleAgreeToTerms(v ?? false), isDark, colorScheme)),
          const SizedBox(height: 8),
          Obx(() => _buildCheckbox('Saya setuju dengan Kebijakan Privasi', controller.agreeToPrivacy.value, (v) => controller.toggleAgreeToPrivacy(v ?? false), isDark, colorScheme)),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (controller.agreeToTerms.value && controller.agreeToPrivacy.value)
                      ? () {
                          Get.snackbar('Berhasil', 'Anda telah menerima kebijakan privasi', snackPosition: SnackPosition.BOTTOM, backgroundColor: isDark ? AppTheme.deepPurpleLight : null, colorText: isDark ? Colors.white : null);
                          Get.back();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                    foregroundColor: isDark ? AppTheme.deepPurpleDark : colorScheme.onPrimary,
                    disabledBackgroundColor: (isDark ? AppTheme.accentMustard : colorScheme.primary).withValues(alpha: 0.4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: isDark ? 6 : 2,
                    shadowColor: isDark ? AppTheme.accentMustard.withValues(alpha: 0.4) : null,
                  ),
                  child: Text('TERIMA KEBIJAKAN', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                ),
              )),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.acceptAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? AppTheme.accentMustard : colorScheme.primary,
                side: BorderSide(color: isDark ? AppTheme.accentMustard : colorScheme.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text('TERIMA SEMUA', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged, bool isDark, ColorScheme colorScheme) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                gradient: value ? LinearGradient(colors: isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [colorScheme.primary, colorScheme.secondary]) : null,
                color: value ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: value ? Colors.transparent : (isDark ? Colors.white38 : colorScheme.outline), width: 2),
              ),
              child: value ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? Colors.white : colorScheme.onSurface))),
          ],
        ),
      ),
    );
  }
}
