import 'package:get/get.dart';
import 'package:get/state_manager.dart';

import '../api/apiserver.dart';
import '../model/product.dart';

class ProductController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Product> productList = <Product>[].obs;
  RxList<String> categoryList = <String>[].obs;
  RxString selectedCategory = 'All'.obs;
  RxList favoriteProducts = <Product>[].obs;
  RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    fetchCategories();
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await ApiService.fetchProducts();
      productList.assignAll(products);
    } catch (e) {
      Get.snackbar(
          'No InterNet', 'Make sure you are connected to the Internet');
    } finally {
      isLoading(false);
    }
  }

  void fetchCategories() async {
    try {
      var categories = await ApiService.fetchCategories();
      categories.insert(0, 'All');
      categoryList.assignAll(categories);
    } catch (e) {
      // print('Error fetching categories: $e');
      Get.snackbar(
          'No InterNet', 'Make sure you are connected to the Internet');
    }
  }

  void filterProducts(String category) async {
    selectedCategory.value = category;
    if (category == 'All') {
      fetchProducts();
    } else {
      try {
        isLoading(true);
        var products = await ApiService.fetchProducts();
        productList.assignAll(products);
        productList.value =
            productList.where((p) => p.category == category).toList();
      } finally {
        isLoading(false);
      }
    }
  }

  void addFavorite(Product product) {
    favoriteProducts.add(product);
  }

  void removeFavorite(Product product) {
    favoriteProducts.remove(product);
  }
}
