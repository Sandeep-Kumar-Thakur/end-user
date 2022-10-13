import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/my_button.dart';
import 'package:flutter/material.dart';

import '../utility/common_decoration.dart';

class OrderSuccessfulScreen extends StatelessWidget {
  const OrderSuccessfulScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myPadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ordered Successfully",style: CommonDecoration.headerDecoration.copyWith(fontSize: 30),textAlign: TextAlign.center,),
            SizedBox(height:
              100,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70,vertical: 20),
              child: Image.asset("assets/icons/order.png"),
            ),
            Text("Thanking You For Shopping. Your Order Has Been Placed Successfully! ",style: CommonDecoration.listItem,textAlign: TextAlign.center,),
            largeSpace(),
            InkWell(
                onTap: (){
                  hideLoader();
                },
                child: MyRoundButton(text: "Done", bgColor: ColorConstants.themeColor))
          ],
        ),
      ),
    );
  }
}
