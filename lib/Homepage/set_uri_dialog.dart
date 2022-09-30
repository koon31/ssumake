import 'package:flutter/material.dart';
import 'package:ssumake/Homepage/home_page.dart';

import '../../CommonFeatures/custom_button.dart';
import '../../CommonFeatures/input_decoration.dart';
import '../../Constants/color.dart';
import '../Constants/uri.dart';

class SetURIDialog extends StatefulWidget {
  const SetURIDialog({Key? key}) : super(key: key);

  @override
  State<SetURIDialog> createState() => _SetURIDialogState();
}

class _SetURIDialogState extends State<SetURIDialog> {
  final _uriController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _uriController.text = URI.EDITABLE_BASE_URI.isNotEmpty? URI.EDITABLE_BASE_URI:URI.BASE_URI;
    Size size = MediaQuery.of(context).size;
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            12.0,
          ),
        ), //this right here
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400, minHeight: 300),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Set URI",
                  style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 26),
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  controller: _uriController,
                  hintText: "URI",
                  icon: Icons.link,
                  type: TextInputType.url,
                  onChanged: (value) {},
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'URI sai';
                    } else {
                      return null;
                    }
                  },
                ),
                CustomButtonMedium(
                  text: "Set URI",
                  press: () {
                    URI.EDITABLE_BASE_URI = _uriController.text.contains("http://")?_uriController.text:"http://"+_uriController.text+":5000/";
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
