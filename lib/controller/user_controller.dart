
import 'package:bala_ji_mart/controller/state_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController{
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
  static GlobalKey<ScaffoldState> key = GlobalKey();
  final stateController = Get.put(StateController());


}