import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:insta_clone_flutter/models/user.dart' as user_model;
import 'package:insta_clone_flutter/providers/user_provider.dart';
import 'package:insta_clone_flutter/responsiveness/mobile_screen_layout.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> items = List<String>.generate(10000, (i) => 'Item $i');
  List postIDs = [];
  UserProvider? _userProvider;
  user_model.UserInfo? userInfo;
  void navigateToAddPost() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MobileScreenLayout(
          index: 2,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of(context, listen: false);
    getUserData();
    // userInfo = _userProvider!.getUser;
    // postIDs = userInfo.postIDs.reversed.toList();
  }

  void getUserData() async {
    await _userProvider!.refreshUser().then((value) => whenInfoReady());
  }

  void whenInfoReady() {
    userInfo = _userProvider!.getUser;
    String uid = userInfo!.uid;
    Reference ref = FirebaseStorage.instance.ref().child('Posts').child(uid);
    postIDs = userInfo!.postIDs.reversed.toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // _userProvider.refreshUser();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/Instagram_logo_written.svg',
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: navigateToAddPost,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            postIDs.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 8.0,
                        );
                      },
                      itemCount: postIDs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: FullScreenPost(
                            userInfo: userInfo!,
                            postID: postIDs[index].toString(),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class FullScreenPost extends StatefulWidget {
  final user_model.UserInfo userInfo;
  final String postID;
  const FullScreenPost({Key? key, required this.userInfo, required this.postID})
      : super(key: key);

  @override
  State<FullScreenPost> createState() => _FullScreenPostState();
}

class _FullScreenPostState extends State<FullScreenPost> {
  late user_model.UserInfo userInfo;
  String? postURL;

  @override
  void initState() {
    super.initState();
    userInfo = widget.userInfo;
    Reference ref =
        FirebaseStorage.instance.ref().child('Posts').child(userInfo.uid);
    getImage(ref);
  }

  getImage(Reference ref) async {
    ref = ref.child(widget.postID);
    postURL = await ref.getDownloadURL();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: Image.network(userInfo.dpURL).image,
              radius: 17.0,
            ),
            const Padding(padding: EdgeInsets.only(left: 8.0)),
            Text(
              userInfo.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 8.0)),
        Card(
          child: postURL == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Image.network(postURL!),
        ),
      ],
    );
  }
}
