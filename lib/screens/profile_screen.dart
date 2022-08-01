import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/models/user.dart' as user_model;
import 'package:insta_clone_flutter/providers/user_provider.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/responsiveness/mobile_screen_layout.dart';
import 'package:insta_clone_flutter/screens/add_post_screen.dart';
import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void navigateToAddPost() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const MobileScreenLayout(
              index: 2,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final user_model.UserInfo userInfo =
        Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      endDrawer: Drawer(
        backgroundColor: mobileBackgroundColor,
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Options"),
            ),
            ListTile(
              title: const Text("Log out"),
              onTap: () => AuthMethods().signOutUser(),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userInfo.username,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: navigateToAddPost,
              ),
              Builder(builder: (context) {
                return IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: const Icon(Icons.menu),
                );
              })
            ],
          )
        ],
      ),
    );
  }
}
