class OrderDetailModel {
  int? productId;
  int? quantity;
  double? price;

  OrderDetailModel.empty() {
    productId = 0;
    quantity = 0;
    price = 0;
  }

  OrderDetailModel(
      {required this.productId,
        required this.quantity,
        required this.price});


  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    productId: json["productId"],
    quantity: json["quantity"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
    "price": price,
  };
}