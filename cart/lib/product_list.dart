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

   List<String> productName = ['Mango' , 'Orange' , 'Grapes' , 'Banana' , 'Chery' , 'Peach','Mixed Fruit Basket',] ;
  List<String> productUnit = ['KG' , 'Dozen' , 'KG' , 'Dozen' , 'KG' , 'KG','KG',] ;
  List<int> productPrice = [10, 20 , 30 , 40 , 50, 60 , 70 ] ;
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg' ,
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg' ,
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg' ,
    'https://image.shutterstock.com/image-photo/banana-isolated-on-white-background-600w-610892247.jpg' ,
    'https://image.shutterstock.com/image-photo/cherry-isolated-on-white-background-600w-610892248.jpg' ,
    'https://image.shutterstock.com/image-photo/peach-isolated-on-white-background-600w-610892250.jpg' ,
    'https://image.shutterstock.com/image-photo/mixed-fruit-basket-isolated-on-600w-610892251.jpg' ,
  ] ;
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
              badgeContent: Text(
                '0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  // backgroundColor: Colors.amber,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productName.length,
              itemBuilder: (context, index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,,
                      children: [
                        Row(
                          children: [
                            Image(
                              height: 100,
                              width: 100,
                              image: NetworkImage(productImage[index].toString()),
                              ),
                            Text(index.toString()),
                            Spacer(),
                          ],
                        )
                      ],
                    ),
                  ),

                );
              } ),),
        ],
      ),
    );
  }
}
