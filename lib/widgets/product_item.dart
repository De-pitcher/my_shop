import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import '../utils/app_color.dart';
import '../utils/utils.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem(
      // this.id,
      // this.title,
      // this.imageUrl,
      {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    // print('ProductItem rebuild build()');
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
              product.isFavorite! ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () async {
              final oldVal = product.isFavorite;
              try {
                await product.toggleIsFavorite(authData.token, authData.userId);
              } on SocketException {
                product.undoFav(oldVal!);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(text: 'Network Issue! bawo'),
                );
              } catch (_) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  customSnackBar(text: 'An Error occurred!'),
                );
              }
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
          backgroundColor: AppColor.kDarkBrownColor,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFE1E6E1),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id!, product.title, product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                customSnackBar(
                    text: 'Added item to cart!',
                    showAction: true,
                    actionHandler: () {
                      cart.removeSingleItem(product.id!);
                    }),
              );
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id!,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/006 product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
              // child: Image.network(
              //   product.imageUrl,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
