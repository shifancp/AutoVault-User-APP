import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/testdrive/widgets/testdrive_card.dart';

class TestDriveScreen extends StatefulWidget {
  const TestDriveScreen({super.key});
  static const routeName = '/testDriveScreen';
  @override
  State<TestDriveScreen> createState() => _TestDriveScreenState();
}

// Define the stream to listen for test drives
Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('testdrives')
    .snapshots();
User? user = FirebaseAuth.instance.currentUser;

class _TestDriveScreenState extends State<TestDriveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: user == null
            ? const Center(
                child: Text('Please LogIn to continue'),
              )
            : StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while waiting for data
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    // Show an error message if there is an issue with the data
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final List<DocumentSnapshot> tdList =
                      snapshot.data?.docs ?? [];
                  if (tdList.isNotEmpty) {
                    // Display the list of test drives if available
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return TestDriveCard(
                          productImg: tdList[index]['productImg'],
                          productTitle: tdList[index]['productName'],
                          productDesc: tdList[index]['productDesc'],
                          price: tdList[index]['price'],
                          sellingprice: tdList[index]['salePrice'],
                          onOffer: tdList[index]['onOffer'],
                          docId: tdList[index]['productId'],
                        );
                      },
                      itemCount: tdList.length,
                    );
                  } else {
                    // Display a message and image when there are no test drives
                    return Center(
                        child: Image.asset('assets/images/emptyTD.png'));
                  }
                }),
      ),
    );
  }
}
