import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'help_center_controller.dart';

class HelpCenterView extends GetView<HelpCenterController> {
  const HelpCenterView({super.key});

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(isDark, colorScheme),
                      const SizedBox(height: 24),
                      _buildFAQSection(isDark, colorScheme),
                      const SizedBox(height: 24),
                      _buildContactSection(isDark, colorScheme),
                      const SizedBox(height: 32),
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
          Text('Pusat Bantuan', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? Colors.white : colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark ? [AppTheme.deepPurpleLight, AppTheme.deepPurpleDark] : [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.3), blurRadius: 16)] : [BoxShadow(color: colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.support_agent, color: isDark ? AppTheme.accentMustard : Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Kami di sini untuk membantu', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Tim support siap 24/7', style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FAQ'.toUpperCase(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              final faq = controller.faqs[index];
              return Obx(() => _buildFAQItem(faq, index, isDark, colorScheme));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(FAQ faq, int index, bool isDark, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Theme(
        data: Theme.of(Get.context!).copyWith(splashColor: Colors.transparent, dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (_) => controller.toggleFAQ(index),
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Text(faq.question, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14, color: isDark ? Colors.white : colorScheme.onSurface)),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.1), colorScheme.primary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(faq.isExpanded.value ? Icons.expand_less : Icons.expand_more, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
          ),
          initiallyExpanded: faq.isExpanded.value,
          children: [
            Text(faq.answer, style: GoogleFonts.poppins(fontSize: 13, height: 1.6, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('HUBUNGI KAMI', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email_outlined, 'Email', 'support@89secondstuff.com', isDark, colorScheme),
          const SizedBox(height: 12),
          _buildContactItem(Icons.phone_outlined, 'WhatsApp', '+62 812-3456-7890', isDark, colorScheme),
          const SizedBox(height: 12),
          _buildContactItem(Icons.location_on_outlined, 'Lokasi', 'Malang, Jawa Timur', isDark, colorScheme),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
        color: isDark ? null : colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.poppins(fontSize: 11, color: isDark ? Colors.white54 : colorScheme.onSurface.withValues(alpha: 0.5))),
                const SizedBox(height: 2),
                Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.3)),
        ],
      ),
    );
  }
}
