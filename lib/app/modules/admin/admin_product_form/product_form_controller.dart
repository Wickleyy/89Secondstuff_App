import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/category_model.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/services/storage_service.dart';
import 'package:_89_secondstufff/app/data/services/notification_service.dart';

class AdminProductFormController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // Gunakan Get.find() jika StorageService sudah di-put di main.dart
  // Jika belum, kita put sementara di sini (lazy)
  final StorageService _storage = Get.put(StorageService());

  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  final titleC = TextEditingController();
  final priceC = TextEditingController();
  final descriptionC = TextEditingController();
  final stockC = TextEditingController();

  // State
  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var selectedCategoryId = Rx<int?>(null);

  // Image State
  var selectedImage = Rx<File?>(null); // Gambar baru dari galeri
  var existingImageUrl = ''.obs; // URL gambar lama (jika edit)

  // Data Produk (Jika Edit)
  Product? productToEdit;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();

    // Cek apakah ada argumen (Mode Edit)
    if (Get.arguments is Product) {
      productToEdit = Get.arguments as Product;
      _fillFormForEdit();
    }
  }

  void fetchCategories() async {
    try {
      final response = await _supabase.client.from('categories').select();
      final data = (response as List).map((e) => Category.fromJson(e)).toList();
      categories.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    }
  }

  void _fillFormForEdit() {
    if (productToEdit == null) return;
    titleC.text = productToEdit!.title;
    priceC.text = productToEdit!.price.toStringAsFixed(0);
    descriptionC.text = productToEdit!.description;
    stockC.text = productToEdit!.stock.toString();
    existingImageUrl.value = productToEdit!.image;

    // Kita butuh category_id. Karena Product model kita hanya menyimpan nama kategori,
    // kita mungkin perlu mencari ID-nya dari list kategori nanti,
    // atau idealnya Product model menyimpan category_id juga.
    // Untuk sekarang, kita biarkan user memilih kategori ulang atau
    // kita cari manual jika nama cocok.
  }

  // Fungsi Pilih Gambar
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // Fungsi Simpan (Create / Update)
  void saveProduct() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategoryId.value == null && productToEdit == null) {
      Get.snackbar('Error', 'Pilih kategori produk');
      return;
    }

    // Validasi Gambar: Harus ada gambar (baru atau lama)
    if (selectedImage.value == null && existingImageUrl.value.isEmpty) {
      Get.snackbar('Error', 'Pilih gambar produk');
      return;
    }

    isLoading.value = true;

    try {
      String? imageUrl = existingImageUrl.value;

      // 1. Upload Gambar Baru (Jika ada)
      if (selectedImage.value != null) {
        final uploadedUrl =
            await _storage.uploadProductImage(selectedImage.value!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          throw Exception("Gagal upload gambar");
        }
      }

      // 2. Siapkan Data
      final int stockValue = int.tryParse(stockC.text) ?? 1;
      final productData = {
        'title': titleC.text,
        'price': double.parse(priceC.text),
        'description': descriptionC.text,
        'image_url': imageUrl,
        'stock': stockValue,
        // Jika edit dan kategori tidak diubah, gunakan yang lama (tapi kita butuh ID-nya)
        // Sederhananya: Wajibkan pilih kategori saat ini
        'category_id': selectedCategoryId.value,
      };

      if (productToEdit == null) {
        // --- CREATE (INSERT) ---
        final response = await _supabase.client
            .from('products')
            .insert(productData)
            .select()
            .single();
        
        // Send notification for new product
        if (Get.isRegistered<NotificationService>()) {
          NotificationService.to.showNewProductNotification(
            productName: titleC.text,
            price: double.parse(priceC.text),
            productId: response['id'],
          );
        }
        
        // Kembali ke list dulu
        Get.back(result: true);
        
        // Tampilkan notifikasi setelah kembali
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Berhasil Ditambahkan!',
            'Produk "${titleC.text}" telah berhasil ditambahkan ke toko.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        });
      } else {
        // --- UPDATE ---
        if (selectedCategoryId.value == null) {
          productData.remove('category_id');
        }

        await _supabase.client
            .from('products')
            .update(productData)
            .eq('id', productToEdit!.id);

        // Kembali ke list dulu
        Get.back(result: true);
        
        // Tampilkan notifikasi setelah kembali
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.snackbar(
            'Berhasil Diperbarui!',
            'Produk "${titleC.text}" telah berhasil diperbarui.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            icon: const Icon(Icons.edit, color: Colors.white),
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
          );
        });
      }
    } catch (e) {
      Get.snackbar(
        'Gagal Menyimpan',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleC.dispose();
    priceC.dispose();
    descriptionC.dispose();
    stockC.dispose();
    super.onClose();
  }
}
