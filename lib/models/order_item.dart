import 'package:freezed_annotation/freezed_annotation.dart';

import './cart_item.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

@freezed
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required String id,
    required double amount,
    required List<CartItem> products,
    required DateTime dateTime,
  }) = _OrderItem;

  factory OrderItem.fromJson(Map<String, Object?> json) =>
      _$OrderItemFromJson(json);
}
