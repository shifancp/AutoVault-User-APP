import 'package:auto_vault_user/features/authentication/screens/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/models/product_model.dart';
import 'package:auto_vault_user/features/testdrive/provider/testdrive_provider.dart';
import 'package:auto_vault_user/features/wishlist/provider/wishlist_provider.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';
import 'package:auto_vault_user/services/utils.dart';

import 'package:auto_vault_user/features/products/widgets/product_details_widget.dart';

import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});
  static const routename = '/productpage';

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size using a utility function
    final Size size = Utils(context).getScreenSize;

    // Get the current user
    final user = FirebaseAuth.instance.currentUser;

    // Widget to show the images
    Widget buildImageWidgets(List<String> urls) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Adjust the number of columns as needed
          ),
          itemCount: urls.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  urls[index],
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      );
    }

    // Retrieve arguments passed to the screen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String docId = args['docId'];
    final String title = args['title'];
    final String category = args['category'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: StreamBuilder(
          // Stream to get product details from Firestore
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(category)
              .collection('items')
              .doc(docId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Display an error message if there is an error with the stream
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              // Display a message when there is no data available
              return const Text('No Data Available');
            }

            // Retrieve the data from the snapshot
            Map<String, dynamic> productData =
                snapshot.data!.data() as Map<String, dynamic>;

            // Extract image URLs from the data
            List<String> uploadedImageUrls =
                List<String>.from(productData['productImg']);

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height * 0.40,
                  child: buildImageWidgets(uploadedImageUrls),
                ),
                ProductDetails(
                  title: productData['title'],
                  description: productData['description'],
                  odoreading: productData['odoreading'],
                  modelyear: productData['modelyear'],
                  condition: productData['condition'],
                  category: productData['category'],
                  price: productData['price'],
                  sellingprice: productData['offerprice'],
                  fueltype: productData['fueltype'],
                  onoffer: productData['onoffer'],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Wishlist button
                    Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, child) {
                        bool isWishlisted =
                            wishlistProvider.isInWishlist(productData['docId']);
                        return IconButton(
                          onPressed: () {
                            final wishlistProvider =
                                Provider.of<WishlistProvider>(context,
                                    listen: false);
                            if (isWishlisted) {
                              wishlistProvider.removeFromWishlist(
                                ProductModel(
                                  productImg: productData['productImg'][0],
                                  productId: productData['docId'],
                                  productName: productData['title'],
                                  productDesc: productData['description'],
                                  price: productData['price'],
                                  salePrice: productData['offerprice'],
                                  onOffer: productData['onoffer'],
                                ),
                                productData['docId'],
                              );
                            } else {
                              // Navigate to login screen if the user is not logged in
                              user == null
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Please Login or SignUp to continue'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to login screen
                                                Navigator.of(context).pushNamed(
                                                    LoginScreen.routeName);
                                              },
                                              child: const Text('Login'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to signup screen
                                                Navigator.of(context).pushNamed(
                                                    SignUpScreen.routeName);
                                              },
                                              child: const Text('SignUp'),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : wishlistProvider.addToWishlist(ProductModel(
                                      productImg: productData['productImg'][0],
                                      productId: productData['docId'],
                                      productName: productData['title'],
                                      productDesc: productData['description'],
                                      price: productData['price'],
                                      salePrice: productData['offerprice'],
                                      onOffer: productData['onoffer'],
                                    ));
                            }
                          },
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 30,
                          ),
                          color: Colors.red,
                        );
                      },
                    ),
                    // Test Drive button
                    Consumer<TestDriveProvider>(
                      builder: (context, testDriveProvider, child) {
                        bool isInTd = testDriveProvider
                            .isInTestdrive(productData['docId']);
                        return ElevatedButton.icon(
                          onPressed: () {
                            final testDriveProvider =
                                Provider.of<TestDriveProvider>(context,
                                    listen: false);
                            if (isInTd) {
                              testDriveProvider.removeFromTestDrive(
                                ProductModel(
                                  productImg: productData['productImg'][0],
                                  productId: productData['docId'],
                                  productName: productData['title'],
                                  productDesc: productData['description'],
                                  price: productData['price'],
                                  salePrice: productData['offerprice'],
                                  onOffer: productData['onoffer'],
                                ),
                                productData['docId'],
                              );
                            } else {
                              // Navigate to login screen if the user is not logged in
                              user == null
                                  ? showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Please Login or SignUp to continue'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                              child: const Text('Close'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to login screen
                                                Navigator.of(context).pushNamed(
                                                    LoginScreen.routeName);
                                              },
                                              child: const Text('Login'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Navigate to signup screen
                                                Navigator.of(context).pushNamed(
                                                    SignUpScreen.routeName);
                                              },
                                              child: const Text('SignUp'),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : testDriveProvider
                                      .addToTestdrive(ProductModel(
                                      productImg: productData['productImg'][0],
                                      productId: productData['docId'],
                                      productName: productData['title'],
                                      productDesc: productData['description'],
                                      price: productData['price'],
                                      salePrice: productData['offerprice'],
                                      onOffer: productData['onoffer'],
                                    ));
                            }
                          },
                          icon: const Icon(
                            CupertinoIcons.car_detailed,
                            size: 24,
                          ),
                          label: Text(
                            isInTd
                                ? 'Cancel Test Drive'
                                : 'Book a Free Test Drive',
                            style: const TextStyle(fontSize: 22),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                          ),
                        );
                      },
                    ),
                    // Spacer
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
