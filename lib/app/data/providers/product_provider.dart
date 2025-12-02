import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/category_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductProvider extends GetxService {
  SupabaseService get _supabase => Get.find();

  // Mengambil semua kategori
  Future<List<Category>> getCategories() async {
    try {
      // Ambil data dari tabel 'categories'
      final response = await _supabase.client.from('categories').select();

      final List<Category> categories =
          (response as List).map((data) => Category.fromJson(data)).toList();
      return categories;
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  // Mengambil produk berdasarkan NAMA KATEGORI (untuk HomeController)
  Future<List<Product>> getProductsByCategoryName(String categoryName,
      {int? limit}) async {
    try {
      // 1. Cari ID kategori
      final catResponse = await _supabase.client
          .from('categories')
          .select('id')
          .eq('name', categoryName)
          // --- PERBAIKAN: Ganti .single() menjadi .maybeSingle() ---
          .maybeSingle(); // .maybeSingle() akan return null jika tidak ada
      // --- AKHIR PERBAIKAN ---

      // Pengecekan '== null' ini sekarang valid dan diperlukan
      if (catResponse == null) return [];
      final int categoryId = catResponse['id'];

      // 2. Ambil produk berdasarkan ID tsb

      // Buat query filter dasar. Tipe datanya adalah PostgrestFilterBuilder
      final filterBuilder = _supabase.client
          .from('products')
          .select('*, categories(id, name)') // JOIN tabel
          .eq('category_id', categoryId);

      // Deklarasikan query akhir sebagai tipe dasar PostgrestBuilder
      PostgrestBuilder query;

      if (limit != null) {
        // Panggil .limit() PADA filterBuilder (yang punya method-nya)
        // Hasilnya adalah PostgrestTransformBuilder, yang juga turunan PostgrestBuilder
        query = filterBuilder.limit(limit);
      } else {
        // Jika tidak ada limit, query akhir adalah filterBuilder itu sendiri
        query = filterBuilder;
      }

      final response = await query;

      final List<Product> products =
          (response as List).map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw Exception('Gagal mengambil produk ($categoryName): $e');
    }
  }

  // Mengambil produk berdasarkan ID KATEGORI (untuk CategoryProductsController)
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _supabase.client
          .from('products')
          .select('*, categories(id, name)') // JOIN tabel
          .eq('category_id', categoryId);

      final List<Product> products =
          (response as List).map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw Exception('Gagal mengambil produk berdasarkan kategori: $e');
    }
  }

  // Mengambil semua produk (untuk Search)
  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase.client
          .from('products')
          .select('*, categories(id, name)'); // JOIN tabel

      final List<Product> products =
          (response as List).map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw Exception('Gagal mengambil semua produk: $e');
    }
  }
}
