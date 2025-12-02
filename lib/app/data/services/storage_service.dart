import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

class StorageService extends GetxService {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // Nama bucket di Supabase Storage
  static const String _bucketName = 'product-images';

  // Fungsi untuk upload gambar
  // Mengembalikan URL publik gambar yang berhasil diupload
  Future<String?> uploadProductImage(File imageFile) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'products/$fileName';

      // Upload file
      await _supabase.client.storage.from(_bucketName).upload(path, imageFile);

      // Dapatkan URL publik
      final imageUrl =
          _supabase.client.storage.from(_bucketName).getPublicUrl(path);

      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}
