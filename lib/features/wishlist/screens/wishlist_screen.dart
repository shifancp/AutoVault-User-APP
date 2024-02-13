import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/widgets/product_card_widget.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  static const routeName = '/wishlistpage';

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My WishList'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: user == null
              ? const Center(
                  child: Text('Please Log In to View Wishlist'),
                )
              : StreamBuilder(
                  // Stream to listen for changes in the user's wishlist
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('wishlist')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    // Extract the wishlist data
                    final List<DocumentSnapshot> wishList =
                        snapshot.data?.docs ?? [];

                    if (wishList.isNotEmpty) {
                      // Display the wishlist as a grid view
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ProductCard(
                              category: '',
                              productImg: wishList[index]['productImg'],
                              title: wishList[index]['productName'],
                              description: wishList[index]['productDesc'],
                              price: wishList[index]['price'],
                              saleprice: wishList[index]['salePrice'],
                              onoffer: wishList[index]['onOffer'],
                              docId: wishList[index]['productId'],
                            ),
                          );
                        },
                        itemCount: wishList.length,
                      );
                    } else {
                      // Display a message when the wishlist is empty
                      return Center(
                          child:
                              Image.asset('assets/images/emptyWishlist.png'));
                    }
                  },
                ),
        ),
      ),
    );
  }
}
