import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/models/product_model.dart';
import 'package:auto_vault_user/features/testdrive/provider/testdrive_provider.dart';
import 'package:auto_vault_user/features/products/screens/product_page.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/features/products/widgets/price_widget.dart';
import 'package:auto_vault_user/widgets/custom_text_widget.dart';
import 'package:provider/provider.dart';

class TestDriveCard extends StatefulWidget {
  const TestDriveCard({
    super.key,
    required this.productImg,
    required this.productTitle,
    required this.productDesc,
    required this.price,
    required this.sellingprice,
    required this.onOffer,
    required this.docId,
    this.prevTd = false,
  });

  final String productImg,
      productTitle,
      productDesc,
      price,
      sellingprice,
      docId;
  final bool onOffer;
  final bool prevTd;

  @override
  State<TestDriveCard> createState() => _TestDriveCardState();
}

class _TestDriveCardState extends State<TestDriveCard> {
  @override
  Widget build(BuildContext context) {
    final Size size = Utils(context).getScreenSize;

    return GestureDetector(
      onTap: () {
        // Navigate to the product details page when the card is tapped
        Navigator.of(context).pushNamed(
          ProductPage.routename,
          arguments: {'docId': widget.docId, 'title': widget.productTitle},
        );
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).splashColor,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor.withOpacity(0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        height: size.height * 0.15,
                        width: size.height * 0.15,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FancyShimmerImage(
                              alignment: Alignment.center,
                              boxDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              boxFit: BoxFit.cover,
                              imageUrl: widget.productImg,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title
                        CustomTextWidget(
                          text: widget.productTitle,
                          color: Colors.black,
                          textSize: 20,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Product Description
                        CustomTextWidget(
                          text: widget.productDesc,
                          color: Colors.black.withOpacity(0.5),
                          textSize: 10,
                        ),
                        SizedBox(
                          width: size.width * 0.05,
                        ),
                        // Product Price
                        PriceWidget(
                          price: widget.price,
                          salePrice: widget.sellingprice,
                          isOnSale: widget.onOffer,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: widget.prevTd
                          ? null
                          : InkWell(
                              child: const Icon(
                                CupertinoIcons.minus_circle_fill,
                                color: Colors.red,
                              ),
                              onTap: () {
                                // Remove the product from the test drive
                                final testDriveProvider =
                                    Provider.of<TestDriveProvider>(context,
                                        listen: false);

                                testDriveProvider.removeFromTestDrive(
                                  ProductModel(
                                    productId: widget.docId,
                                    productName: widget.productTitle,
                                    productImg: widget.productImg,
                                    productDesc: widget.productDesc,
                                    price: widget.price,
                                    salePrice: widget.sellingprice,
                                    onOffer: widget.onOffer,
                                  ),
                                  widget.docId,
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
