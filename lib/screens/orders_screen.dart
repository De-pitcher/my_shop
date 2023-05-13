import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/app_drawer.dart';
import '../widgets/loading_widget.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/order-screen';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshotData) {
          if (snapshotData.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshotData.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          return Consumer<Orders>(
            builder: (ctx, orderData, _) => orderData.orders.isEmpty
                ? const Center(
                    child: Text('No Orders yet!'),
                  )
                : ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (_, i) => OrderItem(orderData.orders[i]),
                  ),
          );
        },
      ),
    );
  }
}
