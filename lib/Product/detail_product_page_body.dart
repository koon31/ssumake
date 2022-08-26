import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Model/Dish/dish_model.dart';
import 'package:ssumake/Product/detail_product.dart';
import '../API/dish_API.dart';
import '../CommonFeatures/show_custom_modal_bottom_sheet.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';
import 'counter_with_add_to_cart_btn.dart';
import 'product_color_and_size.dart';
import 'product_description.dart';

class DetailProductPageBody extends StatefulWidget {
  final ProductModel product;
  final String cateSubCateTitle;
  final bool isAdd;

  const DetailProductPageBody(
      {Key? key,
      required this.product,
      required this.cateSubCateTitle,
      required this.isAdd /*required this.quantityOfProducts, required this.onNumberOfProductsChanged*/
      })
      : super(key: key);

  @override
  State<DetailProductPageBody> createState() => DetailProductPageBodyState();
}

class DetailProductPageBodyState extends State<DetailProductPageBody> {
  late final Future _futureData;

  @override
  void initState() {
    _futureData = loadData();
    super.initState();
    // quantityOfProducts =widget.quantityOfProducts!=0||widget.quantityOfProducts!=null?0:widget.quantityOfProducts;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height - MediaQuery.of(context).viewPadding.top,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.34),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding,
                    ),
                    height: size.height - size.height * 0.34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: Column(
                        children: <Widget>[
                          ProductQuantityAndUnit(product: widget.product),
                          ProductDescription(product: widget.product),
                          const CounterWithFavBtn(),
                          //CustomButtonLarge(text: "Món ngon nấu cùng", press: () {}),
                          FutureBuilder(
                            future: _futureData,
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Consumer<DishList>(
                                  builder: (context, value, child) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: kDefaultPadding / 2),
                                          child: Divider(
                                            thickness: 2,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: kDefaultPadding, bottom: kDefaultPadding),
                                          child: value.dishes.isNotEmpty
                                              ? FittedBox(
                                                  alignment: Alignment.topLeft,
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    'Các món ngon ăn cùng'.toUpperCase(),
                                                    style: Theme.of(context).textTheme.headline4?.copyWith(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                    maxLines: 1,
                                                  ))
                                              : Container(),
                                        ),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: value.dishes.length,
                                          separatorBuilder: (context, index) => const Divider(
                                            thickness: 1,
                                            color: Colors.white70,
                                          ),
                                          itemBuilder: (context, index) {
                                            DishModel? d = value.dishes[index];
                                            if (d != null && d.dishName != null && d.dishName!.isNotEmpty) {
                                              return InkWell(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                                                  child: FittedBox(
                                                    alignment: Alignment.topLeft,
                                                    fit: BoxFit.scaleDown,
                                                    child: Text(
                                                      '- ${d.dishName!}',
                                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            color: Colors.black,
                                                          ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                onTap: () {
                                                  ShowModalBottomSheet.showDish(context, d);
                                                },
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  DetailProduct(
                    product: widget.product,
                    cate_SubCateTitle: widget.cateSubCateTitle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loadData() async {
    await getAllDishByProductId(widget.product.productId.toString());
  }

  getAllDishByProductId(String? productId) async {
    final String? stringOfDishes = await DishAPI.getDishByProductId(productId);
    var provider = Provider.of<DishList>(context, listen: false);
    provider.removeAllDishes();
    if (stringOfDishes != null && stringOfDishes.isNotEmpty) {
      provider.getAllDishesFromAPI(stringOfDishes);
    }
    for (DishModel d in provider.dishes) {
      print(d.dishName);
    }
  }
}
