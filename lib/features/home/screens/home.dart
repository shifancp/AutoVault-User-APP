import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_user/features/testdrive/provider/testdrive_provider.dart';
import 'package:auto_vault_user/features/wishlist/provider/wishlist_provider.dart';
import 'package:auto_vault_user/features/products/screens/feed_screen.dart';
import 'package:auto_vault_user/services/utils.dart';
import 'package:auto_vault_user/features/products/widgets/category_widget.dart';
import 'package:auto_vault_user/features/products/widgets/product_card_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routename = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // Initialize data fetching for wishlist and test drive items
    Provider.of<WishlistProvider>(context, listen: false).fetchWishlistItems();
    Provider.of<TestDriveProvider>(context, listen: false).fetchTdItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size using utility function
    final Size size = Utils(context).getScreenSize;

    // List of images for the swiper
    final List<String> cardImages = [
      'assets/images/slider1.webp',
      'assets/images/slider2.jpeg',
      'assets/images/slider3.jpeg',
    ];

    // Color list for category
    List<Color> gridColors = [
      Colors.red,
      Colors.blue,
      Colors.brown,
      Colors.teal,
      Colors.yellow,
      Colors.cyan,
      Colors.teal,
      Colors.pink,
    ];

    // Category List
    final List<Map<String, dynamic>> catInfo = [
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Hatchback'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Sedan'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'SUV'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Crossover'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Coupe'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Convertible'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Sports'},
      {'icon': const Icon(CupertinoIcons.car), 'catText': 'Exotics'},
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.25,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Image.asset(
                      cardImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                  autoplay: true,
                  itemCount: cardImages.length,
                  layout: SwiperLayout.STACK,
                  itemWidth: 350.00,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Horizontal scrolling category list
              Container(
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListView.builder(
                  padding: const EdgeInsetsDirectional.all(10.0),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CategoriesWidget(
                        catText: catInfo[index]['catText'],
                        icon: catInfo[index]['icon'],
                        passedColor: gridColors[index],
                      ),
                    );
                  },
                  itemCount: catInfo.length,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Section for displaying a collection
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  color: Colors.deepPurple,
                ),
                width: double.infinity,
                height: 25,
                child: const Center(
                  child: Text(
                    'Discover Our Collection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                height: size.height * 0.48,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collectionGroup('items')
                        .get(),
                    builder: ((context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> productList =
                            snapshot.data.docs;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              productList.length < 4 ? productList.length : 4,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemBuilder: (context, index) {
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
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ),
              ),
              // View All button
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)),
                  color: Colors.deepPurple,
                ),
                width: double.infinity,
                height: size.height * 0.07,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(FeedScreen.routename);
                  },
                  icon: const Icon(
                    CupertinoIcons.forward,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'View All',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              // Request a call back button
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple,
                  ),
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: TextButton.icon(
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.phone,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Request a call back',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.08,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Function to show bottom sheet when clicking request callback
  void _showBottomSheet(BuildContext context) {
    final TextEditingController callBackNumController = TextEditingController();
    final TextEditingController callBackNameController =
        TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: callBackNumController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Mobile Number',
                ),
              ),
              TextFormField(
                controller: callBackNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Name',
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('callbackReq')
                      .add({
                    'mobile': callBackNumController.text.trim(),
                    'name': callBackNameController.text.trim(),
                  });
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.badge_plus_radiowaves_right,
                ),
                label: const Text(
                  'I agree someone can contact me on my number',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
