import 'package:flutter/material.dart';
import 'package:my_shop/utils/utils.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../utils/app_color.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final String? image;
  final double price;
  final int quantity;

  const CartItem({
    super.key,
    required this.id,
    required this.productId,
    required this.title,
    this.image,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).colorScheme.secondary,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return customDialog(
          isConfirmedNeeded: true,
          title: 'Are you sure?',
          msg: 'Do you want to remove the item from the card?',
          context: context,
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: AppColor.kDarkBrownColor,
              child: image != null
                  ? ClipOval(
                      child: Image.network(image!),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FittedBox(
                        child: Text('\$$price'),
                      ),
                    ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
