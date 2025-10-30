import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    theme,
                    colorScheme,
                    '1. Pengumpulan Informasi',
                    'Kami mengumpulkan informasi yang Anda berikan secara sukarela melalui formulir pendaftaran, profil pengguna, dan riwayat transaksi. Informasi ini termasuk nama, email, nomor telepon, dan alamat pengiriman.',
                  ),
                  _buildSection(
                    theme,
                    colorScheme,
                    '2. Penggunaan Informasi',
                    'Informasi Anda digunakan untuk memproses pesanan, mengirim notifikasi, meningkatkan layanan, dan mengirimkan promosi (jika Anda setuju). Kami tidak akan membagikan informasi Anda kepada pihak ketiga tanpa persetujuan.',
                  ),
                  _buildSection(
                    theme,
                    colorScheme,
                    '3. Keamanan Data',
                    'Kami menggunakan enkripsi dan protokol keamanan terbaru untuk melindungi data pribadi Anda. Semua transaksi dilindungi dengan SSL certificate untuk memastikan keamanan maksimal.',
                  ),
                  _buildSection(
                    theme,
                    colorScheme,
                    '4. Cookie dan Tracking',
                    'Aplikasi kami menggunakan cookies untuk meningkatkan pengalaman pengguna dan menganalisis pola penggunaan. Anda dapat menonaktifkan cookies melalui pengaturan perangkat Anda.',
                  ),
                  _buildSection(
                    theme,
                    colorScheme,
                    '5. Hak Pengguna',
                    'Anda memiliki hak untuk mengakses, mengubah, atau menghapus data pribadi Anda. Hubungi tim support kami untuk permintaan perubahan data.',
                  ),
                  _buildSection(
                    theme,
                    colorScheme,
                    '6. Hubungi Kami',
                    'Jika Anda memiliki pertanyaan tentang kebijakan privasi ini, silakan hubungi kami di support@89secondstuff.com atau +62 812-3456-7890.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildAgreementSection(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.8),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildAgreementSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Obx(
            () => CheckboxListTile(
              value: controller.agreeToTerms.value,
              onChanged: (value) =>
                  controller.toggleAgreeToTerms(value ?? false),
              title: Text(
                'Saya setuju dengan Syarat & Ketentuan',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => CheckboxListTile(
              value: controller.agreeToPrivacy.value,
              onChanged: (value) =>
                  controller.toggleAgreeToPrivacy(value ?? false),
              title: Text(
                'Saya setuju dengan Kebijakan Privasi',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: colorScheme.primary,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (controller.agreeToTerms.value &&
                        controller.agreeToPrivacy.value)
                    ? () {
                        Get.snackbar(
                          'Success',
                          'Anda telah menerima kebijakan privasi',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        Get.back();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor:
                      colorScheme.primary.withOpacity(0.5),
                ),
                child: Text(
                  'TERIMA KEBIJAKAN',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.acceptAll,
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'TERIMA SEMUA',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}