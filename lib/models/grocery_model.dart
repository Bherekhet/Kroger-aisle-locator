class GroceryModel {
  final String productId;
  final String productName;
  final String productPrice;
  final String productImage;
  final List<String> productAisleLocations;

  GroceryModel({
    this.productId,
    this.productName,
    this.productPrice,
    this.productImage,
    this.productAisleLocations,
  });

  factory GroceryModel.fromJson(Map<String, dynamic> parsedJson) {
    var aislesFromJson = parsedJson['productAisleLocations'];
    print(aislesFromJson.runtimeType);
    List<String> productAisles = List<String>.from(aislesFromJson);

    return GroceryModel (
      productId : parsedJson['productId'],
      productName : parsedJson['productName'],
      productPrice : parsedJson['productPrice'],
      productImage : parsedJson['productImage'],
      productAisleLocations: productAisles,
    );
  }

  Map<String, dynamic> toJson() => {
    'productId' : productId,
    'productName' : productName,
    'productPrice' : productPrice,
    'productImage' : productImage,
    'productAisleLocations': productAisleLocations,
  };

}
