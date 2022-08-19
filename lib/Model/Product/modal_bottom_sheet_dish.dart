import 'package:flutter/material.dart';
import 'package:ssumake/Constants/color.dart';

class CustomModalBottomSheetDish extends StatefulWidget {
  const CustomModalBottomSheetDish({Key? key}) : super(key: key);

  @override
  State<CustomModalBottomSheetDish> createState() =>
      _CustomModalBottomSheetDishState();
}

class _CustomModalBottomSheetDishState
    extends State<CustomModalBottomSheetDish> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          titleModalBottomSheet(),
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding/2, vertical: kDefaultPadding),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "MÓN THỊT THĂN BÒ SỐT RƯỢU VANG\n".toUpperCase(),
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: "Nguyên liệu:\n",
                          style:
                          TextStyle(fontSize: 17, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 500-700 g Thịt Thăn Bò\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 1/2 Chén Rượu Vang\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 1 Củ Hành tây\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 2 Tép Tỏi\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 2 chén nước Sốt mì ống\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "- 2 muỗng canh Dầu ô liu\n",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "Thịt thăn bò sốt rượu vang luôn là lựa chọn hàng đầu của chị em phụ nữ. Chỉ mất 15 phút cho mỗi khâu chuẩn bị và chế biến. Bạn đã có ngay một món  thịt thăn bò chiên bổ dưỡng, thơm ngon và ấn tượng bởi hương vị của rượu vang đó.\n".toUpperCase(),
                          style:
                              TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "-Sơ chế nguyên liệu: băm nhỏ hành tây, tỏi đã bóc vỏ. Thăn bò sau khi được rửa sạch thái thành những lát dài, mỏng vừa ăn.\n-Đun nóng dầu trong chảo trên ngọn lửa vừa,thêm hành tây vào xào cho đến khi hành thơm và trở nên mềm hơn.\n- Cho thịt bò vào chiên cho tới khi 2 mặt vừa chín,vàng nhẹ.\n- Cho nước sốt,tỏi và rượu vang đỏ vào chảo.Giảm nhiệt xuống,để thức ăn đun sôi khoảng 10 - 15 phút.",
                          style:
                          TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
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
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }
}
