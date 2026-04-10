// ignore_for_file: sort_child_properties_last

import 'package:badges/badges.dart' as badges show Badge;
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          Center(
            child: badges.Badge(
              badgeContent: Text('0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                backgroundColor: Colors.amber,
              ),
              ),
              child: Icon(Icons.shopping_bag_outlined),
              badgeAnimation: BadgeAnimation.fade(
                animationDuration: Duration(seconds: 2),
              ),
            ),
          ),

          SizedBox(width: 20),
        ],
      ),
    );
  }
}
