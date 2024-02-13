import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/models/product_model.dart';

/// A provider class for managing test drives.
class TestDriveProvider extends ChangeNotifier {
  bool? _isInTestdrive;
  bool? get isisInTestdrive => _isInTestdrive;
  String? _userId;
  User? user = FirebaseAuth.instance.currentUser;
  List<ProductModel> _tdItems = [];
  List<ProductModel> get tdItems => _tdItems;

  /// Checks if a product is in the test drive.
  bool isInTestdrive(String productId) {
    return _tdItems.any((item) => item.productId == productId);
  }

  /// Adds a product to the test drive.
  void addToTestdrive(ProductModel item) async {
    _tdItems.add(item);
    notifyListeners();
    _userId = user!.uid;
    if (_userId != null) {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('testdrives')
          .add({
        'productId': item.productId,
        'productName': item.productName,
        'productImg': item.productImg,
        'productDesc': item.productDesc,
        'price': item.price,
        'salePrice': item.salePrice,
        'onOffer': item.onOffer,
        'tdDocId': '',
        'userEmail': user!.email,
        'userPhone': user!.phoneNumber,
        'userName': user!.displayName,
        'isInTd': true,
        'userUid': _userId,
      });

      String docId = docRef.id;
      await docRef.update({'tdDocId': docId});
    }
  }

  /// Removes a product from the test drive.
  void removeFromTestDrive(ProductModel item, String productId) async {
    _tdItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
    _userId = user!.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_userId)
        .collection('testdrives')
        .where('productId', isEqualTo: item.productId)
        .get();

    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  }

  /// Fetches test drive items from the Firestore database.
  void fetchTdItems() async {
    _userId = user!.uid;
    if (_userId != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .collection('testdrives')
          .get();

      _tdItems = querySnapshot.docs.map((doc) {
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
