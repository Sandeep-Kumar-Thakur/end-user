import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CommonDecoration{
  static const headerDecoration = TextStyle(
      fontSize: 20,
      color: ColorConstants.themeColor,
      fontWeight: FontWeight.w500
  );

  static const subHeaderDecoration = TextStyle(
      color: ColorConstants.themeColor,

      fontSize: 19,
      fontWeight: FontWeight.w500
  );

  static const subHeaderDisDecoration = TextStyle(
      color: ColorConstants.themeColor,

      fontSize: 16,
      fontWeight: FontWeight.w500
  );

  static const descriptionDecoration = TextStyle(


      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w400
  );

  static const productDescriptionDecoration = TextStyle(

      fontSize: 15,
      color: Colors.grey,
      fontWeight: FontWeight.w400
  );
  static const subProductDescriptionDecoration = TextStyle(

      fontSize: 11,
      color: Colors.grey,
      fontWeight: FontWeight.w400
  );

  static const listItem = TextStyle(
      color: ColorConstants.themeColor,

      fontSize: 15,
      fontWeight: FontWeight.w500
  );

  static const itemName = TextStyle(
      color: ColorConstants.themeColor,

      fontSize: 13,
      fontWeight: FontWeight.w500
  );
}