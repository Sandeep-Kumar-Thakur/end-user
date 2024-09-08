import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/screens/category/item_details.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/category_model.dart';

class ItemsScreen extends StatelessWidget {
  List<ProductDetailsModel> productList;

  ItemsScreen({Key? key, required this.productList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonHeader(title: "Product List"),
            Expanded(
                  child: SingleChildScrollView(
                    child:productList.length.isEqual(0)?Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset("assets/icons/research.png"),
                        ),
                        Text("Oops! Sorry No Data Found",style: CommonDecoration.headerDecoration,),
                      ],
                    ): GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: productList.length,
                      addRepaintBoundaries: false,
                      addAutomaticKeepAlives: false,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 220,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            goTo(
                                className: ItemDetails(
                                    productList:productList,
                                    productDetailsModel: productList[index]));
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(.3)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        boxShadow: greyShadow,
                                        borderRadius: BorderRadius.circular(100)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: myImage(
                                            source: productList[index].productImage ??
                                                "",
                                            fromUrl: true)),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${productList[index].productName
                                        ?.capitalize ??
                                        ""}, ${productList[index].quantityAndPrice?.last.quantity ?? ""}",
                                    style: CommonDecoration.itemName
                                        .copyWith(color: ColorConstants.themeColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  if(productList[index].productGrade!="")
                                    Text(
                                      "Grade : ${productList[index].productGrade?.capitalize ?? ""}",
                                      style: CommonDecoration.descriptionDecoration,
                                      textAlign: TextAlign.center,
                                    ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          addToCart(productDetailsModel: productList[index]);
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: ColorConstants.themeColor,
                                            ),
                                            child: Row(
                                              children: [
                                                Text("Add To ",style: CommonDecoration.itemName.copyWith(color: Colors.white),),
                                                Icon(Icons.shopping_cart_outlined,color: Colors.white,size: 20,)
                                              ],
                                            )
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "₹ ${productList[index].quantityAndPrice?.last.price ?? ""}",
                                        style: CommonDecoration.listItem
                                            .copyWith(color: Colors.green),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  )),

          ],
        ),
      ),
    );
  }
}
