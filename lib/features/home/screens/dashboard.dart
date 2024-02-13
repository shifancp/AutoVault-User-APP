import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_vault_user/features/products/screens/feed_screen.dart';
import 'package:auto_vault_user/features/home/screens/home.dart';
import 'package:auto_vault_user/features/testdrive/screens/testdrive_screen.dart';
import 'package:auto_vault_user/features/user/screens/user_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const String routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> _screens = [
    {'page': const HomeScreen(), 'title': 'Home Screen'},
    {
      'page': const FeedScreen(
        isDashboardscreen: true,
      ),
      'title': 'What\'s in our Garage?'
    },
    {'page': const TestDriveScreen(), 'title': 'Test Drives'},
    {'page': const UserScreen(), 'title': 'Profile'}
  ];
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  final _controller = NotchBottomBarController(index: 0);
  int maxCount = 4;
  String appBarTitle = 'Home Screen';

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.1,
        title: Center(
          child: Text(
            appBarTitle,
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children:
            List.generate(_screens.length, (index) => _screens[index]['page']),
      ),
      extendBody: true,
      bottomNavigationBar: (_screens.length <= maxCount)
          ? AnimatedNotchBottomBar(
              /// Provide NotchBottomBarController
              notchBottomBarController: _controller,
              color: Colors.white,
              showLabel: false,
              notchColor: Colors.black87,
              removeMargins: false,
              bottomBarWidth: 500,
              durationInMilliSeconds: 300,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.home_filled,
                    color: Colors.blueAccent,
                  ),
                  itemLabel: 'Feed',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    CupertinoIcons.car_detailed,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    CupertinoIcons.car_detailed,
                    color: Colors.red,
                  ),
                  itemLabel: 'Home',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    CupertinoIcons.speedometer,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    CupertinoIcons.speedometer,
                    color: Colors.deepPurple,
                  ),
                  itemLabel: 'Test Drives',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    Icons.person,
                    color: Colors.blueGrey,
                  ),
                  activeItem: Icon(
                    Icons.person,
                    color: Colors.pink,
                  ),
                  itemLabel: 'Profile',
                ),
              ],
              onTap: (index) {
                /// perform action on tab change and to update pages you can update pages without pages
                log('current selected index $index');
                _pageController.jumpToPage(index);
                setState(() {
                  // Update the app bar title based on the selected index
                  appBarTitle = _screens[index]['title'];
                });
              },
            )
          : null,
    );
  }
}
