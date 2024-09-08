import 'package:bala_ji_mart/constants/color_constants.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:bala_ji_mart/utility/my_button.dart';
import 'package:bala_ji_mart/utility/my_text_field.dart';
import 'package:flutter/material.dart';

class PersonalAccount extends StatelessWidget {
  PersonalAccount({Key? key}) : super(key: key);

  final userNameController = TextEditingController();
  final numberController = TextEditingController();
  final altNumberController = TextEditingController();
  final gmailController = TextEditingController();
  final locationController = TextEditingController();
  final landMarkController = TextEditingController();
  final pinCodeController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    UserModel userModel = LocalStorage().readUserModel();
    numberController.text = userModel.number??"";
    userNameController.text = userModel.name??"";
    altNumberController.text = userModel.altNumber??"";
    gmailController.text = userModel.gmail??"";
    locationController.text = userModel.location??"";
    landMarkController.text = userModel.landmark??"";
    pinCodeController.text = userModel.pinCode??"";
    myLog(label: "user", value: userModel.toJson().toString());
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            commonHeader(title: "Personal Information"),
            Expanded(
              child: myPadding(
                  child: Form(
                    key: _key,
                    child: SingleChildScrollView(
                      child: Column(
                children: [

                      smallSpace(),
                      MyTextFieldWithPreFix(
                        icon: Icons.person_outline,
                          textEditController: userNameController,
                          filled: false,
                          textInputType: TextInputType.name,
                          label: "Billing Name",
                          validate: true),
                      smallSpace(),
                  MyTextFieldWithMobile(

                          textEditController: numberController,
                          filled: false,
                          textInputType: TextInputType.number,
                          label: "Contact No.",
                          validate: true),
                      smallSpace(),

                  MyTextFieldWithPreFix(
                    icon: Icons.confirmation_number_outlined,
                          textEditController: gmailController,
                          filled: false,
                          textInputType: TextInputType.text,
                          label: "GST NO.",
                          validate: false),
                      smallSpace(),

                      MyTextFieldWithMobile(
                          textEditController: altNumberController,
                          filled: false,
                          textInputType: TextInputType.number,
                          label: "Additional Number",
                          validate: true),
                      smallSpace(),

                      MyTextFieldWithPreFix(
                        icon: Icons.location_on_outlined,
                          textEditController: locationController,
                          filled: false,
                          textInputType: TextInputType.name,
                          label: "Location",
                          validate: true),
                      smallSpace(),

                  // MyTextFieldWithPreFix(
                  //     icon: Icons.person_pin_circle_outlined,
                  //     textEditController: pinCodeController,
                  //     filled: false,
                  //     textInputType: TextInputType.number,
                  //     label: "PinCode",
                  //     validate: true),
                  // smallSpace(),

                      MyTextFieldWithPreFix(
                        icon: Icons.location_city_sharp,
                          textEditController: landMarkController,
                          filled: false,
                          textInputType: TextInputType.name,
                          label: "Landmark",
                          validate: true),
                      largeSpace(),
                      InkWell(
                          onTap: (){
                            if(_key.currentState!.validate()){
                              userModel.pinCode = pinCodeController.value.text;
                              userModel.name = userNameController.value.text;
                              userModel.gmail = gmailController.value.text;
                              userModel.altNumber = altNumberController.value.text;
                              userModel.location = locationController.value.text;
                              userModel.landmark = landMarkController.value.text;
                              userModel.number = numberController.value.text;
                              FirebaseRealTimeStorage().updateUserDetails(userModel).then((value) {
                                  if(value){
                                    showMessage(msg: "Updated");
                                    Navigator.pop(context);
                                  }
                              });
                            }
                          },
                          child: MyRoundButton(text: "Update", bgColor: ColorConstants.themeColor))

                ],
              ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
