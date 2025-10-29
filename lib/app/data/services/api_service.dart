import 'dart:async'; // Import untuk FutureOr

import 'package:dio/dio.dart';
import 'package:_89_secondstufff/app/data/models/cart_model.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/models/user_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://fakestoreapi.com',
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
    ),
  );

  Future<AuthToken> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': username, // 'mor_2314' (contoh valid)
          'password': password, // '83r5^_' (contoh valid)
        },
      );
      return AuthToken.fromJson(response.data);
    } on DioException catch (e) {
      print('Error logging in: $e');
      throw Exception('Failed to login: ${e.message}');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      return List<String>.from(response.data);
    } on DioException catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      final response = await _dio.get('/products/category/$categoryName');
      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } on DioException catch (e) {
      print('Error fetching products by category: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<Product> getProductById(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      print('Error fetching product: $e');
      throw Exception('Failed to load product');
    }
  }

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } on DioException catch (e) {
      print('Error fetching all products: $e');
      throw Exception('Failed to load products');
    }
  }

  Future<Cart> getCartByUserId(int userId) async {
    try {
      final response = await _dio.get('/carts/user/$userId');
      if (response.data.isNotEmpty) {
        return Cart.fromJson(response.data[0]);
      } else {
        throw Exception('No cart found for user');
      }
    } on DioException catch (e) {
      print('Error fetching cart: $e');
      throw Exception('Failed to load cart');
    }
  }

  Future<void> addToCart(int userId, int productId, int quantity) async {
    try {
      final response = await _dio.post(
        '/carts',
        data: {
          'userId': userId,
          'date': DateTime.now().toIso8601String(),
          'products': [
            {'productId': productId, 'quantity': quantity}
          ]
        },
      );
      print('Cart simulation response: ${response.data}');
    } on DioException catch (e) {
      print('Error adding to cart: $e');
      throw Exception('Failed to add to cart: ${e.message}');
    }
  }

  Future<Product?> fetchFirstProductInCartAsync(int userId) async {
    print("--- CHAINED REQUEST (ASYNC/AWAIT) START ---");
    try {
      final Cart cart = await getCartByUserId(userId);
      print("Async: 1. Got cart for user $userId");

      if (cart.products.isNotEmpty) {
        int firstProductId = cart.products.first.productId;
        print("Async: 2. First product ID is $firstProductId");
        final Product product = await getProductById(firstProductId);
        print("Async: 3. Got product details: ${product.title}");
        print("--- CHAINED REQUEST (ASYNC/AWAIT) END ---");
        return product;
      } else {
        print("Async: Cart is empty.");
        print("--- CHAINED REQUEST (ASYNC/AWAIT) END ---");
        return null;
      }
    } catch (e) {
      print("Async: Error in chained request: $e");
      print("--- CHAINED REQUEST (ASYNC/AWAIT) END ---");
      throw Exception('Failed chained request (async): $e');
    }
  }

  Future<Product?> fetchFirstProductInCartCallback(int userId) {
    print("--- CHAINED REQUEST (CALLBACK/THEN) START ---");
    return getCartByUserId(userId).then((cart) {
      print("Callback: 1. Got cart for user $userId");

      if (cart.products.isNotEmpty) {
        int firstProductId = cart.products.first.productId;
        print("Callback: 2. First product ID is $firstProductId");

        return getProductById(firstProductId).then((product) {
          print("Callback: 3. Got product details: ${product.title}");
          print("--- CHAINED REQUEST (CALLBACK/THEN) END ---");
          return product;
        });
      } else {
        print("Callback: Cart is empty.");
        print("--- CHAINED REQUEST (CALLBACK/THEN) END ---");
        return Future.value(null);
      }
    }).catchError((e) {
      print("Callback: Error in chained request: $e");
      print("--- CHAINED REQUEST (CALLBACK/THEN) END ---");
      throw Exception('Failed chained request (callback): $e');
    });
  }
}
