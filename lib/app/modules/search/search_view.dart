import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/modules/search/search_controller.dart';
import 'package:google_fonts/google_fonts.dart';

// Ganti dari StatelessWidget ke GetView
class SearchView extends GetView<SearchController> {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        // Search Bar di AppBar
        title: TextField(
          controller: controller.searchC,
          autofocus: true, // Langsung fokus saat halaman dibuka
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.6)),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: colorScheme.onSurface),
              onPressed: controller.clearSearch,
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface, fontSize: 18),
          // Panggil performSearch saat user menekan 'submit'
          onSubmitted: controller.performSearch,
        ),
        backgroundColor: colorScheme.surface,
      ),
      body: Obx(() {
        // Tampilkan loading jika sedang fetch semua produk
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Tampilkan hasil pencarian
        if (controller.searchResults.isNotEmpty) {
          return _buildSearchResults(theme);
        }

        // Tampilkan pesan jika sudah mencari tapi tidak ada hasil
        if (controller.hasSearched.value) {
          return _buildEmptyState(
            theme,
            Icons.search_off,
            'Produk Tidak Ditemukan',
            'Coba gunakan kata kunci lain untuk pencarian Anda.',
          );
        }

        // Tampilan awal sebelum mencari
        return _buildEmptyState(
          theme,
          Icons.search,
          'Mulai Mencari',
          'Ketik nama produk yang ingin Anda temukan.',
        );
      }),
    );
  }

  // Widget untuk menampilkan hasil pencarian
  Widget _buildSearchResults(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.searchResults.length,
      itemBuilder: (context, index) {
        final product = controller.searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: Image.network(
              product.image,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            title: Text(
              product.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => controller.goToProductDetail(product),
          ),
        );
      },
    );
  }

  // Widget untuk tampilan kosong (awal / tidak ada hasil)
  Widget _buildEmptyState(
      ThemeData theme, IconData icon, String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
