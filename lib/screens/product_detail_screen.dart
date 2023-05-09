import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatefulWidget
    implements PreferredSizeWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with WidgetsBindingObserver {
  bool _isAppBarExpanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0 && !_isAppBarExpanded) {
        setState(() {
          _isAppBarExpanded = true;
        });
      } else if (_scrollController.offset <= 0 && _isAppBarExpanded) {
        setState(() {
          _isAppBarExpanded = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            foregroundColor: !_isAppBarExpanded
                ? Theme.of(context).colorScheme.primary
                : null,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 10),
                Text(
                  '\$${loadedProduct.price}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height -
                      widget.preferredSize.height -
                      (widget.preferredSize.shortestSide * 1.75),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
