import 'package:flutter/material.dart';
import '../Product/product_model.dart';

class ProductsInCart extends ChangeNotifier {
  late Map<ProductModel, int> productsInCart = <ProductModel, int>{};

  ProductsInCart() {
    productsInCart = <ProductModel, int>{};
    notifyListeners();
  }

  void addToCart(ProductModel p, int q) {
    productsInCart.addEntries({p: q}.entries);
    notifyListeners();
  }

  void updateToCart(ProductModel p, int q) {
    productsInCart.update(p, (value) => q);
    notifyListeners();
  }

  void deleteToCart(ProductModel p) {
    productsInCart.remove(p);
    notifyListeners();
  }

  void deleteCart() {
    productsInCart.clear();
    notifyListeners();
  }

  int getNumberOfProducts() {
    return productsInCart.length;
  }

  bool isEmpty() {
    return productsInCart.isEmpty ? true : false;
  }

  bool isNotEmpty() {
    return productsInCart.isNotEmpty ? true : false;
  }

  int getTotalQuantityOfProducts() {
    int quantity = 0;
    for (var value in productsInCart.values) {
      quantity += value;
    }
    return quantity;
  }

  double getTotalPrice() {
    double price = 0;
    productsInCart.isNotEmpty
        ? productsInCart.forEach((key, value) {
            price += key.price! * value;
          })
        : price = 0;
    return price;
  }

  Map<ProductModel, int>? getAllProductsInCart() {
    return productsInCart;
  }

  bool isContainInCart(ProductModel p) {
    return productsInCart.containsKey(p) ? true : false;
  }

  int? getQuantityOfProducts(ProductModel p) {
    return productsInCart.containsKey(p)
        ? productsInCart[p]
        : 0;
  }

  ProductModel getProductAt(int i) {
    return productsInCart.keys.elementAt(i);
  }

  // String getSubCategoryAndCategory(ProductModel p) {
  //   return categories.where((element) => p.categoryId==element.categoryId).first.categoryName.toString()+'/'+subCategories.where((element) => p.subCategoryId==element.subCategoryId).first.subCategoryName.toString();
  // }
}
