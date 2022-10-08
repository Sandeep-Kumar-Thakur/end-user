import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/screens/login/login_screen.dart';
import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
                Expanded(child: Text("Hello,\nWelcome in Bala Ji Mart",style: CommonDecoration.listItem,))
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
                onTap: ()async{
                    Uri url  = Uri.parse("whatsapp://send?phone=" + "+918288814320" + "&text=" + "Hello sir");
                    if (!await launchUrl(url)) {
                    throw 'Could not launch';
                    }
                },
                child: rowData(icons: Icons.whatsapp_rounded, data: "WhatsApp Contact")),
            rowData(icons: Icons.developer_board, data: "Developer Contact"),
            InkWell(
                onTap: (){
                  LocalStorage().clearData();
                  goOff(className: LoginScreen());
                },
                child: rowData(icons: Icons.power_settings_new, data: "Logout")),
          ],
        ),
      ),
    ));
  }

  Widget rowData({required IconData icons, required String data}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
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
