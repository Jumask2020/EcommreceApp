import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/product_controller.dart';
import 'datelis_product.dart';
import 'favoriteproduct.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('E-Commerce App'),
        ),
        body: Column(
          children: [
            Obx(() {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productController.categoryList.length,
                  itemBuilder: (context, index) {
                    var category = productController.categoryList[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          productController.filterProducts(category);
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: productController.selectedCategory.value ==
                                  category
                              ? Colors.orange
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          category,
                          style: TextStyle(
                            color: productController.selectedCategory.value ==
                                    category
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
            Expanded(
              child: Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return LayoutBuilder(builder: (context, constraints) {
                    int crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: productController.productList.length,
                      itemBuilder: (context, index) {
                        var product = productController.productList[index];
                        return InkWell(
                          onTap: () {
                            Get.to(
                              () => ProductDetailsScreen(
                                product: productController.productList[index],
                              ),
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  product.image,
                                  fit: BoxFit.cover,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text('\$${product.price}'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  });
                }
              }),
            ),
          ],
        ),
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
