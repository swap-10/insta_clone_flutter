import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/screens/add_post_screen.dart';

const webScreenSize = 600;

final dashboardItems = [
  const Center(
    child: Text("Home"),
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
