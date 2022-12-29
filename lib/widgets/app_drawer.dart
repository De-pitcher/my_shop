import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: const Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
