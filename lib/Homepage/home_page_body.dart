import 'dart:async';
import 'package:collection/collection.dart';
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
  const HomePageBody({Key? key, this.category, this.subCategoriesByCategoryId, this.selectedSubCategory})
      : super(key: key);
  final CategoryModel? category;
  final List<SubCategoryModel>? subCategoriesByCategoryId;
  final SubCategoryModel? selectedSubCategory;

  @override
  State<HomePageBody> createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  GlobalKey<HomePageSubCategoryTabsState> keyTab = GlobalKey();
  late CategoryModel? cate;
  late List<SubCategoryModel>? scatesByCateId;
  late SubCategoryModel? selectedSCate;
  late List<ProductModel>? productsInSelectedSubCategory;
  late Map<SubCategoryModel, List<ProductModel>>? productsInEachSubCategories;
  late int numberOfProducts;
  late int totalQuantityOfProducts;
  late double totalPrice;

  late final PageController? _productPageController;

  @override
  void initState() {
    cate = getCategory();
    print(cate?.categoryName);
    scatesByCateId = getSubCategoriesByCategoryId();
    selectedSCate = getSelectedSubCategory();
    productsInSelectedSubCategory = selectedSCate != null ? getProductsInSubCategory(selectedSCate!) : null;
    productsInEachSubCategories = getAllProductsByEachSubCategories();
    _productPageController = PageController(
        initialPage: scatesByCateId != null && selectedSCate != null
            ? scatesByCateId!.indexOf(selectedSCate!) % scatesByCateId!.length
            : 1);
    updateProductsInCarts();
    Future.delayed(Duration.zero, () {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (scatesByCateId == null ||
            selectedSCate == null ||
            productsInEachSubCategories == null ||
            scatesByCateId == null ||
            cate == null ||
            productsInSelectedSubCategory == null)
        ? Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Text(
                  "Không thể tải dữ liệu",
                  style:
                      Theme.of(context).textTheme.headline2?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Text(
                  cate != null ? cate!.categoryName! : '',
                  style: Theme.of(context).textTheme.headline4?.copyWith(fontWeight: FontWeight.bold),
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
                  physics: const BouncingScrollPhysics(),
                  controller: _productPageController,
                  itemCount: scatesByCateId != null ? scatesByCateId!.length : 0,
                  onPageChanged: (pageIndex) {
                    setState(() {
                      keyTab.currentState?.onTabChange(pageIndex);
                      if (selectedSCate != null && scatesByCateId != null) {
                        selectedSCate = scatesByCateId![pageIndex];
                      }
                    });
                  },
                  itemBuilder: (context, subCateIndex) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: (scatesByCateId != null && productsInEachSubCategories != null)
                          ? productsInEachSubCategories![scatesByCateId![subCateIndex % scatesByCateId!.length]]!.length
                          : 0,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: kDefaultPadding,
                        crossAxisSpacing: kDefaultPadding,
                        childAspectRatio: 4 / 7,
                      ),
                      itemBuilder: (context, proIndex) => ItemCard(
                        product: (scatesByCateId != null && productsInEachSubCategories != null)
                            ? productsInEachSubCategories![scatesByCateId![subCateIndex % scatesByCateId!.length]]![
                                proIndex]
                            : null,
                        press: () {
                          if (cate != null && scatesByCateId != null && productsInEachSubCategories != null) {
                            ShowModalBottomSheet.showEditProduct(
                              context,
                              productsInEachSubCategories![scatesByCateId![subCateIndex % scatesByCateId!.length]]![
                                  proIndex],
                              true,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  CategoryModel? getCategory() {
    return widget.category != null
        ? widget.category!
        : Provider.of<CategoryList>(context, listen: false).categories.firstOrNull;
  }

  List<SubCategoryModel>? getSubCategoriesByCategoryId() {
    return widget.subCategoriesByCategoryId != null
        ? widget.subCategoriesByCategoryId!
        : cate != null
            ? Provider.of<SubCategoryList>(context, listen: false)
                .subCategories
                .where((element) => element.categoryId == cate!.categoryId)
                .toList()
            : null;
  }

  SubCategoryModel? getSelectedSubCategory() {
    return widget.selectedSubCategory != null
        ? widget.selectedSubCategory!
        : scatesByCateId != null
            ? scatesByCateId!.firstOrNull
            : null;
  }

  List<ProductModel> getProductsInSubCategory(SubCategoryModel scate) {
    List<ProductModel> list = Provider.of<ProductList>(context, listen: false).products;

    return list.where((element) => (element.subCategoryId == scate.subCategoryId)).toList();
  }

  Map<SubCategoryModel, List<ProductModel>>? getAllProductsByEachSubCategories() {
    Map<SubCategoryModel, List<ProductModel>>? psInEachSCates;
    if (scatesByCateId != null) {
      for (int i = 0; i < scatesByCateId!.length; ++i) {
        psInEachSCates ??= {};
        psInEachSCates[scatesByCateId![i]] = getProductsInSubCategory(scatesByCateId![i]);
      }
    }
    return psInEachSCates;
  }

  tabChange(int index) {
    if (scatesByCateId != null) {
      selectedSCate = scatesByCateId![index];
      if (_productPageController != null) {
        _productPageController!.jumpToPage(
          index,
        );
      }
    }
  }

  void updateProductsInCarts() {
    var provider = Provider.of<ProductsInCart>(context, listen: false);
    numberOfProducts = provider.getNumberOfProducts();
    totalQuantityOfProducts = provider.getTotalQuantityOfProducts();
    totalPrice = provider.getTotalPrice();
  }
}
