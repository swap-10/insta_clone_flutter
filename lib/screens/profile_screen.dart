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

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List readyImages = [];
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
  }

  void getUserData() async {
    await _userProvider!.refreshUser().then((value) => whenInfoReady());
  }

  void whenInfoReady() {
    userInfo = _userProvider!.getUser;
    String uid = userInfo!.uid;
    Reference ref = FirebaseStorage.instance.ref().child('Posts').child(uid);
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
    if (this.mounted) {
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
    _userProvider!.refreshUser();
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
        child: userInfo == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
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
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 16.0, 32.0, 0.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          child: ClipOval(
                            child: Image.network(
                              userInfo!.dpURL,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfileScreen(userInfo: userInfo!),
                                ),
                              );
                              setState(() {
                                _userProvider!.refreshUser();
                              });
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit Profile"),
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
                                  image: NetworkImage(readyImages[idx]),
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

class EditProfileScreen extends StatefulWidget {
  final user_model.UserInfo userInfo;
  const EditProfileScreen({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _image;
  final TextEditingController? _usernameController = TextEditingController();
  final TextEditingController? _bioController = TextEditingController();
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfileChanges() async {
    String res = await FirestoreMethods().updateUserProfile(
      widget.userInfo.uid,
      _image,
      _usernameController!.text,
      _bioController!.text,
    );
    if (res == "Success!") {
      showSnackBar("Successfully updated", Colors.green, context);
    } else {
      showSnackBar(res, Colors.red, context);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _usernameController!.text = widget.userInfo.username;
    _bioController!.text = widget.userInfo.bio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Edit Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
            child: IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.blue,
              ),
              onPressed: () => saveProfileChanges(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    child: ClipOval(
                      child: _image == null
                          ? Image.network(
                              widget.userInfo.dpURL,
                              width: 120,
                              height: 100,
                            )
                          : Image.memory(_image!),
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: selectImage,
                    ),
                    bottom: -2.0,
                    right: -10.0,
                  ),
                ],
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "username",
                ),
              ),
              TextField(
                controller: _bioController,
                decoration: const InputDecoration(
                  labelText: "bio",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
