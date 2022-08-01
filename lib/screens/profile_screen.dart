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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 0.0),
                  child: CircleAvatar(
                    radius: 50.0,
                    child: ClipOval(
                      child: Image.network(
                        userInfo.dpURL,
                        width: 120,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          userInfo.postIDs.length.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Posts",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          userInfo.followers.length.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Followers",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          userInfo.following.length.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Following",
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userInfo.username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    userInfo.bio,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
