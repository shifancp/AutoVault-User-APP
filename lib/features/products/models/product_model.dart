/// Class representing an item in the test drive list.
class TdItem {
  final String productId;
  final String productName;
  final double price;

  /// Constructor for the `TdItem` class.
  TdItem({
    required this.productId,
    required this.productName,
    required this.price,
  });
}

/// Class representing a product model.
class ProductModel {
  final String productImg;
  final String productId;
  final String productName;
  final String productDesc;
  final String price;
  final String salePrice;
  final bool onOffer;

  /// Constructor for the `ProductModel` class.
  ProductModel({
    required this.productDesc,
    required this.productImg,
    required this.price,
    required this.salePrice,
    required this.onOffer,
    required this.productId,
    required this.productName,
  });
}
