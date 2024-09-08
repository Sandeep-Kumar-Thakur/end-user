import 'package:bala_ji_mart/constants/key_contants.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/terms_and_conditions.dart';
import 'helper_widgets.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Drawer(
      child: myPadding(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 70,

                  child: Image.asset("assets/icons/balaji_new.png"),
                ),
                SizedBox(width: 10,),
                Expanded(child: Text("Hello,\nWelcome to Bala Ji Mart",style: CommonDecoration.listItem,))
              ],
            ),
            smallSpace(),
            greyLine(),
           smallSpace(),
            InkWell(
                onTap: (){
                  Navigator.pop(context);
                  FirebaseRealTimeStorage().getOrder();
                },
                child: rowData(icons: Icons.list_alt, data: "Order Details")),
            InkWell(
                onTap: (){
                 openWhatsApp();
                },
                child: rowData(icons: Icons.call, data: "WhatsApp Contact")),
            InkWell(
                onTap: (){
                  sendMail();
                },
                child: rowData(icons: Icons.developer_board, data: "Contact Developer")),
            InkWell(
              onTap: (){
                hideLoader();
                goTo(className: TermsAndConditions());
                },
              child:rowData(icons: Icons.rule, data: "Terms & Conditions"),
            ),
            InkWell(
                onTap: (){
                 logoutDialog();
                },
                child: rowData(icons: Icons.power_settings_new, data: "Logout")),
            Spacer(),
            Text("Version : 1.0.0"),
            smallSpace(),
            Text("Developed By ${KeyConstants.companyName}"),
            smallSpace(),
          ],
        ),
      ),
    ));
  }

  Widget rowData({required IconData icons, required String data}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey
          )
        )
      ),
      child: Row(
        children: [
          Icon(icons),
          SizedBox(width: 10,),
          Text(data,style: CommonDecoration.listItem,)
        ],
      ),
    );
  }

}
