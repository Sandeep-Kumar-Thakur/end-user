import 'package:bala_ji_mart/utility/common_decoration.dart';
import 'package:bala_ji_mart/utility/helper_widgets.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            commonHeader(title: "Terms & Conditions"),
            smallSpace(),
            Expanded(
              child: SingleChildScrollView(
                child: myPadding(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      terms("1. Goods As per description","As a seller we always try to deliver our best to make customer satisfy .But the buyer is also advised to check the product and match the description with invoice at the time of delivery of goods.In case if goods are not found as per description buyer has right to deny to accept the order."),
                      terms("2. Transfer of ownership","At the time of delivery Exchange of Goods and Payment (As per invoice given by seller)  is considered as Transfer of ownership. Meanwhile buyer gets Right to resell as well as free to use the product for his own purpose."),
                      terms("3. No Return No Exchange","We do not accept returns or exchanges on any of our products. All sales are deemed to be final Sale."),
                      terms("4. Purchase History","In Case we found that multiple cancellation by the buyer at the time of delivery in a very short period it can effect the purchase history of user and he/ She would not  be able to make futher oders."),
                      terms("5. In Case Goods Damaged in Transit","Our Aim is to deliver all of your orders Safely to you. In case any of the product is damaged in transit buyer can deny to accept the order at the time of delivery ,This will not effect the Purchase history of buyer."),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  terms(title, description){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,style: CommonDecoration.listItem,),
        smallSpace(),
        Text(description,style: CommonDecoration.descriptionDecoration,),
        largeSpace(),
      ],
    );
  }

}
