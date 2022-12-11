import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/constants/key_contants.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/screens/account/personal_information.dart';
import 'package:bala_ji_mart/screens/category/item_details.dart';
import 'package:bala_ji_mart/screens/category/item_list.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/my_button.dart';
import 'package:bala_ji_mart/utility/my_text_field.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/user_controller.dart';
import '../../model/banner_model.dart';
import '../../model/category_model.dart';
import '../../utility/my_drawer.dart';
import '../login/login_screen.dart';
import '../terms_and_conditions.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin
    implements WidgetsBindingObserver {
  List<CategoryModel> categoryList = [];
  bool isHome = true;

  late Animation<double> animation;
  late AnimationController controller;

  final searchController = TextEditingController();

  List<ProductDetailsModel> productListAll = [];
  List<ProductDetailsModel> productListSearch = [];
  bool isSearch = false;
  List<BannerModel> bannerList = [];

  BannerModel hotItems = BannerModel();

  CarouselController carouselController = CarouselController();

  int bannerCurrentPage = 0;

  getBanner() async {
    bannerList = await FirebaseRealTimeStorage().getAllBanner();
    setState(() {});
  }

  getHotItems() async {
    FirebaseRealTimeStorage().getHotItems().then((value) {
      hotItems = value;
      setState(() {});
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getBanner();
    getHotItems();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    FirebaseRealTimeStorage()
        .getAllCategoryList(navigate: false, loader: false);

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    LocalStorage().readUserCart();
    return WillPopScope(
      onWillPop: () {
        if (isHome) {
          exitDialog();
          return Future.value(false);
        } else {
          isHome = true;
          setState(() {});
          return Future.value(false);
        }
      },
      child: Scaffold(
        key: UserController.key,
        drawer: MyDrawer(),
        bottomNavigationBar: _bottomAppBar(),
        floatingActionButton: _floatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: SafeArea(
          child: Column(
            children: [
              commonHeader(
                  title: "Bala Ji Mart", showDrawer: true, showCart: true),
              Expanded(
                child: isHome ? _home() : _account(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _home() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 7,
          ),
          if (bannerList.length > 0)
            Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: 7),
              width: double.infinity,
              child: CarouselSlider.builder(
                carouselController: carouselController,
                  itemCount: bannerList.length,
                  itemBuilder: (context, i, j) {
                    return InkWell(
                      onTap: () {
                        goTo(
                            className: ItemsScreen(
                                productList: bannerList[i].productList!));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: myImage(
                                source: bannerList[i].image ?? "",
                                fromUrl: true)),
                      ),
                    );
                  },

                  options:
                      CarouselOptions(viewportFraction: 1, autoPlay: true,onPageChanged: (v,r){
                        bannerCurrentPage = v;
                        setState(() {

                        });
                      })),
            ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                height: 5,
                width:bannerCurrentPage==0?20: 5,
                duration: Duration(milliseconds: 800),
                decoration: BoxDecoration(
                  color: ColorConstants.themeColor,
                  borderRadius: BorderRadius.circular(30)
                ),
              ),
              SizedBox(width: 5,),
              AnimatedContainer(
                height: 5,
                width:bannerCurrentPage==1?20: 5,
                duration: Duration(milliseconds: 800),
                decoration: BoxDecoration(
                    color: ColorConstants.themeColor,
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
              SizedBox(width: 5,),

              AnimatedContainer(
                height: 5,
                width:bannerCurrentPage==2?20: 5,
                duration: Duration(milliseconds: 800),
                decoration: BoxDecoration(
                    color: ColorConstants.themeColor,
                    borderRadius: BorderRadius.circular(30)
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Obx(() {
            if (UserController()
                .stateController
                .categoryList
                .value
                .length
                .isEqual(0)) {
              return Center(child: CircularProgressIndicator());
            }

            categoryList = UserController().stateController.categoryList.value
                as List<CategoryModel>;
            productListAll = [];
            for (int i = 0; i < categoryList.length; i++) {
              for (int j = 0; j < categoryList[i].productList!.length; j++) {
                productListAll.add(categoryList[i].productList![j]);
              }
            }

            return Container(
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.4),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  Text(
                    "Categories",
                    style: CommonDecoration.subHeaderDecoration.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  GridView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    addRepaintBoundaries: false,
                    addAutomaticKeepAlives: false,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: categoryList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisExtent: 150,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          goTo(
                              className: ItemsScreen(
                            productList: categoryList[index].productList ?? [],
                          ));
                        },
                        child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: greyShadow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(.05)),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      // boxShadow: greyShadow,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: myImage(
                                          source:
                                              categoryList[index].image ?? "",
                                          fromUrl: true)),
                                ),
                                Spacer(),
                                Text(
                                  categoryList[index].name?.capitalize ?? "",
                                  style: CommonDecoration.descriptionDecoration
                                      .copyWith(
                                          color: ColorConstants.themeColor),
                                )
                              ],
                            )),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
          SizedBox(
            height: 7,
          ),
          if (hotItems.productList?.length != null)
            Text(
              "Hot Deals",
              style: CommonDecoration.subHeaderDecoration
                  .copyWith(color: ColorConstants.themeColor),
            ),
          GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            addRepaintBoundaries: false,
            addAutomaticKeepAlives: false,
            itemCount: hotItems.productList?.length == null
                ? 0
                : hotItems.productList!.length > 6
                ? 6
                : hotItems.productList?.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
            ),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  goTo(
                      className: ItemDetails(
                        productList:hotItems.productList!,
                        productDetailsModel: hotItems.productList![index],));
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
                                  source: hotItems
                                      .productList![index].productImage ??
                                      "",
                                  fromUrl: true)),
                        ),
                        Spacer(),
                        Text(
                          "${hotItems.productList![index].productName
                              ?.capitalize ??
                              ""}, ${hotItems.productList![index].quantityAndPrice?.last.quantity ?? ""}",
                          style: CommonDecoration.itemName
                              .copyWith(color: ColorConstants.themeColor),
                          textAlign: TextAlign.center,
                        ),
                        Spacer(),
                        if(hotItems.productList?[index].productGrade!="")
                          Text(
                            "Grade : ${hotItems.productList![index].productGrade?.capitalize ?? ""}",
                            style: CommonDecoration.descriptionDecoration,
                            textAlign: TextAlign.center,
                          ),
                        Spacer(),
                        Row(
                          children: [
                            InkWell(
                              onTap:(){
                                addToCart(productDetailsModel: hotItems.productList![index]);
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
                              "₹ ${hotItems.productList![index].quantityAndPrice?.last.price ?? ""}",
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
          largeSpace(),
        ],
      ),
    );
  }

  Widget _account() {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              goTo(className: PersonalAccount());
            },
            child: _accountListItem(
                icon: Icons.person_outline_sharp, name: "Personal Information"),
          ),
          InkWell(
            onTap: () {
              FirebaseRealTimeStorage().getOrder();
            },
            child: _accountListItem(
                icon: Icons.list_alt_sharp, name: "Order Details"),
          ),
          InkWell(
            onTap: ()  {
            openWhatsApp();
            },
            child:
                _accountListItem(icon: Icons.whatsapp_sharp, name: "Contact Us"),
          ),
          InkWell(
            onTap: ()  {
            sendMail();
            },
            child:
                _accountListItem(icon: Icons.developer_board, name: "Contact Developer"),
          ),
          InkWell(
            onTap: () async {
              goTo(className: TermsAndConditions());
            },
            child: _accountListItem(icon: Icons.rule, name: "Terms & Conditions"),
          ),
          InkWell(
            onTap: () async {
              logoutDialog();
            },
            child:
                _accountListItem(icon: Icons.power_settings_new, name: "Logout"),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () async {
            },
            child:
            _accountListItem(icon: Icons.location_on_outlined, name: "SCF 169 grain market sector 26 Chandigarh"),
          ),
        ],
      ),
    );
  }

  _floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        _searchBottomSheet();
      },
      child: Icon(Icons.search_outlined),
    );
  }

  _bottomAppBar() {
    return BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    isHome = true;
                    setState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_outlined,
                          color: isHome ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color:isHome ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    isHome = false;
                    setState(() {});
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline_sharp,
                          color: !isHome ? Colors.white : Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                            color: !isHome ? Colors.white : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _accountListItem({required IconData icon, required String name}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              Icon(icon),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  name,
                  style: CommonDecoration.listItem,
                ),
              )
            ],
          ),
        ),
        greyLine(showSpace: false)
      ],
    );
  }

  _searchBottomSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 0,
        isScrollControlled: true,
        transitionAnimationController: controller,
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              searchController.addListener(() {
                if (searchController.value.text.isEmpty) {
                  isSearch = false;
                } else {
                  isSearch = true;
                  productListSearch = [];
                  for (int i = 0; i < productListAll.length; i++) {
                    if (productListAll[i]
                        .productName!
                        .toUpperCase()
                        .contains(searchController.value.text.toUpperCase())) {
                      productListSearch.add(productListAll[i]);
                    }
                  }
                }
                setState(() {});
              });
              return SafeArea(
                  child: Column(
                children: [
                  Container(
                    height: 100,
                    color: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.only(top: 30),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                            size: 40,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: myPadding(
                        child: Column(
                          children: [
                            smallSpace(),
                            MyTextFieldWithPreFix(
                              textEditController: searchController,
                              filled: false,
                              textInputType: TextInputType.name,
                              label: "Search",
                              validate: false,
                              icon: Icons.search_outlined,
                            ),
                            smallSpace(),
                            Expanded(
                                child: ListView.builder(
                                    itemCount: isSearch
                                        ? productListSearch.length
                                        : productListAll.length,
                                    itemBuilder: (context, i) {
                                      ProductDetailsModel model = isSearch
                                          ? productListSearch[i]
                                          : productListAll[i];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          goTo(
                                              className: ItemDetails(
                                                  productDetailsModel: model,productList:hotItems.productList!));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: myImage(
                                                          source: model
                                                                  .productImage ??
                                                              "",
                                                          fromUrl: true))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${model.productName!.capitalize} ${model.productGrade!=""?"["+model.productGrade.toString()+"]":""}",
                                                style: CommonDecoration
                                                    .descriptionDecoration
                                                    .copyWith(fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            }));
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      myLog(label: "found", value: state.name);
      FirebaseRealTimeStorage()
          .getAllCategoryList(navigate: false, loader: false);
      getBanner();
      getHotItems();
    }
    // TODO: implement didChangeAppLifecycleState
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    // TODO: implement didChangeLocales
  }

  @override
  void didChangeMetrics() {
    // TODO: implement didChangeMetrics
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
  }

  @override
  void didChangeTextScaleFactor() {
    // TODO: implement didChangeTextScaleFactor
  }

  @override
  void didHaveMemoryPressure() {
    // TODO: implement didHaveMemoryPressure
  }

  @override
  Future<bool> didPopRoute() {
    // TODO: implement didPopRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
    throw UnimplementedError();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    // TODO: implement didPushRouteInformation
    throw UnimplementedError();
  }
}
