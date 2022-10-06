
import 'package:get/get.dart';

class StateController extends GetxController {
  RxList categoryList = [].obs;
  var cartCount = 0.obs;

  void updateCart({required int cartLength}){
    cartCount.value =cartLength;
    update();
  }

}