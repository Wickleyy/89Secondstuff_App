import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/category_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductProvider extends GetxService {
  SupabaseService get _supabase => Get.find();

  Future<List<Category>> getCategories() async {
    try {
      final response = await _supabase.client.from('categories').select();
      final List<Category> categories =
          (response as List).map((data) => Category.fromJson(data)).toList();
      return categories;
    } catch (e) {
      throw Exception('Gagal mengambil kategori: $e');
    }
  }

  Future<List<Product>> getProductsByCategoryName(String categoryName,
      {int? limit}) async {
    try {
      final catResponse = await _supabase.client
          .from('categories')
          .select('id')
          .eq('name', categoryName)
          .maybeSingle();

      if (catResponse == null) return [];
      final int categoryId = catResponse['id'];

      final filterBuilder = _supabase.client
          .from('products')
          .select('*, categories(id, name)')
          .eq('category_id', categoryId);

      PostgrestBuilder query;

      if (limit != null) {
        query = filterBuilder.limit(limit);
      } else {
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

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _supabase.client
          .from('products')
          .select('*, categories(id, name)')
          .eq('category_id', categoryId);

      final List<Product> products =
          (response as List).map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw Exception('Gagal mengambil produk berdasarkan kategori: $e');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _supabase.client
          .from('products')
          .select('*, categories(id, name)');

      final List<Product> products =
          (response as List).map((data) => Product.fromJson(data)).toList();
      return products;
    } catch (e) {
      throw Exception('Gagal mengambil semua produk: $e');
    }
  }
}
