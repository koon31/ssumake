import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:ssumake/API/order_API.dart';
import 'package:ssumake/CartOrder/order_list_builder.dart';
import 'package:ssumake/Model/CartOrder/order_model.dart';
import 'package:ssumake/Model/User/user_model.dart';
import '../Constants/color.dart';

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
              child: Consumer<OrderHistory>(builder: (context, orderHistory, child) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 4),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: orderHistory.orderHistory.length,
                  itemBuilder: (context, index) {
                    return OrderListBuilder(index: index);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider();
                  },
                );
              }),
            );
          } else {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(color: kPrimaryColor, size: 40),
            );
          }
        });
  }

  getAllOrderHistory() async {
    UserModel? user = Provider.of<User>(context, listen: false).user;
    final String? stringOfOrderHistory = await OrderAPI.getOrderHistory(user!.id!);
    var provider = Provider.of<OrderHistory>(context, listen: false);
    provider.removeAllOrderHistory();
    if (stringOfOrderHistory != null && stringOfOrderHistory.isNotEmpty) {
      provider.getAllOrderHistoryFromAPI(stringOfOrderHistory);
    }
  }
}
