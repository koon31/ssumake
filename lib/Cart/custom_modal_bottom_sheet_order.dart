import 'package:collection/collection.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/Product/category_model.dart';
import 'package:ssumake/Model/Product/discount_model.dart';
import 'package:ssumake/Model/Product/sub_category_model.dart';
import '../CommonFeatures/custom_title_style.dart';
import '../Model/Product/product_model.dart';
import '../Model/User/user_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';

class CustomModalBottomSheetOrder extends StatefulWidget {
  const CustomModalBottomSheetOrder({Key? key}) : super(key: key);

  @override
  State<CustomModalBottomSheetOrder> createState() =>
      _CustomModalBottomSheetOrderState();
}

class _CustomModalBottomSheetOrderState
    extends State<CustomModalBottomSheetOrder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleModalBottomSheet(),
        Consumer<User>(builder: (context, value, child) {
          return Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 15,
                        child: Container(
                          color: Colors.grey[200],
                        )),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          deliveryInformation(),
                          userInformation(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 4,
                          horizontal: kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding / 4),
                            child: Text('Giao đến',
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          Text(
                            value.user!.address!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kDefaultPadding),
                      child: Divider(color: Colors.grey, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: kDefaultPadding / 4,
                          horizontal: kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding / 2),
                            child: Text('Trạng thái thanh toán',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.only(right: kDefaultPadding),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                              Text('Đã thanh toán',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: kDefaultPadding),
                      child: Divider(color: Colors.grey, thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: kDefaultPadding / 4,
                          left: kDefaultPadding, right: kDefaultPadding, bottom: kDefaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: kDefaultPadding / 2),
                            child: Text('Mã Đơn Hàng',
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          Text('MD564DLKHO2D54694',
                              style:
                              Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 15,
                        child: Container(
                          color: Colors.grey[200],
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding,
                          vertical: kDefaultPadding / 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productListTitle(),
                          productListInCart(),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 15,
                        child: Container(
                          color: Colors.grey[200],
                        )),
                    priceCalculationBuilder(),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Container titleModalBottomSheet() {
    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding * 1.4),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                  'Trạng thái thanh toán',
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }

  deliveryInformation() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child:
          Text('Thông tin đơn hàng', style: CustomTextStyle.custom1(context)),
    );
  }

  userInformation() {
    return Consumer<User>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.only(
            bottom: kDefaultPadding / 4 * 3, top: kDefaultPadding / 4),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: DottedDecoration(
                      shape: Shape.line,
                      linePosition: LinePosition.bottom,
                      color: Colors.grey),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text('Tên người nhận'),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text(
                            value.user!.fullname!,
                          ),
                        ),
                      ]),
                ),
              ),
              const VerticalDivider(color: Colors.grey, thickness: 1),
              Expanded(
                child: Container(
                  decoration: DottedDecoration(
                      shape: Shape.line,
                      linePosition: LinePosition.bottom,
                      color: Colors.grey),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text('Số điện thoại'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: kDefaultPadding / 4,
                              bottom: kDefaultPadding / 2),
                          child: Text(
                            value.user!.phoneNumber!,
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  productListTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding/4*3),
      child: Text('Các sản phẩm đã chọn',
          style: CustomTextStyle.custom1(context)),
    );
  }

  productListInCart() {
    return Consumer<ProductsInCart>(builder: (context, value, child) {
      return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: value.getNumberOfProducts(),
          itemBuilder: (context, index) => productBuilder(index));
    });
  }

  productBuilder(int index) {
    return Consumer4<ProductsInCart, CategoryList, SubCategoryList,
            DiscountList>(
        builder: (context, productInCart, cates, scates, discounts, child) {
      ProductModel product =
          productInCart.getAllProductsInCart()!.keys.toList()[index];
      DiscountModel? d = product.discountId != null
          ? discounts.findDiscountById(product.discountId!)
          : null;
      int quantityOfProduct =
          productInCart.getAllProductsInCart()![product] ?? 0;
      return ListTile(
        minVerticalPadding: 0,
        contentPadding: EdgeInsets.zero,
        visualDensity: const VisualDensity(vertical: -4),
        leading: Text("$quantityOfProduct", style: CustomTextStyle.custom1(context)),
        title: Text("${product.productName}"),
        subtitle: const Text("Gói"),
        trailing: d != null && product.discountId != null
            ? d.discountPercent != 0
                ? Text(
                    "${product.price! * (100 - (d.discountPercent as num)) / 100}VND")
                : Text("${product.price! - (d.discountMoney as num)}VND")
            : Text("${product.price}VND"),
      );
    });
  }

  priceCalculationBuilder() {
    return Consumer2<ProductsInCart, DiscountList>(
        builder: (context, psInCart, discounts, child) {
      double price = 0;
      for (int i = 0; i < psInCart.getNumberOfProducts(); ++i) {
        ProductModel p = psInCart.getProductAt(i);
        DiscountModel? d = p.discountId != null
            ? discounts.discounts.firstWhereOrNull(
                (element) => element.discountId == p.discountId)
            : null;
        price += d != null
            ? d.discountPercent != 0
                ? psInCart.getQuantityOfProducts(p)! *
                    p.price! *
                    (100 - (d.discountPercent as num)) /
                    100
                : psInCart.getQuantityOfProducts(p)! *
                    (p.price! - d.discountMoney!)
            : psInCart.getQuantityOfProducts(p)! * p.price!;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: kDefaultPadding,
                top: kDefaultPadding / 4 * 3,
                bottom: kDefaultPadding / 4),
            child: Text('Tổng cộng', style: CustomTextStyle.custom1(context)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 4, horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Thành tiền'), Text("${price}VND")],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Divider(color: Colors.grey, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 4, horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Phí vận chuyển'),
                Text(price < 50000 ? "10.000VND" : "0VND"),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Divider(color: Colors.grey, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: kDefaultPadding / 4,
                bottom: kDefaultPadding / 4 * 3,
                left: kDefaultPadding,
                right: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Số tiền phải thanh toán',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(price >= 50000 ? "${price}VND" : "${price + 10000}VND",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: kDefaultPadding),
            child: Divider(color: Colors.grey, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPadding / 4, horizontal: kDefaultPadding),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.money,
                    size: 20,
                    color: Colors.green,
                  ),
                ),
                Text(
                  'Tiền mặt',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  paymentBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(
              left: kDefaultPadding,
              top: kDefaultPadding / 4 * 3,
              bottom: kDefaultPadding / 4),
          child: Text('Thanh Toán'),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: kDefaultPadding / 4,
              horizontal: kDefaultPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.money,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Tiền mặt',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
