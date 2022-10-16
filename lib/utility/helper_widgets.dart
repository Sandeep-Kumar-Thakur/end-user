import 'dart:developer';
import 'dart:io';

import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/key_contants.dart';
import '../controller/user_controller.dart';
import '../local_Storage/local_storage.dart';
import '../screens/cart.dart';
import '../screens/login/login_screen.dart';
import 'common_decoration.dart';
import 'my_button.dart';
import 'navigator_helper.dart';

Widget myPadding({required Widget child}) {
  return SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: child,
    ),
  );
}

myLog({required String label, required String value}) {
  log("$label------$value");
}

showMessage({required String msg}) {
  Get.showSnackbar(GetSnackBar(
    icon: Image.asset("assets/icons/balaji_new.png"),
    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    borderRadius: 10,
    title: "Bala Ji Mart",
    snackPosition: SnackPosition.TOP,
    backgroundColor: ColorConstants.themeColor.withOpacity(.7),
    duration: Duration(seconds: 3),
    message: msg,
  ));
}

openWhatsApp()async{
  Uri url = Uri.parse("whatsapp://send?phone=" +
      "${KeyConstants.whatsAppClient}" +
      "&text=" +
      "Hello Bala Ji");
  if (!await launchUrl(url)) {
  throw 'Could not launch';
  }
}

sendMail() async {
  // Android and iOS
  Uri uri =
      Uri.parse('mailto:${KeyConstants.companyEmail}?subject=Greetings&body=Hello Bala Ji');
  if (!await launchUrl(uri)) {
    throw 'Could not launch';
  }
}


Widget commonHeader({required String title,bool? showDrawer,bool? showCart}) {
  return Obx(
    () {
     log( UserController().stateController.cartCount.toString());
      return Container(
        padding: EdgeInsets.only(top: 15,bottom: 15,left: 15,right: 5),
        color: ColorConstants.themeColor,
        child: Row(
         
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: showDrawer==true?
                InkWell(
                  onTap: (){
                    UserController.key.currentState!.openDrawer();
                  },
                  child: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                ):SizedBox(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: CommonDecoration.headerDecoration
                        .copyWith(color: Colors.white),
                  )),
            ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: (){
                       openWhatsApp();
                      },
                      child: Icon(Icons.whatsapp,color: Colors.green  ,)),
                  SizedBox(width: 5,),
                  showCart==true?  InkWell(
                      onTap: () {
                        if(UserController().stateController.cartCount.value == 0){
                          showMessage(msg: "Cart is empty");
                          return;
                        }
                        goTo(className: CartScreen());
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10,top: 5),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.white,
                                    width: 1
                                ),
                                color: ColorConstants.themeColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(UserController().stateController.cartCount.toString(),style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.w600
                            ),),
                          )
                        ],
                      )):SizedBox()
                ],
              ),
            ),
          ),

          ],
        ),
      );
    }
  );
}

logoutDialog(){
  return  showDialog(context: UserController.navigatorKey.currentContext!, builder:(context)=>AlertDialog(
    icon: Icon(Icons.power_settings_new,color: Colors.red,size: 40,),
    content: Text("Do you really want to logout?",textAlign: TextAlign.center,),
    actions: [
      Row(
        children: [
          Expanded(child: InkWell(
              onTap: (){
                LocalStorage().clearData();
                goOff(className: LoginScreen());
              },
              child: MyRoundButton(text: "Yes", bgColor: ColorConstants.themeColor))),
          SizedBox(width: 10,),
          Expanded(child: InkWell(
              onTap: (){
                hideLoader();
              },
              child: MyRoundButton(text: "No", bgColor: ColorConstants.themeColor))),
        ],
      )

    ],
  ));
}

exitDialog(){
  return  showDialog(context: UserController.navigatorKey.currentContext!, builder:(context)=>AlertDialog(
    icon: Icon(Icons.warning_amber_outlined,color: Colors.red,size: 60,),
    content: Text("Do you really want to exit?",textAlign: TextAlign.center,),
    actions: [
      Row(
        children: [
          Expanded(child: InkWell(
              onTap: (){
               exit(0);
              },
              child: MyRoundButton(text: "Yes", bgColor: ColorConstants.themeColor))),
          SizedBox(width: 10,),
          Expanded(child: InkWell(
              onTap: (){
                hideLoader();
              },
              child: MyRoundButton(text: "No", bgColor: ColorConstants.themeColor))),
        ],
      )

    ],
  ));
}


List<BoxShadow> myShadow = [
  BoxShadow(
    color: Colors.blue.withOpacity(0.2),
    spreadRadius: 2.0,
    blurRadius: 2.0,
    offset: Offset(1.0, 4.0), // changes position of shadow
  ),
];

List<BoxShadow> greyShadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(0.2),
    spreadRadius: 2.0,
    blurRadius: 2.0,
    offset: Offset(1.0, 4.0), // changes position of shadow
  ),
];

Widget greyLine({bool? showSpace}) {
  return Column(
    children: [
   showSpace==false?SizedBox() :smallSpace(),
      Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey.withOpacity(.2),
      ),
      showSpace==false?SizedBox() :smallSpace(),

    ],
  );
}

Widget myImage({required String source, required bool fromUrl}) {
  return fromUrl
      ? FancyShimmerImage(
    imageUrl: source,
    shimmerBaseColor: Colors.grey.withOpacity(.3),
    shimmerHighlightColor: Colors.white,
    // shimmerBackColor: dataDefault[i].shimmerBackColor,
    errorWidget: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png"),
  )
      : Image.file(File(source), fit: BoxFit.cover);
}

showLoader() {
  showDialog(
      context: UserController.navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Center(
              child: CircularProgressIndicator(),
            ),
          ));
}

hideLoader() {
  Navigator.pop(UserController.navigatorKey.currentContext!);
}

smallSpace() {
  return SizedBox(
    height: 10,
  );
}

mediumSpcae() {
  return SizedBox(
    height: 20,
  );
}

largeSpace() {
  return SizedBox(
    height: 30,
  );
}
