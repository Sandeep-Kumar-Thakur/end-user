import 'package:bala_ji_mart/firebase/authentication_controller.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/color_constants.dart';
import '../../utility/common_decoration.dart';
import '../../utility/my_button.dart';

class OtpScreen extends StatelessWidget {
   OtpScreen({Key? key}) : super(key: key);

   final authenticationController  = Get.put(AuthenticationController());
   final  otpController  = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: myPadding(
          child: Column(
            children: [
              Text("Otp Verification",style: CommonDecoration.headerDecoration,),
              largeSpace(),
              PinCodeTextField(
                controller: otpController,
                appContext: context,
                keyboardType: TextInputType.number,
                length: 6,
                onChanged: (v) {},
                autoFocus: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: Text("OTP SENT ON +91 ${authenticationController.Number.value}",style: CommonDecoration.descriptionDecoration,),),
              largeSpace(),
              InkWell(
                  onTap: (){
                   authenticationController.verifyNumber(otp: otpController.value.text);
                  },
                  child: MyRoundButton(text: "Verify Otp", bgColor: ColorConstants.themeColor)),
              largeSpace(),
              Row(
                children: [
                  Text("Didn't receive code?",style: CommonDecoration.listItem.copyWith(color: Colors.grey),),
                  InkWell(
                      onTap: (){
                         authenticationController.getOtp(phoneNumber: authenticationController.Number.value,navigate: false);
                      },
                      child: Text(" Resend ",style: CommonDecoration.listItem,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
