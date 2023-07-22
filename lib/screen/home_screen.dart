import 'package:flutter/material.dart';
import 'package:hive_test/dao/cart_dao.dart';
import 'package:hive_test/database/database.dart';
import 'package:hive_test/model/product.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late AppDatabase _database;
  late CartDAO _cartDAO;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _database =
        await $FloorAppDatabase.databaseBuilder('edmt_cart_system.db').build();
    _cartDAO = _database.cartDAO;
  }

  // Future<List<Product>> _getCartItems() async {
  //   final List<Cart> carts = _cartDAO.getAllItemInCartByUid('1') as List<Cart>;
  //   return carts
  //       .map((cart) => Product(
  //             id: cart.id,
  //             name: cart.name,
  //             category: cart.category,
  //             imageUrl: cart.imageUrl,
  //             price: cart.price.toString(),
  //           ))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: FutureBuilder<List<Product>>(
        //future: _getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products in the cart.'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                    // title: Text(product.name ?? ''),
                    // subtitle: Text(product.category ?? ''),
                    // leading: product.imageUrl != null
                    //     ? Image.network(product.imageUrl!)
                    //     : null,
                    // trailing: Text(product.price ?? ''),
                    );
              },
            );
          }
        },
      ),
    );
  }
}
