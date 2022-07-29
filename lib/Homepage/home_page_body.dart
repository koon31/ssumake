import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ssumake/Model/Product/category_model.dart';
import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/sub_category_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';
import 'home_page_sub_category_tabs.dart';
import 'home_page_item_card.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody(
      {Key? key,
      this.category,
      this.subCategoriesByCategoryId,
      this.selectedSubCategory})
      : super(key: key);
  final CategoryModel? category;
  final List<SubCategoryModel>? subCategoriesByCategoryId;
  final SubCategoryModel? selectedSubCategory;


  @override
  State<HomePageBody> createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  GlobalKey<HomePageSubCategoryTabsState> keyTab = GlobalKey();
  late CategoryModel cate;
  late List<SubCategoryModel> scatesByCateId;
  late SubCategoryModel selectedSCate;
  late List<ProductModel> productsInSelectedSubCategory;
  late Map<SubCategoryModel, List<ProductModel>> productsInEachSubCategories;
  late int numberOfProducts;
  late int totalQuantityOfProducts;
  late double totalPrice;

  late final PageController _productPageController;

  @override
  void initState() {

    cate = getCategory();
    scatesByCateId = getSubCategoriesByCategoryId();
    selectedSCate = getSelectedSubCategory();
    productsInSelectedSubCategory = getProductsInSubCategory(selectedSCate);
    productsInEachSubCategories = getAllProductsByEachSubCategories();
    _productPageController = PageController(
        initialPage:
            scatesByCateId.indexOf(selectedSCate) % scatesByCateId.length);
    updateProductsInCarts();
    Future.delayed(Duration.zero, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


 productsInEachSubCategories.forEach((key, value) {
       print(productsInEachSubCategories[key]);
  });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Text(
            cate.categoryName!,
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        HomePageSubCategoryTabs(
          key: keyTab,
          subCategoriesByCategoryId: scatesByCateId,
          selectedCategory: selectedSCate,
          onTabChanged: (int i) {
            tabChange(i);
          },
        ),
        Expanded(
          child: PageView.builder(
            controller: _productPageController,
            itemCount: scatesByCateId.length,
            onPageChanged: (pageIndex) {
              setState(() {
                keyTab.currentState?.onTabChange(pageIndex);
                selectedSCate = scatesByCateId[pageIndex];
              });
            },
            itemBuilder: (context, subCateIndex) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: GridView.builder(
                itemCount: productsInEachSubCategories[scatesByCateId[subCateIndex % scatesByCateId.length]]!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: kDefaultPadding,
                  crossAxisSpacing: kDefaultPadding,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, proIndex) => ItemCard(
                    product: productsInEachSubCategories[scatesByCateId[
                        subCateIndex % scatesByCateId.length]]![proIndex],
                    press: () {
                      ShowModalBottomSheet.showEditProduct(
                        context,
                        productsInEachSubCategories[scatesByCateId[
                            subCateIndex % scatesByCateId.length]]![proIndex],
                        cate.categoryName! +
                            // ignore: unnecessary_null_comparison
                            (selectedSCate != null
                                ? '/' + selectedSCate.subCategoryName!
                                : ''),true
                      );
                    } /*async => await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailProductPage(
                                product: productsInEachSubCategories[
                                    scatesByCateId[subCateIndex %
                                        scatesByCateId.length]]![proIndex],
                                cate_SubCate_Title: cate.title! +
                                    // ignore: unnecessary_null_comparison
                                    (selectedSCate != null
                                        ? '/' + selectedSCate.title!
                                        : ''),
                                quantityOfProductsInCart: _productsInCart[productsInEachSubCategories[scatesByCateId[
                                subCateIndex % scatesByCateId.length]]![proIndex]]==null?0:_productsInCart[productsInEachSubCategories[scatesByCateId[
                                subCateIndex % scatesByCateId.length]]![proIndex]]!,
                              ),
                            ),
                          ),*/
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CategoryModel getCategory() {
    return widget.category != null ? widget.category! : Provider.of<CategoryList>(context, listen: false).categories.first;
  }

  List<SubCategoryModel> getSubCategoriesByCategoryId() {
    return widget.subCategoriesByCategoryId != null
        ? widget.subCategoriesByCategoryId!
        : Provider.of<SubCategoryList>(context, listen: false).subCategories
            .where((element) => element.categoryId == cate.categoryId)
            .toList();
  }

  SubCategoryModel getSelectedSubCategory() {
    return widget.selectedSubCategory != null
        ? widget.selectedSubCategory!
        : scatesByCateId.first;
  }

  List<ProductModel> getProductsInSubCategory(SubCategoryModel scate) {
    List<ProductModel> list = Provider.of<ProductList>(context, listen: false).products;

    return list
        .where((element) => (element.subCategoryId == scate.subCategoryId))
        .toList();
  }

  Map<SubCategoryModel, List<ProductModel>> getAllProductsByEachSubCategories() {
    Map<SubCategoryModel, List<ProductModel>> psInEachSCates = {};
    for (int i = 0; i < scatesByCateId.length; ++i) {
      psInEachSCates[scatesByCateId[i]] =getProductsInSubCategory(scatesByCateId[i]);
    }
    return psInEachSCates;
  }

  tabChange(int index) {
    selectedSCate = scatesByCateId[index];
    _productPageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  void updateProductsInCarts() {
    var provider = Provider.of<ProductsInCart>(context, listen: false);
    numberOfProducts = provider.getNumberOfProducts();
    totalQuantityOfProducts = provider.getTotalQuantityOfProducts();
    totalPrice = provider.getTotalPrice();
  }

// showSnackBar(){
//   if(numberOfProducts>0) {
//     isSnackBarShown = true;
//     ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
//       'Hello', totalPrice.toString(), totalQuantityOfProducts.toString(), () {
//     showModalBottomSheetCart(context);
//   }, MediaQuery.of(context).size));
//   }
//   else {
//     if(isSnackBarShown) {
//       isSnackBarShown = false;
//       ScaffoldMessenger.of(context).removeCurrentSnackBar();
//     }
//
//   }
// }
}
