import 'package:auto_vault_user/features/authentication/screens/signup_screen.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/models/product_model.dart';
import 'package:auto_vault_user/features/testdrive/provider/testdrive_provider.dart';
import 'package:auto_vault_user/features/wishlist/provider/wishlist_provider.dart';
import 'package:auto_vault_user/features/authentication/screens/login_screen.dart';
import 'package:auto_vault_user/features/products/screens/product_page.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/features/products/widgets/price_widget.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.productImg,
    required this.title,
    required this.description,
    required this.price,
    required this.saleprice,
    required this.onoffer,
    required this.docId,
    required this.category,
  });

  final String productImg,
      title,
      description,
      price,
      saleprice,
      docId,
      category;
  final bool onoffer;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    Size size = Utils(context).getScreenSize;

    return Material(
      elevation: 10,
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          // Navigate to the product page with arguments
          Navigator.of(context).pushNamed(ProductPage.routename, arguments: {
            'docId': widget.docId,
            'title': widget.title,
            'category': widget.category,
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRect(
                child: FancyShimmerImage(
                  imageUrl: widget.productImg,
                  height: size.height * 0.10,
                  width: size.height * 0.20,
                  boxFit: BoxFit.cover,
                ),
              ),
              CustomTextWidget(
                text: widget.title,
                color: Colors.black,
                textSize: 16,
                isTitle: true,
              ),
              CustomTextWidget(
                text: widget.description,
                color: Colors.black.withOpacity(0.6),
                textSize: 10,
              ),
              PriceWidget(
                price: widget.price,
                salePrice: widget.saleprice,
                isOnSale: widget.onoffer,
              ),
              Expanded(
                child: Row(
                  children: [
                    // Wishlist Button
                    Consumer<WishlistProvider>(
                      builder: (context, wishlistProvider, child) {
                        bool isWishlisted =
                            wishlistProvider.isInWishlist(widget.docId);
                        return IconButton(
                          icon: Icon(
                            isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            final wishlistProvider =
                                Provider.of<WishlistProvider>(context,
                                    listen: false);
                            if (isWishlisted) {
                              wishlistProvider.removeFromWishlist(
                                ProductModel(
                                  productId: widget.docId,
                                  productName: widget.title,
                                  productImg: widget.productImg,
                                  productDesc: widget.description,
                                  price: widget.price,
                                  salePrice: widget.saleprice,
                                  onOffer: widget.onoffer,
                                ),
                                widget.docId,
                              );
                            } else {
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
                                  : wishlistProvider.addToWishlist(
                                      ProductModel(
                                        productId: widget.docId,
                                        productName: widget.title,
                                        productImg: widget.productImg,
                                        productDesc: widget.description,
                                        price: widget.price,
                                        salePrice: widget.saleprice,
                                        onOffer: widget.onoffer,
                                      ),
                                    );
                            }
                          },
                        );
                      },
                    ),
                    Expanded(
                      child: Consumer<TestDriveProvider>(
                        builder: (context, testDriveProvider, child) {
                          bool isInTd =
                              testDriveProvider.isInTestdrive(widget.docId);
                          return ElevatedButton.icon(
                            onPressed: () {
                              final testDriveProvider =
                                  Provider.of<TestDriveProvider>(context,
                                      listen: false);
                              if (isInTd) {
                                testDriveProvider.removeFromTestDrive(
                                  ProductModel(
                                    productId: widget.docId,
                                    productName: widget.title,
                                    productImg: widget.productImg,
                                    productDesc: widget.description,
                                    price: widget.price,
                                    salePrice: widget.saleprice,
                                    onOffer: widget.onoffer,
                                  ),
                                  widget.docId,
                                );
                              } else {
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
                                                  Navigator.of(context)
                                                      .pushNamed(LoginScreen
                                                          .routeName);
                                                },
                                                child: const Text('Login'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Navigate to signup screen
                                                  Navigator.of(context)
                                                      .pushNamed(SignUpScreen
                                                          .routeName);
                                                },
                                                child: const Text('SignUp'),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : testDriveProvider.addToTestdrive(
                                        ProductModel(
                                          productId: widget.docId,
                                          productName: widget.title,
                                          productImg: widget.productImg,
                                          productDesc: widget.description,
                                          price: widget.price,
                                          salePrice: widget.saleprice,
                                          onOffer: widget.onoffer,
                                        ),
                                      );
                              }
                            },
                            icon: const Icon(
                              CupertinoIcons.car_detailed,
                              size: 14,
                            ),
                            label: Text(
                              isInTd
                                  ? 'Cancel Test Drive'
                                  : 'Book a Free Test Drive',
                              style: const TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
