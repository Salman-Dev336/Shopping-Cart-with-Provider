// ignore_for_file: avoid_print

import 'package:badges/badges.dart' as badges;
import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:cart/cart_screen.dart';
import 'package:cart/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  DBHelper dbHelper = DBHelper();

  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Cherry',
    'Peach',
    'Mixed Fruit Basket',
  ];

  List<String> productUnit = ['KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG'];

  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];

  List<String> productImage = [
    'https://images.unsplash.com/photo-1553279768-865429fa0078',
    'https://images.unsplash.com/photo-1580910051074-3eb694886505',
    'https://images.unsplash.com/photo-1596363505729-4190a9506133',
    'https://images.unsplash.com/photo-1574226516831-e1dff420e12c',
    'https://images.unsplash.com/photo-1615485291234-0b66d3a9d2d4',
    'https://images.unsplash.com/photo-1595475207225-428b62bda831',
    'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2',
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product List',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
            child: Center(
              child: badges.Badge(
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    );
                  },
                ),
                child: const Icon(Icons.shopping_bag_outlined),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body: ListView.builder(
        itemCount: productName.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  /// 🔹 Product Image
                  Image(
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    image: NetworkImage(productImage[index]),
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.image_not_supported,
                        size: 100,
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  /// 🔹 Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productName[index],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          '${productUnit[index]}  \$${productPrice[index]}',
                          style: const TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 10),

                        /// 🔹 Add to Cart Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              dbHelper
                                  .insert(
                                    Cart(
                                      id: index,
                                      productId: index.toString(),
                                      productName: productName[index],
                                      initialPrice: productPrice[index], // ✅ FIXED
                                      productPrice: productPrice[index], // ✅ FIXED
                                      quantity: 1,
                                      unitTag: productUnit[index],
                                      image: productImage[index],
                                    ),
                                  )
                                  .then((_) {
                                    cart.addTotalPrice(
                                        productPrice[index].toDouble());
                                    cart.addCounter();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${productName[index]} added to cart',
                                        ),
                                      ),
                                    );
                                  })
                                  .catchError((error) {
                                    print("ERROR: $error");
                                  });
                            },
                            child: Container(
                              height: 35,
                              width: 110,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}