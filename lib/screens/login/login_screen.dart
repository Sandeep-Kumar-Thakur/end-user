import 'dart:developer';
import 'dart:io';

import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/firebase/authentication_controller.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/my_button.dart';
import 'package:bala_ji_mart/utility/my_text_field.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'otp_screen.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
  TextEditingController numberController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final  authenticationController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    var data = LocalStorage().readUserModel();
    myLog(label: "user data", value: data.toJson().toString());


    return WillPopScope(
      onWillPop: (){
        exit(0);
      },
      child: Scaffold(
        body: SafeArea(
          child: myPadding(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 70),
                    child: Hero(
                        tag: "logo",
                        child: Image.asset("assets/icons/balaji_new.png")),
                  ),
                  smallSpace(),
                  Text("Login",style: CommonDecoration.headerDecoration,),
                  largeSpace(),
                  MyTextFieldWithMobile(
                      textEditController: numberController,
                      filled: false,
                      textInputType: TextInputType.number,
                      label: "Mobile No.",
                      validate: true),
                  largeSpace(),
                  InkWell(
                      onTap: (){
                        if(_key.currentState!.validate()){
                         authenticationController.getOtp(phoneNumber: numberController.value.text);
                        }
                      },
                      child: MyRoundButton(text: "Login", bgColor: ColorConstants.themeColor))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
