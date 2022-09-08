import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/API/order_API.dart';
import 'package:ssumake/CommonFeatures/custom_title_style.dart';
import 'package:ssumake/CommonFeatures/show_custom_modal_bottom_sheet.dart';
import 'package:ssumake/Model/CartOrder/order_detail_model.dart';
import 'package:ssumake/Model/CartOrder/order_model.dart';
import 'package:ssumake/Model/User/user_model.dart';
import '../Constants/color.dart';
import '../Model/Product/product_model.dart';

class OrderHistoryBody extends StatefulWidget {
  const OrderHistoryBody({Key? key}) : super(key: key);

  @override
  State<OrderHistoryBody> createState() => _OrderHistoryBodyState();
}

class _OrderHistoryBodyState extends State<OrderHistoryBody> {
  late final Future _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = getAllOrderHistory();
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SingleChildScrollView(
              child: Consumer<OrderHistory>(
                  builder: (context, orderHistory, child) {
                return ListView.separated(
                  padding:
                      const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderHistory.orderHistory.length,
                  itemBuilder: (context, index) => orderBuilder(index, context),
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              }),
            );
          } else {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                  color: kPrimaryColor, size: 40),
            );
          }
        });
  }

  orderBuilder(int index, BuildContext context) {
    return Consumer2<OrderHistory, ProductList>(
        builder: (context, orderHistory, products, child) {
      String nameProductList = '';
      List<OrderDetailModel> orderDetails =
          orderHistory.orderHistory.reversed.toList()[index].orderDetails!.toList();
      for (OrderDetailModel od in orderDetails) {
        ProductModel product = products.products
            .firstWhere((element) => element.productId == od.productId);
        if (nameProductList.isEmpty) {
          if (product.productName != null && product.productName!.isNotEmpty) {
            nameProductList += product.productName!;
          }
        } else {
          if (product.productName != null && product.productName!.isNotEmpty) {
            nameProductList += ', ' + product.productName!;
          }
        }
      }
      print(nameProductList);
      return InkWell(
        onTap: (){ShowModalBottomSheet.showOrder(context, orderHistory.orderHistory.reversed.toList()[index]);},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: ListTile(
            minVerticalPadding: 0,
            contentPadding: EdgeInsets.zero,
            visualDensity: const VisualDensity(vertical: -4),
            leading: const Icon(
              Icons.delivery_dining,
              color: Colors.black,
            ),
            title: Text(nameProductList,
                style: CustomTextStyle.custom1(context),
                maxLines: 3,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(DateFormat("hh:mm - dd/MM/yyyy")
                .format(orderHistory.orderHistory.reversed.toList()[index].dateCreate!)),
            trailing: Text(
                orderHistory.orderHistory.reversed.toList()[index].totalPrice!.toStringAsFixed(1) +
                    ' VND',
                style: CustomTextStyle.custom1(context)),
          ),
        ),
      );
    });
  }

  getAllOrderHistory() async {
    UserModel? user = Provider.of<User>(context, listen: false).user;
    final String? stringOfOrderHistory =
        await OrderAPI.getOrderHistory(user!.id!);
    var provider = Provider.of<OrderHistory>(context, listen: false);
    provider.removeAllOrderHistory();
    if (stringOfOrderHistory != null && stringOfOrderHistory.isNotEmpty) {
      provider.getAllOrderHistoryFromAPI(stringOfOrderHistory);
    }
    print(provider.orderHistory.first.totalPrice);
  }
}
