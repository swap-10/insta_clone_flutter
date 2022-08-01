import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

final dashboardItems = [
  Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Homiiie"),
      TextButton(
        onPressed: AuthMethods().signOutUser,
        child: const Text("Log out"),
      ),
    ],
  ),
  const Center(
    child: Text("Explore"),
  ),
  const AddPostScreen(),
  const Center(
    child: Text("Notifications"),
  ),
  const Center(
    child: Text("Profile"),
  ),
];
