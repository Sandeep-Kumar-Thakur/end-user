import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/store_cart_model.dart';

class OrderHistory extends StatelessWidget {
  List<StoreCartModel> cartList;
   OrderHistory({Key? key,required this.cartList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonHeader(title: "Order Details"),
            smallSpace(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: cartList.length,
                itemBuilder: (context,i){
                  return Container(
                    margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: greyShadow
                    ),
                    child: ExpansionTile(title: Row(

                      children: [
                        SizedBox(
                            width:50 ,
                            child: Image.asset("assets/icons/weight.png")),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total Pay : ₹ "+cartList[i].totalAmount.toString(),style: CommonDecoration.descriptionDecoration),
                            Text("Items : "+cartList[i].cartItem!.length.toString(),style: CommonDecoration.descriptionDecoration),
                            Text(DateFormat("dd, MMM yyyy ").add_jm().format(DateTime.parse(cartList[i].dateTime??"")),style: CommonDecoration.descriptionDecoration,),
                            Text("Status : ${cartList[i].confirm}",style: CommonDecoration.descriptionDecoration.copyWith(color: Colors.green),)

                          ],
                        ),
                      ],
                    ),children: [
                      ListView.builder(
                           shrinkWrap: true,
                            itemCount: cartList[i].cartItem?.length??0,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context,j){
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              boxShadow: greyShadow
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Item Name : ${cartList[i].cartItem![j].itemName}-${cartList[i].cartItem![j].itemGrade}"??""),
                                Text("Item Quantity : ${cartList[i].cartItem![j].itemQuantity} x ${cartList[i].cartItem![j].itemCount}"),
                                Text("Item Total Price : ₹ ${cartList[i].cartItem![j].itemTotal}"),
                              ],
                            ),
                          );
                        }),

                    ],),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
