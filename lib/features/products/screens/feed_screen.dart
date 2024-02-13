import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/features/products/widgets/product_card_widget.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key, this.isDashboardscreen = false})
      : super(key: key);

  static const routename = '/feedscreen';
  final bool isDashboardscreen;
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size using utility function
    final Size size = Utils(context).getScreenSize;

    // Define the main body of the feed screen
    Widget feedBody = StreamBuilder<QuerySnapshot>(
      // Stream to listen for changes in the 'items' collection
      stream: FirebaseFirestore.instance.collectionGroup('items').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          // If data is available, retrieve the product list
          final List<DocumentSnapshot> productList = snapshot.data.docs;
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  // Grid view for displaying product cards
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Build each product card
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ProductCard(
                          category: productList[index]['category'],
                          docId: productList[index]['docId'],
                          productImg: productList[index]['productImg'][0],
                          title: productList[index]['title'],
                          description: productList[index]['description'],
                          price: productList[index]['price'],
                          saleprice: productList[index]['offerprice'],
                          onoffer: productList[index]['onoffer'],
                        ),
                      );
                    },
                    childCount: productList.length,
                  ),
                ),
              ),
              // Additional padding at the end of the list
              SliverToBoxAdapter(
                child: SizedBox(
                  height: size.height * 0.08,
                ),
              )
            ],
          );
        } else {
          // If data is still loading, show a loading indicator
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

    // Return the scaffold with the appropriate app bar based on the screen type
    return Scaffold(
      appBar: widget.isDashboardscreen
          ? null
          : AppBar(
              title: const Text('All vehicles'),
            ),
      body: widget.isDashboardscreen ? feedBody : SafeArea(child: feedBody),
    );
  }
}
