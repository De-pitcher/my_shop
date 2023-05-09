import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/order_item.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem(this.order, {super.key});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 70 + 110, 270) : 95,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: _expanded
                  ? min<double>(widget.order.products.length * 70 + 10, 170)
                  : 0,
              child: ListView(
                children: widget.order.products.map(
                  (prod) {
                    return SizedBox(
                      height: prod.imageUrl != null ? 72.5 : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              prod.imageUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        prod.imageUrl!,
                                        height: 50,
                                        width: 50,
                                      ),
                                    )
                                  : Container(),
                              Text(
                                prod.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text('\$${prod.price}  x(${prod.quantity})'),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
