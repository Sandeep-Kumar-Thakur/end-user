import 'dart:async';

import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/screens/category/home_screen.dart';
import 'package:bala_ji_mart/screens/login/login_screen.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}



class _SplashState extends State<Splash> {

  @override
  void initState() {
   userCheck();
    // TODO: implement initState
    super.initState();
  }

  void userCheck(){
    var data = LocalStorage().readUserModel();
    myLog(label: "user data", value: data.toJson().toString());
    Timer(Duration(seconds: 3), () {
      UserModel userModel = data;
      if(userModel.uid==null){
        goOff(className: LoginScreen());
      }else{
        goOff(className: HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
           body: Center(
             child:  Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Expanded(
                     flex: 3,
                     child: Hero(
                         tag: "logo",
                         child: Image.asset("assets/icons/balaji_new.png"))),
                 Expanded(
                     flex: 4,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("BALA JI MART",style: CommonDecoration.headerDecoration.copyWith(color: ColorConstants.themeColor,fontSize: 25,fontWeight: FontWeight.w700),),
                         Text("Apni Dukaan",style: CommonDecoration.headerDecoration.copyWith(color: ColorConstants.themeColor,fontWeight: FontWeight.w600,fontSize: 18),),
                       ],
                     ))
               ],
             ),
           ),
    );
  }
}
