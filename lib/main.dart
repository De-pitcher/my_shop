import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_product_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';
import './utils/app_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(),
            update: (ctx, auth, products) => products!..update(auth)
            // Products(auth.token!, previouseProducts == null ? [] : previouseProducts.items),
            ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, orders) => orders!..update(auth),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Lato',
            scaffoldBackgroundColor: AppColor.bg,
            canvasColor: AppColor.bg,
            primaryColor: AppColor.primaryColor,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: AppColor.primaryColor,
              primary: AppColor.accentColor,
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? const ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductScreen.routeName: (_) => const UserProductScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
