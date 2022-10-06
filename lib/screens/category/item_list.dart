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
              child: myPadding(
                  child: Column(
                children: [
                  
                  SingleChildScrollView(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: productList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 230,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            goTo(
                                className: ItemDetails(
                                    productDetailsModel: productList[index]));
                          },
                          child: Container(
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.withOpacity(.05)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(

                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          boxShadow: greyShadow,
                                          borderRadius: BorderRadius.circular(100)),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: myImage(
                                              source:
                                                  productList[index].productImage ??
                                                      "",
                                              fromUrl: true)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    productList[index].productName?.capitalize ?? "",
                                    style: CommonDecoration.listItem
                                        .copyWith(color: ColorConstants.themeColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Grade : ${productList[index].productGrade?.capitalize ?? ""}",
                                    style: CommonDecoration.descriptionDecoration,
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Price : ₹ ${productList[index].quantityAndPrice?.last.price ?? ""} - ${productList[index].quantityAndPrice?.last.quantity ?? ""}",
                                    style: CommonDecoration.listItem.copyWith(color:Colors.green),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              )),
                        );
                      },
                    ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
