import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'help_center_controller.dart';

class HelpCenterView extends GetView<HelpCenterController> {
  const HelpCenterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pusat Bantuan',
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
            // Header dengan Contact Info
            _buildHeaderSection(theme, colorScheme),

            const SizedBox(height: 32),

            // FAQ Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pertanyaan yang Sering Diajukan',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // FAQ List
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.faqs.length,
                itemBuilder: (context, index) {
                  final faq = controller.faqs[index];
                  return _buildFAQItem(theme, colorScheme, faq, index);
                },
              ),
            ),

            const SizedBox(height: 32),

            // Contact Support Section
            _buildContactSupportSection(theme, colorScheme),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kami di sini untuk membantu',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Temukan jawaban atas pertanyaan Anda atau hubungi tim support kami',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimary.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.schedule, color: colorScheme.onPrimary, size: 18),
              const SizedBox(width: 8),
              Text(
                'Kami melayani 24/7',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(
    ThemeData theme,
    ColorScheme colorScheme,
    FAQ faq,
    int index,
  ) {
    return Obx(
      () => Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(
            splashColor: Colors.transparent,
          ),
          child: ExpansionTile(
            onExpansionChanged: (isExpanded) {
              controller.toggleFAQ(index);
            },
            title: Text(
              faq.question,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
            trailing: Obx(
              () => Icon(
                faq.isExpanded.value
                    ? Icons.expand_less
                    : Icons.expand_more,
                color: colorScheme.primary,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  faq.answer,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSupportSection(
      ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hubungi Kami',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            theme,
            colorScheme,
            Icons.email_outlined,
            'Email',
            'support@89secondstuff.com',
          ),
          const SizedBox(height: 12),
          _buildContactOption(
            theme,
            colorScheme,
            Icons.phone_outlined,
            'WhatsApp',
            '+62 812-3456-7890',
          ),
          const SizedBox(height: 12),
          _buildContactOption(
            theme,
            colorScheme,
            Icons.location_on_outlined,
            'Lokasi',
            'Malang, Jawa Timur',
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}