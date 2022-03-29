import 'package:flutter/material.dart';

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
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text("Instagram Clone")),
        body: const Center(
          child: Text("Instagram Clone Home Page"),
        ),
      ),
    );
  }
}
