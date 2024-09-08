
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/color_constants.dart';
import '../../controller/user_controller.dart';
import '../../model/category_model.dart';
import '../../model/user_model.dart';
import '../../utility/common_decoration.dart';
import '../../utility/helper_widgets.dart';
import '../../utility/navigator_helper.dart';
import '../cart.dart';

class ItemDetails extends StatefulWidget {
  ProductDetailsModel productDetailsModel;
  List<ProductDetailsModel> productList;

  ItemDetails({Key? key, required this.productDetailsModel,required this.productList}) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int selectedVariety = 0;
  PageController pageController =PageController();

  // void addToCart() {
  //   UserModel userModel = LocalStorage().readUserModel();
  //   StoreCartModel model =
  //       StoreCartModel(deliveryCharge: 0, totalAmount: 0, totalItem: 0);
  //   model = LocalStorage().readUserCart();
  //   model.userModel = userModel;
  //   if (model.cartItem == null) {
  //     model.cartItem = [];
  //   }
  //   model.userModel = userModel;
  //   model.totalAmount = model.totalAmount +
  //       int.parse(widget
  //           .productDetailsModel.quantityAndPrice![selectedVariety].price!);
  //   model.totalItem = model.totalItem + 1;
  //   model.deliveryCharge = model.deliveryCharge + 6;
  //   CartItem cartItem = CartItem(
  //       itemCount: "1",
  //       image: widget.productDetailsModel.productImage,
  //       itemGrade: widget.productDetailsModel.productGrade,
  //       itemName: widget.productDetailsModel.productName,
  //       itemPrice:
  //           widget.productDetailsModel.quantityAndPrice![selectedVariety].price,
  //       itemQuantity: widget
  //           .productDetailsModel.quantityAndPrice![selectedVariety].quantity,
  //       itemTotal: widget
  //           .productDetailsModel.quantityAndPrice![selectedVariety].price);
  //   for (int i = 0; i < model.cartItem!.length; i++) {
  //     if (model.cartItem![i].itemName == cartItem.itemName &&
  //         model.cartItem![i].itemGrade == cartItem.itemGrade &&
  //         model.cartItem![i].itemQuantity == cartItem.itemQuantity &&
  //         model.cartItem![i].itemPrice == cartItem.itemPrice) {
  //       model.cartItem![i].itemCount = (int.parse(model.cartItem![i].itemCount??"0")+1).toString();
  //       model.cartItem![i].itemTotal = (int.parse(model.cartItem![i].itemTotal??"0")+int.parse(model.cartItem![i].itemPrice??"0")).toString();
  //
  //       showMessage(msg: "Increase Count");
  //       LocalStorage().writeUserCart(storeCartModel: model);
  //       return;
  //     }
  //   }
  //   model.cartItem!.add(cartItem);
  //   LocalStorage().writeUserCart(storeCartModel: model);
  //   showMessage(msg: "Added To Cart");
  // }

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
    List<ProductDetailsModel> screenProductList=[];
    screenProductList.addAll(widget.productList);
    screenProductList.remove(widget.productDetailsModel);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonHeader(title: widget.productDetailsModel.productName!.capitalize??""),
            SizedBox(height:5,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    SizedBox(
                      height: Get.height*0.35,
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
                          Container(
                            margin: EdgeInsets.only(bottom: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.circle,size: 15,color: pageCount==0.0?ColorConstants.themeColor:Colors.grey),
                                SizedBox(width: 10,),
                                Icon(Icons.circle,size: 15,color: pageCount!=0.0?ColorConstants.themeColor:Colors.grey),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    myPadding(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.productDetailsModel.productName!.capitalize ?? ""}, ${widget.productDetailsModel.quantityAndPrice![selectedVariety].quantity}",
                                      style: CommonDecoration.listItem,
                                    ),
                                    Text(
                                      "₹ ${widget.productDetailsModel.quantityAndPrice![selectedVariety].price}",
                                      style: CommonDecoration
                                          .subHeaderDecoration
                                          .copyWith(color: Colors.green),
                                    ),
                                    if(widget.productDetailsModel.quantityAndPrice!.length!=1)
                                      _quantity(),
                                    smallSpace(),
                                    if(widget.productDetailsModel.productGrade!="")
                                      Text(
                                        "Grade : ${widget.productDetailsModel.productGrade}",
                                        style:
                                        CommonDecoration.descriptionDecoration,
                                      ),
                                    if(widget.productDetailsModel.productDescription!="")
                                      Text(
                                        "Description : ${widget.productDetailsModel.productDescription}",
                                        style:
                                        CommonDecoration.descriptionDecoration,
                                      ),
                                    greyLine(),

                                    // Text("Slab : ",style: CommonDecoration.subHeaderDecoration,)
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: greyShadow
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: ColorConstants.themeColor,
                                            ),
                                            child: Text("₹",style: TextStyle(
                                                color: Colors.white
                                            ),)),
                                        Text("Cash On Delivery",style: CommonDecoration.descriptionDecoration.copyWith(color: ColorConstants.themeColor),)
                                      ],
                                    ))),
                                SizedBox(width: 10,),
                                Expanded(child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: greyShadow
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            height: 30,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: ColorConstants.themeColor,
                                            ),
                                            child: Icon(Icons.access_time_outlined,color: Colors.white,)),
                                        Text("Delivery On Time",style: CommonDecoration.descriptionDecoration.copyWith(color: ColorConstants.themeColor),)
                                      ],
                                    ))),
                              ],
                            ),

                          ],
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("  Related Products",style: CommonDecoration.subHeaderDecoration,)),
                    widget.productList.length.isEqual(0)? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Image.asset("assets/icons/research.png"),
                        ),
                        Text("Oops! Sorry No Data Found",style: CommonDecoration.headerDecoration,),
                      ],
                    ):GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: screenProductList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 220,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            goTo(
                                className: ItemDetails(
                                    productList: widget.productList,
                                    productDetailsModel: screenProductList[index]));
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
                                            source: screenProductList[index].productImage ??
                                                "",
                                            fromUrl: true)),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${screenProductList[index].productName
                                        ?.capitalize ??
                                        ""}, ${screenProductList[index].quantityAndPrice?.last.quantity ?? ""}",
                                    style: CommonDecoration.itemName
                                        .copyWith(color: ColorConstants.themeColor),
                                    textAlign: TextAlign.center,
                                  ),
                                  Spacer(),
                                  if(screenProductList[index].productGrade!="")
                                    Text(
                                      "Grade : ${screenProductList[index].productGrade?.capitalize ?? ""}",
                                      style: CommonDecoration.descriptionDecoration,
                                      textAlign: TextAlign.center,
                                    ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          addToCart(productDetailsModel: screenProductList[index]);
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
                                        "₹ ${screenProductList[index].quantityAndPrice?.last.price ?? ""}",
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
                    )

                  ],
                ),
              ),
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
                      onTap: () => addToCartFromIndex(productDetailsModel: widget.productDetailsModel, index: selectedVariety),
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

  _quantity(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

}
