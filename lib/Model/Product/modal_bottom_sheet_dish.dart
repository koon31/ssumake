import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/show_custom_modal_bottom_sheet.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/Dish/dish_detail_model.dart';
import 'package:ssumake/Model/Dish/dish_model.dart';

import 'category_model.dart';
import 'product_model.dart';
import 'sub_category_model.dart';

class CustomModalBottomSheetDish extends StatefulWidget {
  const CustomModalBottomSheetDish({Key? key, this.dish}) : super(key: key);
  final DishModel? dish;

  @override
  State<CustomModalBottomSheetDish> createState() => _CustomModalBottomSheetDishState();
}

class _CustomModalBottomSheetDishState extends State<CustomModalBottomSheetDish> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    print(widget.dish?.dishName);
    print(widget.dish?.dishDescription);
    print(widget.dish?.dishCooking);
    for (DishDetailModel dd in widget.dish!.dishDetails!) {
      print(dd.productName);
      print(dd.quantity);
      print(dd.unitName);
    }
    print(widget.dish?.dishName);
    return SafeArea(
      child: Column(
        children: [
          titleModalBottomSheet(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2, vertical: kDefaultPadding),
                  child: widget.dish != null
                      ? RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: kDefaultPadding / 20,
                                  ),
                                  child: Text(
                                    "${widget.dish?.dishName}\n".toUpperCase(),
                                    style:
                                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                ),
                              ),
                              const WidgetSpan(
                                child: Text(
                                  "Nguyên liệu:\n",
                                  style: TextStyle(fontSize: 18, color: Colors.black),
                                ),
                              ),
                              WidgetSpan(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: widget.dish?.dishDetails?.length,
                                  itemBuilder: (context, index) 
                                  {
                                    ProductModel? p = Provider.of<ProductList>(context, listen: false).products.firstWhereOrNull((element) => element.productId == widget.dish?.dishDetails?[index].productId);
                                    SubCategoryModel? scate;
                                    CategoryModel? cate;
                                    if (p!=null) {
                                      scate = Provider.of<SubCategoryList>(context, listen: false).subCategories.firstWhereOrNull((element) => element.subCategoryId == p.subCategoryId);
                                      if (scate!=null) {
                                        cate = Provider.of<CategoryList>(context, listen: false)
                                              .categories
                                              .firstWhereOrNull((element) => element.categoryId == scate?.categoryId);
                                      }
                                    }
                                    return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                                    child: InkWell( onTap: () {
                                      if (p != null && scate != null && cate != null) {
                                        ShowModalBottomSheet.showEditProduct(
                                            context,
                                            p,
                                            getSubCategoryAndCategory(
                                                cate,
                                                scate),
                                            true,);
                                      }
                                    },
                                      child: Text(
                                        '- ${widget.dish?.dishDetails?[index].quantity} ${widget.dish
                                            ?.dishDetails?[index].quantity} ${widget.dish?.dishDetails?[index]
                                            .unitName} ${widget.dish?.dishDetails?[index].productName}\n',
                                        style: const TextStyle(fontSize: 16, color: Colors.black),),
                                    ),
                                  );}
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                                  child: Text(
                                    '- ${widget.dish?.dishDescription}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                                  child: Text(
                                    '- ${widget.dish?.dishCooking}',
                                    style: const TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container titleModalBottomSheet() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Colors.grey,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 46),
                child: Text(
                  'Món Ngon Nấu Cùng',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 23),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }

  getSubCategoryAndCategory(CategoryModel cate, SubCategoryModel scate) {
    return cate.categoryName.toString() +
        '/' +
        scate.subCategoryName.toString();
  }
}
