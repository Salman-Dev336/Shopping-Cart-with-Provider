// ignore_for_file: avoid_print, unused_local_variable, sort_child_properties_last

import 'package:badges/badges.dart' as badges;
import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
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
  // int cartCount = 0;
  int _counter = 0;

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
    'https://images.unsplash.com/photo-1553279768-865429fa0078', // Mango
    'https://images.unsplash.com/photo-1580910051074-3eb694886505', // Orange
    'https://images.unsplash.com/photo-1596363505729-4190a9506133', // Grapes
    'https://images.unsplash.com/photo-1574226516831-e1dff420e12c', // Banana
    'https://images.unsplash.com/photo-1615485291234-0b66d3a9d2d4', // Cherry
    'https://images.unsplash.com/photo-1595475207225-428b62bda831', // Peach
    'https://images.unsplash.com/photo-1601004890684-d8cbf643f5f2', // Mixed
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
          Center(
            child: badges.Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child){
                  return Text(
                    value.getCounter().toString(),
                  // cartCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                );
                },
              ),
              child: const Icon(Icons.shopping_bag_outlined),
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
                      return const Icon(Icons.image_not_supported, size: 100);
                    },
                  ),

                  const SizedBox(width: 10),

                  /// 🔹 Product Details
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
                                      productName: productName[index]
                                          .toString(),
                                      initialPrice:
                                          productPrice[index].toString(), 
                                      productPrice:
                                          productPrice[index].toString(), 
                                      quantity: 1,
                                      unitTag: productUnit[index],
                                      image: productImage[index],
                                    ),
                                  )
                                  .then((value) {
                                    print('Product added to cart');
                                    cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                    cart.addCounter();
                                  })
                                  .catchError((error) {
                                    print(error.toString());
                                  });

                              setState(() {
                                _counter = cart.getCounter();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${productName[index]} added to cart',
                                  ),
                                ),
                              );
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
