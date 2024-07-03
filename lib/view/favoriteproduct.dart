import 'package:ecommerce_app1/view/datelis_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';
import 'pruducts_view.dart';

class FavoriteScreen extends StatelessWidget {
  final ProductController productController = Get.find();

  FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Products'),
        ),
        body: Obx(() {
          if (productController.favoriteProducts.isEmpty) {
            return const Center(
              child: Text('No favorite products'),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemCount: productController.favoriteProducts.length,
              itemBuilder: (context, index) {
                var product = productController.favoriteProducts[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailsScreen(product: product));
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          product.image,
                          fit: BoxFit.fill,
                          height: 150,
                          width: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('\$${product.price}'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }),
        bottomNavigationBar: Obx(() {
          int selectedIndex = productController.selectedTab.value;
          return BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              productController.selectedTab.value = index;
              switch (index) {
                case 0:
                  Get.offAll(() => const ProductView());
                  break;
                case 1:
                  Get.offAll(() => FavoriteScreen());
                  break;
              }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
              ),
            ],
            selectedItemColor: Colors.amber[800],
          );
        }));
  }
}
