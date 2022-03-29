import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/responsiveness/mobile_screen_layout.dart';
import 'package:insta_clone_flutter/responsiveness/web_screen_layout.dart';
import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/responsiveness/responsive_screen_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Insta Clone",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileScreenLayout(),
        webScreenLayout: WebScreenLayout(),
      ),
    );
  }
}
