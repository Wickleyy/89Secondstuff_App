class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final int stock;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.stock = 0,
  });

  bool get isOutOfStock => stock <= 0;
  bool get isLowStock => stock > 0 && stock <= 5;
  bool get isInStock => stock > 5;
  
  String get stockStatus {
    if (isOutOfStock) return 'Habis';
    if (isLowStock) return 'Stok Menipis';
    return 'Tersedia';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    bool isSupabase = json.containsKey('image_url');

    if (isSupabase) {
      final categoryData = json['categories'];
      String categoryName = 'Uncategorized';
      if (categoryData != null && categoryData is Map) {
        categoryName = categoryData['name']?.toString() ?? 'Uncategorized';
      }

      return Product(
        id: _parseInt(json['id']),
        title: json['title']?.toString() ?? 'Produk',
        price: _parseDouble(json['price']),
        description: json['description']?.toString() ?? '',
        category: categoryName,
        image: json['image_url']?.toString() ?? '',
        stock: _parseInt(json['stock']),
      );
    } else {
      return Product(
        id: _parseInt(json['id']),
        title: json['title']?.toString() ?? 'Produk',
        price: _parseDouble(json['price']),
        description: json['description']?.toString() ?? '',
        category: json['category']?.toString() ?? 'Uncategorized',
        image: json['image']?.toString() ?? '',
        stock: _parseInt(json['stock']),
      );
    }
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'stock': stock,
    };
  }
}
