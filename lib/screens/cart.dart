import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/model/store_cart_model.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color_constants.dart';
import '../local_Storage/local_storage.dart';
import '../utility/common_decoration.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreCartModel storeCartModel = LocalStorage().readUserCart();

  @override
  void dispose() {

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    storeCartModel.totalAmount = 0;
    storeCartModel.deliveryCharge = 0;
    storeCartModel.userModel = LocalStorage().readUserModel();
    for(int i=0;i<storeCartModel.cartItem!.length;i++){
      storeCartModel.totalAmount = storeCartModel.totalAmount+int.parse(storeCartModel.cartItem![i].itemTotal.toString());
      storeCartModel.deliveryCharge = storeCartModel.deliveryCharge + (int.parse(storeCartModel.cartItem![i].itemCount.toString())*6);
    }

     // LocalStorage().writeUserCart(storeCartModel: storeCartModel);



    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            color: ColorConstants.themeColor,
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "My Cart",
                  style: CommonDecoration.headerDecoration
                      .copyWith(color: Colors.white),
                )),
          ),
          Expanded(
              child: storeCartModel.cartItem!.length.isEqual(0)
                  ? Center(child: Text("No Data"))
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      itemCount: storeCartModel.cartItem!.length+1 ?? 0,
                      itemBuilder: (context, i) {
                        return storeCartModel.cartItem!.length==i?_details():_item(i);
                      })),
          _orderButton()
        ],
      )),
    );
  }

  Widget _orderButton(){
    return Container(
      height: 70,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15),
      color: ColorConstants.themeColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Pay Amount",style: CommonDecoration.headerDecoration.copyWith(color: Colors.white),),
              Text("₹ ${storeCartModel.totalAmount+storeCartModel.deliveryCharge}",style: CommonDecoration.subHeaderDecoration.copyWith(color: Colors.white),)
            ],
          ),
          InkWell(
            onTap: (){
              storeCartModel.dateTime = DateTime.now().toString();
              storeCartModel.confirm = "Pending";
              storeCartModel.totalAmount = storeCartModel.totalAmount+storeCartModel.deliveryCharge;

              FirebaseRealTimeStorage().order(storeCartModel: storeCartModel);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 25),
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: greyShadow
              ),
              child: Text("Place Order",style: CommonDecoration.listItem.copyWith(color: Colors.blue),),
            ),
          )
        ],
      ),
    );
  }

  Widget _details(){
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child:  Row(
            children: [
              Icon(Icons.delivery_dining_rounded,size: 20,color: Colors.grey,),
              SizedBox(width: 10,),
              Text("Delivery Charges : ₹ ${storeCartModel.deliveryCharge??""}",style: CommonDecoration.productDescriptionDecoration,),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person_outline,size: 20,color: Colors.grey,),
                  SizedBox(width: 10,),
                  Text("${storeCartModel.userModel?.name??""}".capitalize??"",style: CommonDecoration.productDescriptionDecoration,),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone,size: 20,color: Colors.grey,),
                  SizedBox(width: 10,),

                  Text("${storeCartModel.userModel?.number??""}".capitalize??"",style: CommonDecoration.productDescriptionDecoration,),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.email_outlined,size: 20,color: Colors.grey,),
                  SizedBox(width: 10,),

                  Text("${storeCartModel.userModel?.gmail??""}"??"",style: CommonDecoration.productDescriptionDecoration,),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.location_on,size: 20,color: Colors.grey,),
                  SizedBox(width: 10,),

                  Text("Address : ${storeCartModel.userModel?.location??""}"??"",style: CommonDecoration.productDescriptionDecoration,),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _item(i){
    return Container(
      padding: EdgeInsets.all(10),
      margin:
      EdgeInsets.only(bottom: 10, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          //   boxShadow: greyShadow,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SizedBox(
              height: 90,
              width: 70,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: myImage(
                      source: storeCartModel
                          .cartItem![i].image ??
                          "",
                      fromUrl: true))),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storeCartModel.cartItem![i].itemName ?? "",
                style: CommonDecoration.listItem,
              ),
              smallSpace(),
              Text(
                "Grade : ${storeCartModel.cartItem![i].itemGrade}" ??
                    "",
                style: CommonDecoration
                    .productDescriptionDecoration,
              ),
              Text(
                "Price : ₹${storeCartModel.cartItem![i].itemPrice}" ??
                    "",
                style: CommonDecoration
                    .productDescriptionDecoration,
              ),
              Text(
                "Quantity : ${storeCartModel.cartItem![i].itemQuantity}" ??
                    "",
                style: CommonDecoration
                    .productDescriptionDecoration,
              ),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  InkWell(
                      onTap: () {
                        int temp = int.parse(storeCartModel
                            .cartItem![i].itemCount ??
                            "0");
                        int tempPrice = int.parse(
                            storeCartModel.cartItem![i]
                                .itemPrice ??
                                "0");
                        temp++;
                        storeCartModel.cartItem![i]
                            .itemCount = temp.toString();
                        storeCartModel
                            .cartItem![i].itemTotal =
                            (temp * tempPrice).toString();
                        LocalStorage().writeUserCart(storeCartModel: storeCartModel);
                        setState(() {});
                      },
                      child: addButton()),
                  SizedBox(
                    width: 3,
                  ),
                  SizedBox(
                    width: 20,
                    child: Text(
                      "${storeCartModel.cartItem![i].itemCount}" ??
                          "",
                      textAlign: TextAlign.center,
                      style: CommonDecoration
                          .productDescriptionDecoration,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  InkWell(
                      onTap: () {
                        int temp = int.parse(storeCartModel
                            .cartItem![i].itemCount ??
                            "0");
                        if (temp == 1) {
                          storeCartModel.cartItem!
                              .removeAt(i);
                          setState(() {});
                          return;
                        }
                        int tempPrice = int.parse(
                            storeCartModel.cartItem![i]
                                .itemPrice ??
                                "0");
                        temp--;
                        storeCartModel.cartItem![i]
                            .itemCount = temp.toString();
                        storeCartModel
                            .cartItem![i].itemTotal =
                            (temp * tempPrice).toString();
                        LocalStorage().writeUserCart(storeCartModel: storeCartModel);
                        setState(() {});
                      },
                      child: minusButton()),
                ],
              ),
              smallSpace(),
              Text(
                "₹${storeCartModel.cartItem![i].itemTotal}" ??
                    "",
                style: CommonDecoration.listItem,
              ),
              smallSpace(),
              InkWell(
                onTap: () {
                  storeCartModel.cartItem!.removeAt(i);
                  LocalStorage().writeUserCart(storeCartModel: storeCartModel);
                  setState(() {});
                },
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.2),
                        borderRadius:
                        BorderRadius.circular(10)),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                    )),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget minusButton() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: greyShadow,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.remove,
          size: 18,
          color: Colors.white,
        ));
  }

  Widget addButton() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: greyShadow,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.add,
          size: 18,
          color: Colors.white,
        ));
  }
}
