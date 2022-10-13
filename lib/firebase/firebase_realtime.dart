import 'dart:convert';
import 'dart:developer';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/store_cart_model.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/screens/category/home_screen.dart';
import 'package:bala_ji_mart/screens/order_history.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:firebase_database/firebase_database.dart';
import '../constants/key_contants.dart';
import '../controller/user_controller.dart';
import '../model/banner_model.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../screens/order_successfull.dart';
import '../utility/helper_widgets.dart';
import 'package:http/http.dart' as http;

class FirebaseRealTimeStorage {
  final fireBaseRealTime = FirebaseDatabase.instance;


  ///----------- banner ------------------
  Future getAllBanner()async{
    List<BannerModel> bannerList = [];
    var data = await fireBaseRealTime.ref(KeyConstants.banner).get();
    if(data.value==null){
      return [];
    }
    Map tempData = jsonDecode(jsonEncode(data.value));
    tempData.forEach((key, value) {
      BannerModel bannerModel = BannerModel.fromJson(value);
      bannerList.add(bannerModel);
    });
   return bannerList;
  }

  ///-----------add cart-----------------------------

  // Future addToCart({required StoreCartModel storeCartModel})async{
  //   showLoader();
  //   fireBaseRealTime.ref(KeyConstants.userCarts).child(storeCartModel.userModel?.uid??"").update(storeCartModel.toJson()).then((value) {
  //     hideLoader();
  //   });
  // }

  ///--------------------order details -----------------------------

  Future getOrder() async {
    showLoader();
    UserModel userModel = LocalStorage().readUserModel();
    try{
      List<StoreCartModel> cartList = [];
     var data =await fireBaseRealTime.ref(KeyConstants.orderReceived).child(userModel.uid??"").get();
     Map tempData = jsonDecode(jsonEncode(data.value));
     tempData.forEach((key, value) {
       StoreCartModel storeCartModel =StoreCartModel.fromJson(value);
       cartList.add(storeCartModel);
     });
     cartList.sort((a, b) {
       return b.dateTime!.compareTo(a.dateTime!);
     } );
   hideLoader();
   goTo(className: OrderHistory(cartList: cartList));
    }catch(e){
      hideLoader();

      showMessage(msg: "No Order History");
    }
  }

  Future order({required StoreCartModel storeCartModel}) async {
    showLoader();
    try{
      fireBaseRealTime
          .ref(KeyConstants.orderReceived)
          .child(storeCartModel.userModel?.uid ?? "")
          .child(DateTime.parse(storeCartModel.dateTime ?? "")
          .millisecondsSinceEpoch
          .toString())
          .update(storeCartModel.toJson())
          .then((value)async {
        var date = new DateTime.fromMicrosecondsSinceEpoch(DateTime.parse(storeCartModel.dateTime!).millisecondsSinceEpoch*1000);
        myLog(label: "mytime", value: date.toString());
        hideLoader();
        goOff(className: OrderSuccessfulScreen());
        storeCartModel.cartItem = [];
        LocalStorage().writeUserCart(storeCartModel: storeCartModel);
        var data = await fireBaseRealTime.ref(KeyConstants.adminToken).get();
        Map tempData = jsonDecode(jsonEncode(data.value));
        Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
        var header = {
        "Content-Type":"application/json",
        "Authorization":"key=AAAAWCdMLDs:APA91bHYSO-xZQMBS4d9aRQCgpLHd6QI6ebqr7AQqLDG338QniW_Uol_TL0WqjO5QdyQVOfDI9LGpFn1vTeWu4C5iO9qIOPGfnjsLnEONjEYfsAh_VNBZUIiBGUnCMhjF3VgiXlsrVDd"
        };

        var body = {
          "to": "${tempData.values.first}",
          "priority":"high",
          "notification": {
            "title": "Order Received From ${storeCartModel.userModel?.name??""}",
            "body": "Amount   ₹ ${storeCartModel.totalAmount.toString()}",
          //  "mutable_content": true,
            "sound": "Tri-tone"
          },

          "data": {
            "url": "<url of media image>",
            "dl": "<deeplink action on tap of notification>",
          }
        };
         http.post(uri,headers: header,body: jsonEncode(body));
      });
    }catch(e){
      showMessage(msg: e.toString());
    }
  }

