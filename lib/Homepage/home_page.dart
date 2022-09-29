import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/API/category_subCategory_unit_discount_API.dart';
import 'package:ssumake/API/location_API.dart';
import 'package:ssumake/API/login_API.dart';
import 'package:ssumake/CommonFeatures/custom_cart_button.dart';
import 'package:ssumake/Homepage/home_page_background.dart';
import 'package:ssumake/Homepage/home_page_body.dart';
import 'package:ssumake/Homepage/home_page_drawer.dart';
import 'package:ssumake/Model/Product/discount_model.dart';
import 'package:ssumake/Model/Product/unit_model.dart';

import '../API/product_API.dart';
import '../CommonFeatures/custom_bottom_app_bar.dart';
import '../CommonFeatures/display_toast.dart';
import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Model/Location/location_model.dart';
import '../Model/Product/category_model.dart';
import '../Model/Product/product_model.dart';
import '../Model/Product/sub_category_model.dart';
import '../Model/User/user_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';
import 'set_uri_dialog.dart';

int categoryDefault = 4;
int subCategoryDefault = 18;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.category, this.subCategoriesByCategoryId, this.subCategory}) : super(key: key);

  final CategoryModel? category;
  final List<SubCategoryModel>? subCategoriesByCategoryId;
  final SubCategoryModel? subCategory;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int numberOfProducts = 0;
  late final Future _futureData;

  String? scanResult;

  @override
  void initState() {
    getNumberOfProducts();
    _futureData = loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await getAllCategories();
    await getAllSubCategories();
    await getAllUnits();
    await getAllDiscounts();
    await getAllProducts();
    await getLoggedInUser();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar(context),
        bottomNavigationBar: buildBottomAppBar(context),
        drawer: Consumer2<CategoryList, SubCategoryList>(builder: (context, cates, scates, child) {
          return HomePageDrawer(
            categories: cates.categories,
            subCategories: scates.subCategories,
          );
        }),
        body: FutureBuilder(
          future: _futureData,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              print(Provider.of<CategoryList>(context).categories.firstOrNull?.categoryName);
              return (widget.category != null && widget.subCategoriesByCategoryId != null && widget.subCategory != null)
                  ? HomePageBody(
                      category: widget.category,
                      subCategoriesByCategoryId: widget.subCategoriesByCategoryId,
                      selectedSubCategory: widget.subCategory,
                    )
                  : Consumer2<CategoryList, SubCategoryList>(
                      builder: (context, cates, scates, child) {
                        return HomePageBody(
                          // category: cates.categories.firstWhereOrNull((element) => categoryDefault == element.categoryId),
                          // selectedSubCategory: scates.subCategories
                          //     .firstWhereOrNull((element) => element.subCategoryId == subCategoryDefault),
                          // subCategoriesByCategoryId:
                          //     scates.subCategories.where((element) => element.categoryId == categoryDefault).toList(),
                        );
                      },
                    );
            } else {
              return SingleChildScrollView(
                child: SizedBox.fromSize(
                  size: MediaQuery.of(context).size,
                  child: Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: kPrimaryColor,
                      size: 40,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Consumer2<ProductsInCart, DiscountList>(builder: (context, psInCart, discounts, child) {
        double price = 0;
        for (int i = 0; i < psInCart.getNumberOfProducts(); ++i) {
          ProductModel p = psInCart.getProductAt(i);
          DiscountModel? d = p.discountId != null
              ? discounts.discounts.firstWhereOrNull((element) => element.discountId == p.discountId)
              : null;
          price += d != null
              ? d.discountPercent != 0
                  ? psInCart.getQuantityOfProducts(p)! * p.price! * (100 - (d.discountPercent as num)) / 100
                  : psInCart.getQuantityOfProducts(p)! * (p.price! - d.discountMoney!)
              : psInCart.getQuantityOfProducts(p)! * p.price!;
        }
        return CustomBottomAppBarHomePage(
            message: "Hello",
            buttonLabel1: price,
            buttonLabel2: psInCart.getTotalQuantityOfProducts(),
            press: () async {
              await ShowModalBottomSheet.showCart(context);
              setState(() {});
            });
      }),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0x6FFFFFFF),
      elevation: 0,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.menu,
            color: kTextColor,
            size: 30,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      actions: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: InkWell(
              child: const Icon(
                CupertinoIcons.qrcode_viewfinder,
                color: kTextColor,
                size: 30,
              ),
              onTap: scanBarcode),
        ), // call scanBarcode  function
        Consumer<ProductsInCart>(
          builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.only(right: kDefaultPadding / 2),
              child: CustomCartButton(
                  color: kTextColor,
                  numberOfProducts: value.getNumberOfProducts(),
                  press: () {
                    if (value.getNumberOfProducts() > 0) {
                      ShowModalBottomSheet.showCart(context);
                    }
                  }),
            );
          },
        ),
        InkWell(
            child: const Icon(
              Icons.settings,
              color: kTextColor,
              size: 30,
            ),
            onTap: (){
              showDialog(
                  context: context,
                  builder: (context) => const SetURIDialog());
            }),
        const SizedBox(width: kDefaultPadding )
      ],
    );
  }

  void getNumberOfProducts() {
    var provider = Provider.of<ProductsInCart>(context, listen: false);
    numberOfProducts = provider.getNumberOfProducts();
  }

  Future<void> getAllCategories() async {
    final stringOfCategories = await CategoryAPI.getCategories();
    var provider = Provider.of<CategoryList>(context, listen: false);
    provider.removeAllCategories();
    provider.getAllCategoriesFromAPI(stringOfCategories);
  }

  Future<void> getAllSubCategories() async {
    var provider = Provider.of<SubCategoryList>(context, listen: false);
    provider.removeAllSubCategories();
    final cates = Provider.of<CategoryList>(context, listen: false).categories;
    for (CategoryModel c in cates) {
      final stringOfSubCategories = await SubCategoryAPI.getSubCategoriesByCategoryId(c.categoryId!);
      provider.getAllSubCategoriesFromAPI(stringOfSubCategories);
    }
  }

  Future<void> getAllUnits() async {
    final stringOfUnits = await UnitAPI.getUnits();
    var provider = Provider.of<UnitList>(context, listen: false);
    provider.removeAllUnits();
    provider.getAllUnitsFromAPI(stringOfUnits);
  }

  Future<void> getAllDiscounts() async {
    final stringOfDiscounts = await DiscountAPI.getDiscounts();
    var provider = Provider.of<DiscountList>(context, listen: false);
    provider.removeAllDiscounts();
    provider.getAllDiscountsFromAPI(stringOfDiscounts);
  }

  Future<void> getAllProducts() async {
    final stringOfProducts = await ProductAPI.getProducts();
    var provider = Provider.of<ProductList>(context, listen: false);
    provider.removeAllProducts();
    provider.getAllProductsFromAPI(stringOfProducts);
  }

  Future<void> getLoggedInUser() async {
    var userProvider = Provider.of<User>(context, listen: false);
    var locationProvider = Provider.of<Location>(context, listen: false);
    final result = await LoginAPI.getLoggedInUser();
    final UserModel? loggedInUser = UserModel.fromMap(jsonDecode(result.body));
    if (loggedInUser != null) userProvider.login(loggedInUser);
    print(userProvider.user!.token);
    print(userProvider.user!.id);
    String? strLocation;
    if (userProvider.user != null) {
      if (userProvider.user!.cwtId != null && userProvider.user!.cwtId != 0) {
        strLocation = await LocationAPI.getLocationByCWTId(userProvider.user!.cwtId.toString());
      }
      if (strLocation != null && strLocation.isNotEmpty) {
        locationProvider.getLocationFromAPI(strLocation);
      }
    }
  }

  //scan bar code function
  Future<void> scanBarcode() async {
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", false, ScanMode.BARCODE);
      print('Barcode Found ' + scanResult.toString());
      ProductModel? product = Provider.of<ProductList>(context, listen: false).products.firstWhereOrNull((element) {
        return element.productId!.toString() == scanResult;
      });
      if (scanResult != "-1") {
        setState(() async {
          scanResult = scanResult;
          print(scanResult);
          if (product != null) {
            ShowModalBottomSheet.showEditProduct(context, product, true);
          } else {
            Future.delayed(const Duration(seconds: 1));
            DisplayToast.displayErrorToast(context, 'Không tìm thấy sản phẩm');
            await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
            Navigator.pop(context);
          }
        });
      } else {
        setState(() {
          scanResult = "Scan canceled";
        });
      }
    } on PlatformException {
      Timer(const Duration(seconds: 2), () {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
        DisplayToast.displayErrorToast(context, 'Không tìm thấy sản phẩm fail');
      });
      scanResult = 'Lấy phiên bản điện thoại thất bại';
    }
  }
}
