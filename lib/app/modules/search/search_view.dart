import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_89_secondstufff/app/modules/search/search_controller.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';

class SearchView extends GetView<SearchController> {
  const SearchView({super.key});

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
              _buildSearchBar(isDark, colorScheme),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator(color: isDark ? AppTheme.accentMustard : colorScheme.primary));
                  }
                  if (controller.searchResults.isNotEmpty) {
                    return _buildSearchResults(isDark, colorScheme);
                  }
                  if (controller.hasSearched.value) {
                    return _buildEmptyState(Icons.search_off, 'Produk Tidak Ditemukan', 'Coba gunakan kata kunci lain', isDark, colorScheme);
                  }
                  if (controller.searchHistory.isNotEmpty) {
                    return _buildSearchHistory(isDark, colorScheme);
                  }
                  return _buildEmptyState(Icons.search, 'Mulai Mencari', 'Ketik nama produk yang ingin Anda temukan', isDark, colorScheme);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.4), AppTheme.deepPurpleDark.withValues(alpha: 0.6)]) : null,
          color: isDark ? null : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.3) : colorScheme.outline.withValues(alpha: 0.1)),
          boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.2), blurRadius: 12)] : null,
        ),
        child: TextField(
          controller: controller.searchC,
          autofocus: true,
          style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            hintStyle: GoogleFonts.poppins(color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: isDark ? [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)] : [colorScheme.primary.withValues(alpha: 0.12), colorScheme.primary.withValues(alpha: 0.05)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.search, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
            ),
            suffixIcon: IconButton(icon: Icon(Icons.clear, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.4)), onPressed: controller.clearSearch),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onSubmitted: controller.performSearch,
        ),
      ),
    );
  }

  Widget _buildSearchHistory(bool isDark, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('RIWAYAT PENCARIAN', style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.7) : colorScheme.onSurface.withValues(alpha: 0.5))),
              TextButton(onPressed: controller.clearSearchHistory, child: Text('HAPUS', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.accentRed))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.searchHistory.length,
            itemBuilder: (context, index) {
              final term = controller.searchHistory[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
                  color: isDark ? null : colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
                ),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(gradient: LinearGradient(colors: isDark ? [AppTheme.glowPurple.withValues(alpha: 0.3), AppTheme.deepPurpleLight.withValues(alpha: 0.2)] : [colorScheme.primary.withValues(alpha: 0.1), colorScheme.primary.withValues(alpha: 0.05)]), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.history, color: isDark ? AppTheme.accentMustard : colorScheme.primary, size: 20),
                  ),
                  title: Text(term, style: GoogleFonts.poppins(color: isDark ? Colors.white : colorScheme.onSurface)),
                  trailing: Icon(Icons.north_west, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.3), size: 18),
                  onTap: () => controller.onHistoryTap(term),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(bool isDark, ColorScheme colorScheme) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final product = controller.searchResults[index];
        return GestureDetector(
          onTap: () => controller.goToProductDetail(product),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isDark ? LinearGradient(colors: [AppTheme.deepPurpleLight.withValues(alpha: 0.3), AppTheme.deepPurpleDark.withValues(alpha: 0.5)]) : null,
              color: isDark ? null : colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: isDark ? AppTheme.glowPurple.withValues(alpha: 0.2) : colorScheme.outline.withValues(alpha: 0.1)),
              boxShadow: isDark ? [BoxShadow(color: AppTheme.glowPurple.withValues(alpha: 0.1), blurRadius: 8)] : [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 6)]),
                  child: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, color: Colors.grey[400]))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : colorScheme.onSurface), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: isDark ? LinearGradient(colors: [AppTheme.accentMustard.withValues(alpha: 0.2), AppTheme.accentRed.withValues(alpha: 0.1)]) : null,
                          color: isDark ? null : colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(currencyFormat.format(product.price), style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? AppTheme.accentMustard : colorScheme.primary)),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: isDark ? Colors.white30 : colorScheme.onSurface.withValues(alpha: 0.3)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String message, bool isDark, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(gradient: isDark ? LinearGradient(colors: [AppTheme.glowPurple.withValues(alpha: 0.2), AppTheme.deepPurpleLight.withValues(alpha: 0.1)]) : null, color: isDark ? null : colorScheme.primary.withValues(alpha: 0.08), shape: BoxShape.circle),
            child: Icon(icon, size: 56, color: isDark ? AppTheme.accentMustard.withValues(alpha: 0.5) : colorScheme.primary.withValues(alpha: 0.4)),
          ),
          const SizedBox(height: 24),
          Text(title, style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : colorScheme.onSurface.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text(message, style: GoogleFonts.poppins(fontSize: 14, color: isDark ? Colors.white38 : colorScheme.onSurface.withValues(alpha: 0.5)), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
