import 'package:cart/cart_model.dart';
import 'package:cart/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  late Future<List<Cart>> cartData;

  @override
  Future<void> initState() async {
    super.initState();
    cartData = (await Provider.of<CartProvider>(context, listen: false).getData()) as Future<List<Cart>>;
  }

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
          const SizedBox(width: 20),
        ],
      ),

      body: Column(
        children: [
          FutureBuilder<List<Cart>>(
            future: cartData,
            builder: (context, snapshot) {

              /// 🔄 Loading State
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              /// ❌ Error State
              if (snapshot.hasError) {
                return const Expanded(
                  child: Center(child: Text('Something went wrong')),
                );
              }

              /// 📭 Empty State
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Expanded(
                  child: Center(
                    child: Text(
                      'No Products in Cart',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              /// ✅ Data Loaded
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];

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
                              image: NetworkImage(item.image.toString()),
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
                                    item.productName.toString(),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    '${item.unitTag}  \$${item.productPrice}',
                                    style: const TextStyle(fontSize: 18),
                                  ),

                                  const SizedBox(height: 10),

                                  /// 🔹 Add to Cart Button (UNCHANGED)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        // intentionally left empty (as you requested)
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
            },
          ),
        ],
      ),
    );
  }
}