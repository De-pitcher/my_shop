import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/http_exception.dart';
import '../models/order_item.dart';
import './auth.dart';
import '../utils/constants.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  String? authToken;
  String? userId;

  /// Used with [ChangeNotifierProxyProvider] to access the token
  /// in the [Auth] provider.
  void update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    final response = await http
        .get(Uri.parse('$baseUrl/orders/$userId.json?auth=$authToken'));
    final List<OrderItem> loadedOrders = [];
    if (jsonDecode(response.body) == null) {
      return;
    }
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    extractedData.forEach((ordId, ordProd) {
      loadedOrders.add(
        OrderItem(
          id: ordId,
          amount: ordProd['amount'],
          products: (ordProd['products'] as List<dynamic>)
              .map((items) => CartItem.fromJson(items))
              .toList(),
          dateTime: DateTime.parse(ordProd['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/orders/$userId.json?auth=$authToken'),
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts.map((cp) => cp.toJson()).toList()
          }));

      _orders.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (_) {
      throw HttpException('An error occurred!');
    }
  }
}
