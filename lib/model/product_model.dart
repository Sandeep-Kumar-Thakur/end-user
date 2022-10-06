class ProductModel {
  String? productName;
  String? productGrade;
  String? productDescription;
  String? productImage;
  List<QuantityAndPrice>? quantityAndPrice;

  ProductModel(
      {this.productName,
        this.productGrade,
        this.productDescription,
        this.productImage,
        this.quantityAndPrice});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    productGrade = json['productGrade'];
    productDescription = json['productDescription'];
    productImage = json['productImage'];
    if (json['quantityAndPrice'] != null) {
      quantityAndPrice = <QuantityAndPrice>[];
      json['quantityAndPrice'].forEach((v) {
        quantityAndPrice!.add(new QuantityAndPrice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['productGrade'] = this.productGrade;
    data['productDescription'] = this.productDescription;
    data['productImage'] = this.productImage;
    if (this.quantityAndPrice != null) {
      data['quantityAndPrice'] =
          this.quantityAndPrice!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuantityAndPrice {
  String? quantity;
  String? price;

  QuantityAndPrice({this.quantity, this.price});

  QuantityAndPrice.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    return data;
  }
}
