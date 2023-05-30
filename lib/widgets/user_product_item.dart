import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../utils/utils.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem(
    this.id,
    this.title,
    this.imageUrl, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: imageUrl.startsWith('http://') || imageUrl.startsWith('https://')
            ? Image.network(
                imageUrl,
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              )
            : Image.memory(
                base64Decode(imageUrl),
                errorBuilder: (_, __, ___) => const Icon(Icons.error),
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () async {
                await customDialog(
                    context: context,
                    isConfirmedNeeded: true,
                    title: 'Are you sure?',
                    msg: 'Do you want to remove this product?',
                    isConfirmedHandler: () async {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(id);
                      } catch (error) {
                        scaffold.hideCurrentSnackBar();
                        scaffold.showSnackBar(
                            customSnackBar(text: 'Deleting failed!'));
                      }
                    });
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
