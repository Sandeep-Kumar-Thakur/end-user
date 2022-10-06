import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyTextFieldWithPreFix extends StatelessWidget {
  TextEditingController textEditController;
  TextInputType textInputType;
  IconData? icon;
  String label;
  bool validate;
  bool filled;

  MyTextFieldWithPreFix(
      {Key? key,
      required this.textEditController,
        required this.filled,
        this.icon,
      required this.textInputType,
      required this.label,
      required this.validate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditController,
      keyboardType: textInputType,
      autovalidateMode:validate? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
      validator: (v){
        if(v!.isEmpty && validate){
          return "$label is required";
        }
      },
      readOnly: filled,
      
      decoration: InputDecoration(
      filled: filled,
        fillColor: Colors.grey.withOpacity(.2),
        prefixIcon: Icon(icon!=null?icon:Icons.edit),
        label: Text(label),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
    );
  }
}


class MyTextFieldWithMobile extends StatelessWidget {
  TextEditingController textEditController;
  TextInputType textInputType;
  String label;
  bool validate;
  bool filled;

  MyTextFieldWithMobile(
      {Key? key,
        required this.textEditController,
        required this.filled,
        required this.textInputType,
        required this.label,
        required this.validate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditController,
      keyboardType: textInputType,
      autovalidateMode:validate? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
      validator: (v){
        if(v!.isEmpty && validate){
          return "$label is required";
        }
        if(v.length<10 || v.length>10){
          return "Please enter valid mobile number";
        }
      },
      readOnly: filled,

      decoration: InputDecoration(
        filled: filled,
        fillColor: Colors.grey.withOpacity(.2),
        prefixIconConstraints: BoxConstraints(
          maxWidth: 50
        ),
        prefixIcon: Container(
            alignment: Alignment.center,
            child: Text("+91")),
        label: Text(label),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1,)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
    );
  }
}

class MyTextFieldWithEmail extends StatelessWidget {
  TextEditingController textEditController;
  TextInputType textInputType;
  String label;
  bool validate;
  bool filled;

  MyTextFieldWithEmail(
      {Key? key,
        required this.textEditController,
        required this.filled,
        required this.textInputType,
        required this.label,
        required this.validate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditController,
      keyboardType: textInputType,
      autovalidateMode:validate? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
      validator: (v){
        if(v!.isEmpty && validate){
          return "$label is required";
        }
        if(!GetUtils.isEmail(v)){
          return "Please enter valid email address";
        }
      },
      readOnly: filled,

      decoration: InputDecoration(
        filled: filled,
        fillColor: Colors.grey.withOpacity(.2),
        prefixIcon:Icon(Icons.attach_email_outlined),
        label: Text(label),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1,)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
    );
  }
}
