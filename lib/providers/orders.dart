import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';
import '../models/http_exception.dart';
import '../models/order_item.dart';
import '../utils/constants.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final url = Uri.parse(baseUrl + ordersPath + endPoint);

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchOrders() async {
    final response = await http.get(url);
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
              .map((items) => CartItem.fromMap(items))
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
      final response = await http.post(url,
          body: jsonEncode({
            'amount': total,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartProducts.map((cp) => cp.toMap()).toList()
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
