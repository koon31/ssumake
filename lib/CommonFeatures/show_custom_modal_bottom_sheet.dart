import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/CommonFeatures/custom_bottom_app_bar.dart';
import 'package:ssumake/Constants/color.dart';
import 'package:ssumake/Model/Dish/dish_model.dart';
import 'package:ssumake/Model/Product/discount_model.dart';
import 'package:ssumake/Model/CartOrder/order_detail_model.dart';
import 'package:ssumake/Model/CartOrder/product_in_cart_model.dart';
import 'package:ssumake/Product/modal_bottom_sheet_dish.dart';
import 'package:ssumake/Product/detail_product_page_body.dart';
import 'package:ssumake/User/modal_bottom_sheet_forgot_password.dart';
import 'package:ssumake/User/modal_bottom_sheet_update_password.dart';
import 'package:ssumake/User/modal_bottom_sheet_update_user_email.dart';
import 'package:ssumake/User/modal_bottom_sheet_update_user_phone.dart';
import '../API/order_API.dart';
import '../CartOrder/custom_modal_bottom_sheet_cart.dart';
import '../CartOrder/custom_modal_bottom_sheet_order.dart';
import '../Login_Register/Login/login_dialog.dart';
import '../Model/CartOrder/order_model.dart';
import '../Model/Product/product_model.dart';
import '../Model/User/user_model.dart';
import '../User/modal_bottom_sheet_update_location.dart';
import '../User/modal_bottom_sheet_verify_password.dart';
import 'display_toast.dart';

class ShowModalBottomSheet {
  ShowModalBottomSheet._();

  static showCart(BuildContext context) async {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: BottomAppBar(
                child:
                    Consumer3<User, ProductsInCart, DiscountList>(builder: (context, user, psInCart, discounts, child) {
                  double price = 0;
                  List<OrderDetailModel> orderDetails = List<OrderDetailModel>.empty(growable: true);
                  for (int i = 0; i < psInCart.getNumberOfProducts(); ++i) {
                    OrderDetailModel orderDetail = OrderDetailModel.empty();
                    ProductModel p = psInCart.getProductAt(i);
                    orderDetail.productId = p.productId;
                    orderDetail.quantity = psInCart.getQuantityOfProducts(p);
                    orderDetail.price = p.price;
                    orderDetails.add(orderDetail);
                    price += orderDetail.price!;
                  }
                  return CustomBottomAppBarCart(press: () async {
                    OrderModel order = OrderModel.empty();
                    order.custormerId = user.user?.id;
                    order.dateCreate = DateTime.now();
                    order.address = user.user?.address;
                    order.paymentMethodId = 1;
                    order.discountId = null;
                    order.totalPrice = price;
                    order.status = 0;
                    order.orderDetails = orderDetails;
                    try {
                      if (user.user != null) {
                        if (user.user?.address != null) {
                          if (user.user!.address!.isNotEmpty) {
                            final result = await OrderAPI.addOrder(order);
                            if (result.statusCode == 200) {
                              if (result.body == 'true') {
                                Navigator.pop(context);

                                showOrder(context, null);
                                psInCart.deleteCart();
                                DisplayToast.displaySuccessToast(context, 'Mua th??nh c??ng');
                                await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
                              } else {
                                DisplayToast.displaySuccessToast(context, result.body);
                                await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
                                Navigator.pop(context);
                              }
                            } else {
                              DisplayToast.displayErrorToast(context, 'Mua th???t b???i');
                              await Future.delayed(const Duration(seconds: 2, milliseconds: 500));
                              Navigator.pop(context);
                            }
                          }
                        } else {}
                      } else {
                        showDialog(context: context, builder: (context) => const LoginDialog());
                      }
                    } catch (e) {
                      DisplayToast.displayErrorToast(context, 'Mua th???t b???i fail');
                    }
                  });
                }),
              ),
              body: const CustomModalBottomSheetCart());
        });
  }

  static showOrder(BuildContext context, OrderModel? seletedOrder) async {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: CustomModalBottomSheetOrder(
                  selectedOrder: seletedOrder,
                ),
              ));
        });
  }

  static showDish(BuildContext context, DishModel? dish) async {
    showMaterialModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: CustomModalBottomSheetDish(
              dish: dish,
            ),
          );
        });
  }

  static showUpdatePhoneEmail(BuildContext context, bool isPhone) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Wrap(
              children: [isPhone ? const ModalBottomSheetUpdateUserPhone() : const ModalBottomSheetUpdateUserEmail()]);
        });
  }

  static showCheckPassword(BuildContext context, bool isPhone) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Wrap(children: [
            ModalBottomSheetCheckPassword(
              isPhone: isPhone,
            )
          ]);
        });
  }

  static showChangeAddress(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Wrap(children: const [
            ModalBottomSheetChangeAddress(),
          ]);
        });
  }

  static showChangePassword(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Wrap(children: const [
            ModalBottomSheetUpdatePassword(),
          ]);
        });
  }

  static showForgotPassword(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext contextModal) {
          return Wrap(children: const [
            ModalBottomSheetForgotPassword(),
          ]);
        });
  }

  static showEditProduct(BuildContext context, ProductModel product, bool isAdd) async {
    showMaterialModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        builder: (BuildContext contextModal) {
          double statusBarHeight = MediaQuery.of(context).viewPadding.top;
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height- statusBarHeight,
                padding: const EdgeInsets.only(top: kDefaultPadding),
                decoration: const BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: DetailProductPageBody(
                  product: product,
                  isAdd: isAdd,
                )),
          );
        });
  }
}
