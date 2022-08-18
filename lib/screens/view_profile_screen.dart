import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_flutter/models/user.dart' as user_model;
import 'package:insta_clone_flutter/providers/user_provider.dart';
import 'package:insta_clone_flutter/resources/auth_methods.dart';
import 'package:insta_clone_flutter/resources/firestore_methods.dart';
import 'package:insta_clone_flutter/responsiveness/mobile_screen_layout.dart';
import 'package:insta_clone_flutter/screens/add_post_screen.dart';
import 'package:insta_clone_flutter/utils/colors.dart';
import 'package:insta_clone_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class ViewProfileScreen extends StatefulWidget {
  final String uid;
  const ViewProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  String? uid;
  List readyImages = [];
  user_model.UserInfo? userInfo;

  @override
  void initState() {
    super.initState();
    uid = widget.uid;
    getUserData();
  }

  void getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => whenInfoReady(value));
  }

  void whenInfoReady(DocumentSnapshot docSnap) {
    userInfo = user_model.UserInfo.fromSnap(docSnap);
    Reference ref = FirebaseStorage.instance.ref().child('Posts').child(uid!);
    getImages(ref);
  }

  void getImages(Reference ref) async {
    List postIDList = userInfo!.postIDs;
    List imageReferenceList = [];
    for (String postID in postIDList.reversed) {
      imageReferenceList.add(ref.child(postID));
    }
    setState(() {});
    await downloadImages(imageReferenceList);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> downloadImages(List? imageReferences) async {
    for (Reference item in imageReferences!) {
      readyImages.add(await item.getDownloadURL());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: userInfo == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            userInfo!.username,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 0.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: Image.network(userInfo!.dpURL).image,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                userInfo!.postIDs.length.toString(),
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
                                userInfo!.followers.length.toString(),
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
                                userInfo!.following.length.toString(),
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
                          userInfo!.username,
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
                          userInfo!.bio,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 16.0,
                    thickness: 4.0,
                  ),
                  readyImages.isNotEmpty
                      ? Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            itemCount: readyImages.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemBuilder: (BuildContext context, int idx) {
                              return GridTile(
                                child: Image(
                                  image: Image.network(readyImages[idx]).image,
                                ),
                              );
                            },
                          ),
                        )
                      : const CircularProgressIndicator()
                ],
              ),
      ),
    );
  }
}
