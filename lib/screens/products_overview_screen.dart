import 'package:flutter/material.dart';

import '../providers/product.dart';
import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {
  const ProductOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const ProductsGrid(),
    );
  }
}
