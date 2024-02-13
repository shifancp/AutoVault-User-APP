import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/testdrive/widgets/testdrive_card.dart';

class PreviousTestDrives extends StatelessWidget {
  const PreviousTestDrives({super.key});
  static const routeName = '/prevtd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Previous Test Drives'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          // Stream to get the list of completed test drives for the current user
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('completedtestdrives')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a loading indicator while waiting for data
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              // Display an error message if there is an error with the stream
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            // Get the list of completed test drives from the snapshot
            final List<DocumentSnapshot> tdList = snapshot.data?.docs ?? [];

            if (tdList.isNotEmpty) {
              // If there are completed test drives, display them using a ListView
              return ListView.builder(
                itemBuilder: (context, index) {
                  return TestDriveCard(
                    prevTd: true,
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
              // If there are no completed test drives, display an empty state
              return Center(child: Image.asset('assets/images/emptyTD.png'));
            }
          },
        ),
      ),
    );
  }
}
