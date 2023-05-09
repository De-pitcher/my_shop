import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart' as my_wid;
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOption { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteItems = false;
  var _isInit = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then(
            (_) => setState(
              () => _isLoading = false,
            ),
          );
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOption.favorite) {
                  _showFavoriteItems = true;
                } else {
                  _showFavoriteItems = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.favorite,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => my_wid.Badge(
              value: cart.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showFavoriteItems),
    );
  }
}
