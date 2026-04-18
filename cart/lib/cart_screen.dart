import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as badges;
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY PRODUCTS',
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
              label: Consumer<CartProvider>(
                builder: (context, value, child) {
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
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: ListView.builder(
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
                                                  productName:
                                                      productName[index]
                                                          .toString(),
                                                  initialPrice:
                                                      productPrice[index]
                                                          .toString(),
                                                  productPrice:
                                                      productPrice[index]
                                                          .toString(),
                                                  quantity: 1,
                                                  unitTag: productUnit[index],
                                                  image: productImage[index],
                                                ),
                                              )
                                              .then((value) {
                                                print('Product added to cart');
                                                cart.addTotalPrice(
                                                  double.parse(
                                                    productPrice[index]
                                                        .toString(),
                                                  ),
                                                );
                                                cart.addCounter();
                                              })
                                              .catchError((error) {
                                                print(error.toString());
                                              });

                                          // setState(() {
                                          //   _counter = cart.getCounter();
                                          // });

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
              } else {
                return Text('No Products in Cart');
              }
            },
          ),
        ],
      ),
    );
  }
}
