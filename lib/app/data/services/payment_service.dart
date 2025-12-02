import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:uuid/uuid.dart';
import 'package:_89_secondstufff/app/data/models/cart_item.dart';
import 'package:_89_secondstufff/app/modules/account/shipping_address/models/shipping_address_model.dart';

class PaymentService extends GetxService {
  MidtransSDK? _midtrans;
  
  String get _serverKey => dotenv.env['MIDTRANS_SERVER_KEY'] ?? '';
  String get _clientKey => dotenv.env['MIDTRANS_CLIENT_KEY'] ?? '';
  bool get _isProduction => dotenv.env['MIDTRANS_IS_PRODUCTION'] == 'true';
  
  String get _baseUrl => _isProduction 
      ? 'https://app.midtrans.com/snap/v1'
      : 'https://app.sandbox.midtrans.com/snap/v1';

  Future<PaymentService> init() async {
    try {
      _midtrans = await MidtransSDK.init(
        config: MidtransConfig(
          clientKey: _clientKey,
          merchantBaseUrl: "",
          colorTheme: ColorTheme(
            colorPrimary: const Color(0xFF6C63FF),
            colorPrimaryDark: const Color(0xFF5A52D5),
            colorSecondary: const Color(0xFF6C63FF),
          ),
        ),
      );
    } catch (e) {
      debugPrint('Midtrans SDK init failed (expected on desktop): $e');
    }
    return this;
  }

  String generateOrderId() {
    final uuid = const Uuid().v4().substring(0, 8).toUpperCase();
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
    return 'ORD-$timestamp$uuid';
  }

  Future<Map<String, dynamic>?> createSnapToken({
    required String orderId,
    required double grossAmount,
    required List<CartItem> items,
    required ShippingAddress address,
    required String customerEmail,
    double shippingCost = 0,
  }) async {
    try {
      final itemDetails = items.map((item) => {
        'id': item.id.toString(),
        'price': item.price.toInt(),
        'quantity': item.quantity,
        'name': item.title.length > 50 ? '${item.title.substring(0, 47)}...' : item.title,
      }).toList();

      if (shippingCost > 0) {
        itemDetails.add({
          'id': 'SHIPPING',
          'price': shippingCost.toInt(),
          'quantity': 1,
          'name': 'Biaya Pengiriman',
        });
      }

      final body = {
        'transaction_details': {
          'order_id': orderId,
          'gross_amount': grossAmount.toInt(),
        },
        'item_details': itemDetails,
        'customer_details': {
          'first_name': address.name,
          'email': customerEmail,
          'phone': address.phone,
          'shipping_address': {
            'first_name': address.name,
            'phone': address.phone,
            'address': address.address,
            'city': address.city,
            'postal_code': address.postalCode,
            'country_code': 'IDN',
          },
        },
        'callbacks': {
          'finish': 'https://89secondstuff.com/payment/finish',
        },
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_serverKey:'))}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'token': data['token'],
          'redirect_url': data['redirect_url'],
        };
      } else {
        debugPrint('Midtrans Error: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Payment Error: $e');
      return null;
    }
  }

  Future<void> startPayment({
    required String snapToken,
    String? redirectUrl,
    required Function(dynamic) onSuccess,
    required Function(dynamic) onPending,
    required Function(dynamic) onError,
    required Function() onClosed,
  }) async {
    // Jika Midtrans SDK tidak tersedia (desktop), langsung set pending
    if (_midtrans == null) {
      debugPrint('Midtrans SDK not available, treating as pending payment');
      // Untuk desktop, kita anggap pembayaran pending dan user bisa bayar via link
      onPending({'transaction_status': 'pending', 'redirect_url': redirectUrl});
      return;
    }

    _midtrans!.setTransactionFinishedCallback((result) {
      try {
        final Map<String, dynamic>? data = result as Map<String, dynamic>?;
        final status = data?['transaction_status'];
        if (status == null) {
          onClosed();
        } else if (status == 'settlement' || status == 'capture') {
          onSuccess(result);
        } else if (status == 'pending') {
          onPending(result);
        } else if (status == 'cancel' || status == 'deny' || status == 'expire') {
          onError(result);
        } else {
          onClosed();
        }
      } catch (e) {
        debugPrint('Callback error: $e');
        onClosed();
      }
    });

    try {
      await _midtrans!.startPaymentUiFlow(token: snapToken);
    } catch (e) {
      debugPrint('Start Payment Error: $e');
      onError({'error': e.toString()});
    }
  }

  Future<Map<String, dynamic>?> checkTransactionStatus(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.${_isProduction ? '' : 'sandbox.'}midtrans.com/v2/$orderId/status'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Basic ${base64Encode(utf8.encode('$_serverKey:'))}',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Check Status Error: $e');
      return null;
    }
  }

  @override
  void onClose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.onClose();
  }
}
