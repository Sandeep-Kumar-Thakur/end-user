import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/screens/account/personal_information.dart';
import 'package:bala_ji_mart/screens/category/item_details.dart';
import 'package:bala_ji_mart/screens/category/item_list.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<CategoryModel> categoryList = [];
  bool isHome = true;

  late Animation<double> animation;
  late AnimationController controller;

  final searchController = TextEditingController();

  List<ProductDetailsModel> productListAll = [];
  List<ProductDetailsModel> productListSearch = [];
 bool isSearch  =  false;
  List<BannerModel> bannerList = [];

  @override
  void initState() {
   getBanner();
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    FirebaseRealTimeStorage()
        .getAllCategoryList(navigate: false, loader: false);

    // TODO: implement initState
    super.initState();
  }

  getBanner()async{
    bannerList =await FirebaseRealTimeStorage().getAllBanner();
  }

  @override
  Widget build(BuildContext context) {
    LocalStorage().readUserCart();
    return Scaffold(
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
    );
  }

  Widget _home() {
    return Obx(() {
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

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 140,
              width: double.infinity,
              child: CarouselSlider.builder(itemCount: bannerList.length, itemBuilder: (context,i,j){
                return InkWell(
                  onTap: (){
                    goTo(className: ItemsScreen(productList: bannerList[i].productList!));
                  },
                  child: Container(
                    width: double.infinity,
                    child: myImage(source: bannerList[i].image??"", fromUrl: true),
                  ),
                );
              }, options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true
              )),
            ),
            GridView.builder(
              padding: EdgeInsets.only(bottom: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: categoryList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 210,
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
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border:
                        Border.all(color: Colors.grey.withOpacity(.05)),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  boxShadow: greyShadow,
                                  borderRadius: BorderRadius.circular(100)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: myImage(
                                      source: categoryList[index].image ?? "",
                                      fromUrl: true)),
                            ),
                          ),
                          smallSpace(),
                          Text(
                            categoryList[index].name?.capitalize ?? "",
                            style: CommonDecoration.listItem,
                          )
                        ],
                      )),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _account() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            goTo(className: PersonalAccount());
          },
          child: _accountListItem(
              icon: Icons.person_outline_sharp, name: "Personal Information"),
        ),
        InkWell(
          onTap: (){
            FirebaseRealTimeStorage().getOrder();
          },
          child:_accountListItem(icon: Icons.list_alt_sharp, name: "Order Details"),

        ),
        InkWell(
          onTap: ()async{
            Uri url  = Uri.parse("whatsapp://send?phone=" + "+918288814320" + "&text=" + "Hello sir");
            if (!await launchUrl(url)) {
            throw 'Could not launch';
            }
          },
          child:         _accountListItem(icon: Icons.whatsapp_sharp, name: "Contact Us"),
        )
      ],
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
                          color: isHome ? Colors.blue : Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Home",
                          style: TextStyle(
                            color: isHome ? Colors.blue : Colors.white,
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
                          color: !isHome ? Colors.blue : Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                            color: !isHome ? Colors.blue : Colors.white,
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
              Icon(icon),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: CommonDecoration.listItem,
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
        builder: (context) =>
            StatefulBuilder(builder: (context, setState) {
              searchController.addListener(() {
                if(searchController.value.text.isEmpty){
                  isSearch = false;
                }else{
                  isSearch = true;
                  productListSearch  = [];
                  for(int i=0;i<productListAll.length;i++){
                      if(productListAll[i].productName!.toUpperCase().contains(searchController.value.text.toUpperCase())){
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
                                Expanded(child: ListView.builder(
                                  itemCount: isSearch?productListSearch.length: productListAll.length,
                                    itemBuilder: (context, i) {
                                      ProductDetailsModel model =isSearch? productListSearch[i]:productListAll[i];
                                      return InkWell(
                                        onTap: (){
                                          Navigator.pop(context);
                                          goTo(className: ItemDetails(productDetailsModel: model));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  height: 50,
                                                  width: 50,
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: myImage(source: model.productImage??"", fromUrl: true))),
                                              SizedBox(width: 10,),
                                              Text("${model.productName} [${model.productGrade}]",style: CommonDecoration.descriptionDecoration.copyWith(fontSize: 14),)
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
}
