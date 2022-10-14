import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/store_cart_model.dart';
import 'package:bala_ji_mart/screens/cart.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';
import '../../model/category_model.dart';
import '../../model/user_model.dart';

class ItemDetails extends StatefulWidget {
  ProductDetailsModel productDetailsModel;

  ItemDetails({Key? key, required this.productDetailsModel}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int selectedVariety = 0;
  PageController pageController =PageController();

  void addToCart() {
    UserModel userModel = LocalStorage().readUserModel();
    StoreCartModel model =
        StoreCartModel(deliveryCharge: 0, totalAmount: 0, totalItem: 0);
    model = LocalStorage().readUserCart();
    model.userModel = userModel;
    if (model.cartItem == null) {
      model.cartItem = [];
    }
    model.userModel = userModel;
    model.totalAmount = model.totalAmount +
        int.parse(widget
            .productDetailsModel.quantityAndPrice![selectedVariety].price!);
    model.totalItem = model.totalItem + 1;
    model.deliveryCharge = model.deliveryCharge + 6;
    CartItem cartItem = CartItem(
        itemCount: "1",
        image: widget.productDetailsModel.productImage,
        itemGrade: widget.productDetailsModel.productGrade,
        itemName: widget.productDetailsModel.productName,
        itemPrice:
            widget.productDetailsModel.quantityAndPrice![selectedVariety].price,
        itemQuantity: widget
            .productDetailsModel.quantityAndPrice![selectedVariety].quantity,
        itemTotal: widget
            .productDetailsModel.quantityAndPrice![selectedVariety].price);
    for (int i = 0; i < model.cartItem!.length; i++) {
      if (model.cartItem![i].itemName == cartItem.itemName &&
          model.cartItem![i].itemGrade == cartItem.itemGrade &&
          model.cartItem![i].itemQuantity == cartItem.itemQuantity &&
          model.cartItem![i].itemPrice == cartItem.itemPrice) {
        model.cartItem![i].itemCount = (int.parse(model.cartItem![i].itemCount??"0")+1).toString();
        model.cartItem![i].itemTotal = (int.parse(model.cartItem![i].itemTotal??"0")+int.parse(model.cartItem![i].itemPrice??"0")).toString();

        showMessage(msg: "Increase Count");
        LocalStorage().writeUserCart(storeCartModel: model);
        return;
      }
    }
    model.cartItem!.add(cartItem);
    LocalStorage().writeUserCart(storeCartModel: model);
    showMessage(msg: "Added To Cart");
  }

  double pageCount = 0;

  @override
  void initState() {
    pageController.addListener(() {
      pageCount = pageController.page!;
      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonHeader(title: widget.productDetailsModel.productName!.capitalize??""),
            Expanded(
                flex: 1,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView(
                      controller: pageController,
                      children: [
                        Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: myImage(
                                source:
                                widget.productDetailsModel.productImage ?? "",
                                fromUrl: true)),
                        Container(
                            width: double.infinity,
                            color: Colors.white,
                            child: myImage(
                                source:
                                widget.productDetailsModel.productImage2 ?? "",
                                fromUrl: true)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.circle,size: 15,color: pageCount==0.0?ColorConstants.themeColor:Colors.grey),
                        SizedBox(width: 10,),
                        Icon(Icons.circle,size: 15,color: pageCount!=0.0?ColorConstants.themeColor:Colors.grey),
                      ],
                    )
                  ],
                )),
            Expanded(
              child: myPadding(
                  child: Column(
                children: [

                  Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              smallSpace(),
                              Text(
                                widget.productDetailsModel.productName!.capitalize ?? "",
                                style: CommonDecoration.subHeaderDecoration,
                              ),
                              Text(
                                "Price : ₹ ${widget.productDetailsModel.quantityAndPrice![selectedVariety].price} - ${widget.productDetailsModel.quantityAndPrice![selectedVariety].quantity}",
                                style: CommonDecoration
                                    .productDescriptionDecoration
                                    .copyWith(color: Colors.green),
                              ),
                              greyLine(),
                              Text(
                                "Quantity : ",
                                style: CommonDecoration
                                    .productDescriptionDecoration
                                    .copyWith(color: Colors.green),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Container(
                                  height: 40,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.productDetailsModel
                                              .quantityAndPrice?.length ??
                                          0,
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () {
                                            selectedVariety = i;
                                            setState(() {});
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(10),
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: selectedVariety != i
                                                      ? ColorConstants.themeColor
                                                      : Colors.white,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: selectedVariety == i
                                                    ? ColorConstants.themeColor
                                                    : Colors.white,
                                              ),
                                              child: Text(
                                                widget
                                                        .productDetailsModel
                                                        .quantityAndPrice![i]
                                                        .quantity ??
                                                    "",
                                                style: CommonDecoration
                                                    .descriptionDecoration
                                                    .copyWith(
                                                  color: selectedVariety != i
                                                      ? ColorConstants.themeColor
                                                      : Colors.white,
                                                ),
                                              )),
                                        );
                                      })),
                              greyLine(),
                              smallSpace(),
                              Text(
                                "Grade : ${widget.productDetailsModel.productGrade}",
                                style:
                                    CommonDecoration.productDescriptionDecoration,
                              ),
                              Text(
                                "Description : ${widget.productDetailsModel.productDescription}",
                                style:
                                    CommonDecoration.productDescriptionDecoration,
                              ),
                              greyLine(),

                              // Text("Slab : ",style: CommonDecoration.subHeaderDecoration,)
                            ],
                          ),
                        ),
                      ))
                ],
              )),
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  onTap: () {
                    if(UserController().stateController.cartCount.value == 0){
                      showMessage(msg: "Cart is empty");
                      return;
                    }
                    goTo(className: CartScreen());
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: Text(
                      "GO TO CART",
                      style: CommonDecoration.listItem
                          .copyWith(color: Colors.white),
                    ),
                  ),
                )),
                Expanded(
                    child: InkWell(
                  onTap: () => addToCart(),
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Text(
                      "ADD TO CART",
                      style: CommonDecoration.listItem
                          .copyWith(color: Colors.white),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
