import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/utils/global_vars.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  final int? index;
  const MobileScreenLayout({Key? key, this.index}) : super(key: key);
  MobileScreenLayout get _index => MobileScreenLayout(index: index!);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _index = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    if (widget.index != null) {
      _index = widget.index!;
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (pageController.hasClients) {
          onSelectNavigationItem(_index);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onSelectNavigationItem(int index) {
    pageController.jumpToPage(index);
    setState(() {
      _index = index;
    });
  }

  void onPageChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: dashboardItems,
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: mobileBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: _index,
        onTap: onSelectNavigationItem,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline_rounded,
            ),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
