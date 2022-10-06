import 'package:bala_ji_mart/constants/key_contants.dart';
import 'package:bala_ji_mart/controller/user_controller.dart';
import 'package:bala_ji_mart/model/store_cart_model.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorage{

  final storage  = GetStorage();

  write({required String key,required String value}){
    storage.write(key, value);
  }

  writeUserModel({required UserModel userModel}){
    storage.write(KeyConstants.userModel, userModel.toJson());
  }

  readUserModel(){
    UserModel userModel = UserModel();
    var data = storage.read(KeyConstants.userModel);
    if(data!=null){
       userModel = UserModel.fromJson(data);
    }


    return userModel;
  }

  writeUserCart({required StoreCartModel storeCartModel}){
    storage.write(KeyConstants.userCarts, storeCartModel.toJson());
    UserController().stateController.updateCart(cartLength: storeCartModel.cartItem?.length??0);
    myLog(label: "cart", value: storeCartModel.toJson().toString());
  }

  readUserCart(){
    StoreCartModel storeCartModel = StoreCartModel(totalAmount: 0, totalItem: 0, deliveryCharge: 0);
   var data = storage.read(KeyConstants.userCarts);
   if(data!=null){
     storeCartModel = StoreCartModel.fromJson(storage.read(KeyConstants.userCarts));
   }
    UserController().stateController.updateCart(cartLength: storeCartModel.cartItem?.length??0);
    return storeCartModel;
  }

  clearData(){
    storage.erase();
  }

}