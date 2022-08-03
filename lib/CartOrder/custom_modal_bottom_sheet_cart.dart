import 'package:collection/collection.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/show_custom_modal_bottom_sheet.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/Product/category_model.dart';
import 'package:ssumake/Model/Product/discount_model.dart';
import 'package:ssumake/Model/Product/sub_category_model.dart';
import '../CommonFeatures/custom_title_style.dart';
import '../Model/Location/location_model.dart';
import '../Model/Product/product_model.dart';
import '../Model/User/user_model.dart';
import '../Model/CartOrder/product_in_cart_model.dart';

class CustomModalBottomSheetCart extends StatefulWidget {
  const CustomModalBottomSheetCart({Key? key}) : super(key: key);

  @override
  State<CustomModalBottomSheetCart> createState() =>
      _CustomModalBottomSheetCartState();
}

class _CustomModalBottomSheetCartState
    extends State<CustomModalBottomSheetCart> {

  late UserModel user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getLoggedUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        titleModalBottomSheet(),
        Expanded(
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
                    decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding,
                        vertical: kDefaultPadding / 5),
                    child: Column(
                      children: [
                        deliveryInformation(),
                        userInformation(),
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
                  SizedBox(
                      height: 15,
                      child: Container(
                        color: Colors.grey[200],
                      )),
                  paymentBuilder(),
                  SizedBox(
                      height: 15,
                      child: Container(
                        color: Colors.grey[200],
                      )),
                  deleteCartBuild(),
                ],
              ),
            ),
          ),
        ),
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
                  'Xác nhận đơn hàng',
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

  Column deliveryInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Giao Tận Nơi', style: CustomTextStyle.custom1(context)),
              customButtonOfModalBottomSheet('Thay Đổi', () => ShowModalBottomSheet.showChangeAddress(context))
            ],
          ),
        ),
        addressInformation(),
        guildDelivery(),
      ],
    );
  }

  addressInformation() {
    return Consumer2<User, Location>(builder: (context, user, location, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: user.user!.address != null && location.location!= null ? user.user!.address!.isNotEmpty ? Text(
                  user.user!.address! + ', ' + location.location!.cwt! + ', ' + location.location!.district! + ', ' + location.location!.province!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 12),
                ) : const Text(
                  "Xin cập nhật địa chỉ giao hàng",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ) : const Text(
                  "Xin cập nhật địa chỉ giao hàng",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black,
              size: 20,
            ),
          ],
        ),
      );
    });
  }

  guildDelivery() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
      child: TextField(
        decoration: InputDecoration(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.black45,
                )),
            hintText: 'Ghi chú cho người giao hàng',
            hintStyle: const TextStyle(color: Colors.black45)),
      ),
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
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text(value.user!.fullname!),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text(
                            value.user!.phoneNumber!,
                            style: const TextStyle(color: Colors.grey),
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
                      children: const [
                        Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                          child: Text('Hôm nay'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: kDefaultPadding / 4,
                              bottom: kDefaultPadding / 2),
                          child: Text(
                            'Càng sớm càng tốt',
                            style: TextStyle(color: Colors.grey),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Các sản phẩm đã chọn', style: CustomTextStyle.custom1(context),),
        customButtonOfModalBottomSheet('+ Thêm', () => Navigator.pop(context)),
      ],
    );
  }

  productListInCart() {
    return GestureDetector(
      child: Consumer<ProductsInCart>(builder: (context, value, child) {
        return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: value.getNumberOfProducts(),
            itemBuilder: (context, index) => productBuilder(index));
      }),
    );
  }

  productBuilder(int index) {
    return Consumer4<ProductsInCart,
        CategoryList,
        SubCategoryList,
        DiscountList>(
        builder: (context, productInCart, cates, scates, discounts, child) {
          ProductModel product =
          productInCart.getAllProductsInCart()!.keys.toList()[index];
          DiscountModel? d = product.discountId != null ? discounts
              .findDiscountById(product.discountId!) : null;
          int quantityOfProduct =
              productInCart.getAllProductsInCart()![product] ?? 0;
          return GestureDetector(
            onTap: () {
              SubCategoryModel scate = scates.subCategories
                  .where(
                      (element) =>
                  element.subCategoryId == product.subCategoryId)
                  .first;
              ShowModalBottomSheet.showEditProduct(
                  context,
                  product,
                  getSubCategoryAndCategory(
                      cates.categories
                          .where(
                              (element) =>
                          element.categoryId == scate.categoryId)
                          .first,
                      scate),
                  false);
            },
            child: Slidable(
              child: ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(vertical: -4),
                leading: GestureDetector(
                  child: const Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                  ),
                  onTap: () {},
                ),
                title: Text("$quantityOfProduct x ${product.productName}"),
                subtitle: const Text("Gói"),
                trailing: d != null && product.discountId != null
                    ? d
                    .discountPercent !=
                    0
                    ? Text(
                    "${product.price! * (100 - (d.discountPercent as num)) /
                        100}VND")
                    : Text(
                    "${product.price! - (d.discountMoney as num)}VND")
                    : Text("${product.price}VND"),
              ),
              endActionPane: ActionPane(
                  openThreshold: 0.2,
                  extentRatio: 0.3,
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      //Space
                      icon: Icons.add_circle,
                      label: '',
                      onPressed: (context) {},
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      flex: 1,
                    ),
                    SlidableAction(
                      flex: 8,
                      padding: const EdgeInsets.all(kDefaultPadding / 10),
                      borderRadius: BorderRadius.circular(20),
                      label: "Edit",
                      backgroundColor: Colors.grey[600]!,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      onPressed: (context) {
                        SubCategoryModel scate = scates.subCategories
                            .where((element) =>
                        element.subCategoryId == product.subCategoryId)
                            .first;
                        ShowModalBottomSheet.showEditProduct(
                            context,
                            product,
                            getSubCategoryAndCategory(
                                cates.categories
                                    .where((element) =>
                                element.categoryId == scate.categoryId)
                                    .first,
                                scate),
                            false);
                      },
                    ),
                    SlidableAction(
                      //Space
                      icon: Icons.add_circle,
                      label: '',
                      onPressed: (context) {},
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      flex: 1,
                    ),
                    SlidableAction(
                      flex: 8,
                      padding: const EdgeInsets.all(kDefaultPadding / 10),
                      borderRadius: BorderRadius.circular(20),
                      label: "Delete",
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      onPressed: (context) {
                        setState(() => onDeleteProduct(product));
                      },
                    ),
                    SlidableAction(
                      //Space
                      icon: Icons.add_circle,
                      label: '',
                      onPressed: (context) {},
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.transparent,
                      flex: 1,
                    ),
                  ]),
            ),
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
                ? discounts.discounts
                .firstWhereOrNull((element) =>
            element.discountId == p.discountId)
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
                  children: [
                    const Text('Thành tiền'),
                    Text("${price}VND")
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
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding / 5, horizontal: kDefaultPadding),
                child: GestureDetector(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Chọn khuyến mãi',
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                      ),
                    ],
                  ),
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
                    Text(
                        price >= 50000
                            ? "${price}VND"
                            : "${price + 10000}VND",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
        Padding(
          padding: const EdgeInsets.only(
              left: kDefaultPadding,
              top: kDefaultPadding / 4 * 3,
              bottom: kDefaultPadding / 4),
          child: Text('Thanh Toán',style: CustomTextStyle.custom1(context)),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: kDefaultPadding / 4,
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding / 4 * 3),
          child: GestureDetector(
            onTap: () {},
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
                        color: Colors.green,
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
        ),
      ],
    );
  }

  deleteCartBuild() {
    return GestureDetector(
      onTap: () {
        var provider = Provider.of<ProductsInCart>(context, listen: false);
        provider.deleteCart();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 4 * 3, horizontal: kDefaultPadding),
        child: Row(
          children: const [
            Icon(
              Icons.delete,
              size: 20,
              color: Colors.red,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                'Xoá tất cả sản phẩm trong giỏ hàng',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customButtonOfModalBottomSheet(String label, Function() press) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      width: 60,
      height: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: customElevatedButton(label, press),
      ),
    );
  }

  Widget customElevatedButton(String label, Function() press) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        primary: kPrimaryColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          // vertical: 20,
        ),
        textStyle: const TextStyle(
          color: kPrimaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kPrimaryLightColor,
        ),
      ),
    );
  }

  onDeleteProduct(ProductModel p) {
    var provider = Provider.of<ProductsInCart>(context, listen: false);
    provider.deleteToCart(p);
    if (provider.getTotalQuantityOfProducts() == 0) Navigator.pop(context);
  }

  getSubCategoryAndCategory(CategoryModel cate, SubCategoryModel scate) {
    return cate.categoryName.toString() +
        '/' +
        scate.subCategoryName.toString();
  }

  void getLoggedUserInfo() {
    user = Provider
        .of<User>(context, listen: false)
        .user!;
    print(user.token);
  }
}

