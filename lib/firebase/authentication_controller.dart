import 'dart:developer';

import 'package:bala_ji_mart/constants/key_contants.dart';
import 'package:bala_ji_mart/firebase/firebase_realtime.dart';
import 'package:bala_ji_mart/local_Storage/local_storage.dart';
import 'package:bala_ji_mart/model/user_model.dart';
import 'package:bala_ji_mart/screens/login/otp_screen.dart';
import 'package:bala_ji_mart/utility/navigator_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../utility/helper_widgets.dart';

class AuthenticationController extends GetxController{

  var Number = "".obs;
  var verificationId = "".obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Future getOtp({required String phoneNumber,bool? navigate})async{
    showLoader();
    firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${phoneNumber}",
        verificationCompleted: (v) {

        },
        verificationFailed: (v) {
          showMessage(msg: v.code);
        },
        codeSent: (String verification,int? resendToken){
            Number.value = phoneNumber;
            verificationId.value = verification;
            myLog(label: "verification", value: verificationId.value.toString());
            hideLoader();
            if(navigate!=false){
              goTo(className: OtpScreen());
            }

           // pushPage(className: OtpVerification());
        },
        codeAutoRetrievalTimeout: (v){});
  }

  Future verifyNumber({required String otp})async{
    showLoader();
    myLog(label: "verification otp", value: verificationId.value.toString());
    myLog(label: " otp", value: otp);

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: otp);
    try{
      UserCredential user = await firebaseAuth.signInWithCredential(credential);
      hideLoader();
      if (user.user!.uid.isNotEmpty) {
        log(user.user!.uid.toString());
        LocalStorage().write(key: KeyConstants.uid, value: user.user!.uid.toString());
        String fcmToken = await FirebaseMessaging.instance.getToken()??"";
        UserModel userModel = UserModel();
        userModel.uid = user.user?.uid??"";
        userModel.number = user.user?.phoneNumber??"";
        userModel.fcmToken = fcmToken;
        FirebaseRealTimeStorage().userDetails(userModel).then((value) {
          FirebaseRealTimeStorage().getAllCategoryList();
        });

        // pushPage(className: JoinNgos());
      }else{
        showMessage(msg: "Invalid Credential");
      }
    }catch(e){
      hideLoader();
      showMessage(msg: e.toString());
    }

  }

}