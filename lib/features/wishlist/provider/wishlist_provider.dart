import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/models/product_model.dart';

/// A provider class for managing the user's wishlist.
class WishlistProvider extends ChangeNotifier {
  bool? _isWishlisted;
  bool? get isWishlisted => _isWishlisted;
  String? _userId;
  User? user = FirebaseAuth.instance.currentUser;
  List<ProductModel> _wishlistItems = [];
  List<ProductModel> get wishlistItems => _wishlistItems;

  /// Checks if a product is in the wishlist.
  bool isInWishlist(String productId) {
    return _wishlistItems.any((item) => item.productId == productId);
  }

  /// Adds a product to the wishlist.
  void addToWishlist(ProductModel item) async {
    _wishlistItems.add(item);
    notifyListeners();
    _userId = user!.uid;
    if (_userId != null) {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('wishlist')
          .add({
        'productId': item.productId,
        'productName': item.productName,
        'productImg': item.productImg,
        'productDesc': item.productDesc,
        'price': item.price,
        'salePrice': item.salePrice,
        'onOffer': item.onOffer,
        'isInWishlist': true,
        'wishDocId': '',
      });

      String docId = docRef.id;
      await docRef.update({'wishDocId': docId});
    }
  }

  /// Removes a product from the wishlist.
  void removeFromWishlist(ProductModel item, String productId) async {
    _wishlistItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
    _userId = user!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('wishlist')
        .where('productId', isEqualTo: item.productId)
        .get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  }

  /// Fetches wishlist items from the Firestore database.
  void fetchWishlistItems() async {
    _userId = user!.uid;
    if (_userId != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('wishlist')
          .get();

      _wishlistItems = querySnapshot.docs.map((doc) {
        return ProductModel(
          productId: doc['productId'],
          productName: doc['productName'],
          productDesc: doc['productDesc'],
          productImg: doc['productImg'],
          price: doc['price'],
          salePrice: doc['salePrice'],
          onOffer: doc['onOffer'],
        );
      }).toList();
      notifyListeners();
    }
  }
}
