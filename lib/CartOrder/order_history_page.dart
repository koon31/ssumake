import 'package:flutter/material.dart';

import '../Constants/color.dart';
import 'order_history_body.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child:
      Scaffold(appBar: buildAppBar(context), body: const OrderHistoryBody()),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Lịch sử đơn hàng'.toUpperCase(), style: const TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold),),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kTextColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        );
      }),
    );
  }
}
