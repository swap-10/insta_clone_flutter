import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/screens/add_post_screen.dart';
import 'package:insta_clone_flutter/screens/home_screen.dart';
import 'package:insta_clone_flutter/screens/profile_screen.dart';

const webScreenSize = 600;

final dashboardItems = [
  const HomeScreen(),
  const Center(
    child: Text("Explore"),
  ),
  const AddPostScreen(),
  const Center(
    child: Text("Notifications"),
  ),
  const ProfileScreen(),
];