  ///---------------------------user------------------------

  Future userDetails(UserModel userModel) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.userDetails)
        .child(userModel.uid ?? "")
        .update({
      KeyConstants.fcmToken: userModel.fcmToken,
      KeyConstants.number: userModel.number,
      KeyConstants.uid: userModel.uid
    }).then((value) async {
      var data = await fireBaseRealTime
          .ref(KeyConstants.userDetails)
          .child(userModel.uid ?? "")
          .get();
      UserModel myUserModel =
          UserModel.fromJson(jsonDecode(jsonEncode(data.value)));
      LocalStorage().writeUserModel(userModel: myUserModel);
    });
    myLog(label: "done", value: "done");
    hideLoader();
    return true;
  }

  Future updateUserDetails(UserModel userModel) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.userDetails)
        .child(userModel.uid ?? "")
        .update(userModel.toJson())
        .then((value) async {
      var data = await fireBaseRealTime
          .ref(KeyConstants.userDetails)
          .child(userModel.uid ?? "")
          .get();
      UserModel myUserModel =
          UserModel.fromJson(jsonDecode(jsonEncode(data.value)));
      LocalStorage().writeUserModel(userModel: myUserModel);
    });
    myLog(label: "update", value: "done");
    hideLoader();
    return true;
  }

  ///-------------------category--------------------------------------------------------
  Future addCategory(CategoryModel categoryModel) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryModel.name ?? "")
        .update(categoryModel.toJson())
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
      showMessage(msg: "${categoryModel.name} Added into Category");
    }).onError((error, stackTrace) {
      hideLoader();
      showMessage(msg: error.toString());
    });
  }

  Future getAllCategoryList({bool? navigate, bool? loader}) async {
    if (loader != false) showLoader();
    List<CategoryModel> categoryList = [];
    final category = FirebaseDatabase.instance.ref(KeyConstants.category);
    var temp = await category.get();
    if (loader != false) hideLoader();
    try {
      Map<String, dynamic> data = jsonDecode(jsonEncode(temp.value));
      data.forEach((key, value) {
        CategoryModel categoryModel = CategoryModel.fromJson(value);

        if (categoryModel.tempList != null) {
          Map<String, dynamic> tempList =
              jsonDecode(jsonEncode(categoryModel.tempList));
          tempList.forEach((key, value) {
            log(jsonEncode(value));
            ProductDetailsModel productDetailsModel =
                ProductDetailsModel.fromJson(value);
            categoryModel.productList!.add(productDetailsModel);
          });
        }
        categoryList.add(categoryModel);
      });
      log(categoryList.toList().toString());
      categoryList.sort((a, b) {
        return a.name!.toUpperCase().compareTo(b.name!.toUpperCase());
      });

      UserController().stateController.categoryList.value = categoryList;

      if (navigate != false) {
        goOff(className: HomeScreen());
      }
    } catch (e) {
      UserController().stateController.categoryList.value = [];
      if (navigate != false) {
        //goTo(className: CategoryList());
      }
    }
  }

  Future deleteCategory({required String id}) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(id)
        .remove()
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
    });
  }

  ///-------------------product------------------------------

  Future addProduct(
      {required ProductModel productModel,
      required String categoryName}) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryName)
        .child(KeyConstants.categoryItems)
        .child(productModel.productName ?? '')
        .update(productModel.toJson())
        .then((value) {
      hideLoader();
      showMessage(msg: "Add item into $categoryName");
      getAllCategoryList(navigate: false);
    }).onError((error, stackTrace) {
      hideLoader();
      showMessage(msg: error.toString());
    });
    ;
  }

  Future deleteProduct(
      {required String categoryId, required String productId}) async {
    showLoader();
    fireBaseRealTime
        .ref(KeyConstants.category)
        .child(categoryId)
        .child(KeyConstants.categoryItems)
        .child(productId)
        .remove()
        .then((value) {
      hideLoader();
      getAllCategoryList(navigate: false);
    });
  }
}
