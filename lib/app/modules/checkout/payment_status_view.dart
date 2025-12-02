import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class PaymentStatusView extends StatelessWidget {
  const PaymentStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final orderId = args?['orderId'] ?? '';
    final status = args?['status'] ?? 'pending';
    final redirectUrl = args?['redirectUrl'] as String?;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppTheme.deepPurpleDark, Color(0xFF251742), AppTheme.deepPurpleDark])
                : null,
            color: isDark ? null : colorScheme.surface,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  _buildStatusIcon(status, isDark),
                  const SizedBox(height: 32),
                  Text(_getStatusTitle(status), style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Text(_getStatusMessage(status), style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white60 : colorScheme.onSurface.withValues(alpha: 0.6)), textAlign: TextAlign.center),
                  const SizedBox(height: 28),
                  _buildOrderIdCard(orderId, isDark, colorScheme),
                  const Spacer(),
                  if (status == 'pending') ...[
                    if (redirectUrl != null && redirectUrl.isNotEmpty) ...[
                      _buildActionButton('Lanjutkan Pembayaran', Icons.payment, Colors.green, () async {
                        final uri = Uri.parse(redirectUrl);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          Get.snackbar('Error', 'Tidak dapat membuka halaman pembayaran', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
                        }
                      }, isDark),
                      const SizedBox(height: 12),
                    ],
                    _buildActionButton('Cek Status Pembayaran', Icons.refresh, isDark ? AppTheme.glowPurple : colorScheme.secondary, () => Get.snackbar('Info', 'Mengecek status pembayaran...', snackPosition: SnackPosition.BOTTOM, backgroundColor: isDark ? AppTheme.deepPurpleLight : null, colorText: isDark ? Colors.white : null), isDark),
                    const SizedBox(height: 12),
                  ],
                  _buildActionButton('Lihat Pesanan Saya', Icons.receipt_long, isDark ? AppTheme.accentMustard : colorScheme.primary, () => Get.offAllNamed(AppRoutes.ORDER_HISTORY), isDark),
                  const SizedBox(height: 12),
                  _buildActionButton('Kembali ke Beranda', Icons.home, Colors.grey, () => Get.offAllNamed(AppRoutes.MAIN_NAVIGATION), isDark, isOutlined: true),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status, bool isDark) {
    IconData icon;
    List<Color> gradientColors;

    switch (status) {
      case 'success':
        icon = Icons.check_circle;
        gradientColors = [Colors.green, Colors.teal];
        break;
      case 'pending':
        icon = Icons.access_time_filled;
        gradientColors = isDark ? [AppTheme.accentMustard, AppTheme.accentRed] : [Colors.orange, Colors.deepOrange];
        break;
      case 'failed':
        icon = Icons.cancel;
        gradientColors = [Colors.red, Colors.redAccent];
        break;
      default:
        icon = Icons.help;
        gradientColors = [Colors.grey, Colors.blueGrey];
    }

    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [gradientColors[0].withValues(alpha: 0.2), gradientColors[1].withValues(alpha: 0.1)]),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: gradientColors[0].withValues(alpha: 0.3), blurRadius: 24, spreadRadius: 4)],
      ),
      child: Center(
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(colors: gradientColors).createShader(bounds),
          child: Icon(icon, size: 72, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOrderIdCard(String orderId, bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.15), blurRadius: 12)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.tag, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Pesanan', style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
              Text(orderId.length > 12 ? '${orderId.substring(0, 12)}...' : orderId, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusTitle(String status) {
    switch (status) {
      case 'success':
        return 'Pembayaran Berhasil!';
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'failed':
        return 'Pembayaran Gagal';
      default:
        return 'Status Tidak Diketahui';
    }
  }

  String _getStatusMessage(String status) {
    switch (status) {
      case 'success':
        return 'Terima kasih! Pesanan Anda sedang diproses dan akan segera dikirim.';
      case 'pending':
        return 'Silakan selesaikan pembayaran Anda untuk memproses pesanan.';
      case 'failed':
        return 'Maaf, pembayaran Anda gagal. Silakan coba lagi atau gunakan metode pembayaran lain.';
      default:
        return 'Silakan hubungi customer service untuk bantuan.';
    }
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed, bool isDark, {bool isOutlined = false}) {
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? Colors.white70 : color,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            side: BorderSide(color: isDark ? Colors.white30 : color),
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: isDark ? 8 : 2,
          shadowColor: color.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
