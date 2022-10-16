
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';

goTo({required Widget className}){
  // log("/"+className.toString());
  // log(ModalRoute.of(UserController.navigatorKey.currentContext!)?.settings.name??"not found");
  // if(("/"+className.toString())==Get.currentRoute.toString()){
  //   print("find");
  // }

 Navigator.push(UserController.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>className));
}

goOff({required Widget className}){
 // log("/"+className.toString());
 // log(ModalRoute.of(UserController.navigatorKey.currentContext!)?.settings.name??"not found");
 // if(("/"+className.toString())==Get.currentRoute.toString()){
 //   print("find");
 // }

 Navigator.pushReplacement(UserController.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>className));
}

// goOff({required Widget className}){
//  // log("/"+className.toString());
//  // log(ModalRoute.of(UserController.navigatorKey.currentContext!)?.settings.name??"not found");
//  // if(("/"+className.toString())==Get.currentRoute.toString()){
//  //   print("find");
//  // }
//
//  Navigator.pushReplacement(UserController.navigatorKey.currentContext!, MaterialPageRoute(builder: (context)=>className));
// }