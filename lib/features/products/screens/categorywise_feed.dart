import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/products/widgets/product_card_widget.dart';

class CategoryWiseFeed extends StatefulWidget {
  const CategoryWiseFeed({Key? key}) : super(key: key);

  static const routeName = '/categoryfeed';

  @override
  State<CategoryWiseFeed> createState() => _CategoryWiseFeedState();
}

class _CategoryWiseFeedState extends State<CategoryWiseFeed> {
  @override
  Widget build(BuildContext context) {
    // Extracting the category passed through route arguments
    final category = ModalRoute.of(context)!.settings.arguments as String;

    // Creating a stream of query snapshots for the specified category
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection('products')
        .doc(category)
        .collection('items')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder(
            // Listening to the stream of data
            stream: stream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // If data is still loading, display a loading indicator
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
                // If data is available and not empty, display the products
                final List<DocumentSnapshot> productList = snapshot.data.docs;
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: productList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ProductCard(
                        category: productList[index]['category'],
                        productImg: productList[index]['productImg'][0],
                        title: productList[index]['title'],
                        description: productList[index]['description'],
                        price: productList[index]['price'],
                        saleprice: productList[index]['offerprice'],
                        onoffer: productList[index]['onoffer'],
                        docId: productList[index]['docId'],
                      ),
                    );
                  },
                );
              } else {
                if (snapshot.data == null || snapshot.data.docs.isEmpty) {
                  // If there are no items in the category, display a message
                  return Center(
                    child: Text(
                      'No Items listed in $category category, Please Come back Later',
                    ),
                  );
                } else {
                  // Handle other cases when there is some issue with the data
                  return const Center(
                    child: Text('Error loading data'),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
