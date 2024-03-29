import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone_flutter/models/post.dart';
import 'package:insta_clone_flutter/models/user.dart' as user_model;
import 'package:insta_clone_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String uid,
    String description,
    Uint8List file,
  ) async {
    String res = "An error occured!";
    try {
      String postID = const Uuid().v1();
      String photoURL = await StorageMethods()
          .uploadImageToStorage("Posts", file, true, postID);

      Post post = Post(
        uid: uid,
        description: description,
        postID: postID,
        datePosted: DateTime.now().toString(),
        postURL: photoURL,
        likes: [],
      );

      _firestore.collection('posts').doc(postID).set(post.toJSON());
      res = await updateUserPosts(uid, postID);
      res = "Success!";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> updateUserPosts(
    String uid,
    String postID,
  ) async {
    String res = "Something went wrong";
    try {
      DocumentSnapshot docSnap =
          await _firestore.collection('users').doc(uid).get();
      user_model.UserInfo userInfo = user_model.UserInfo.fromSnap(docSnap);
      List currentPostIDs = userInfo.postIDs;
      currentPostIDs.add(postID);

      _firestore
          .collection('users')
          .doc(uid)
          .update({"postIDs": currentPostIDs});
      res = "Success!";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> updateUserProfile(
      String uid, Uint8List? image, String username, String bio) async {
    String res = "Something went wrong";
    try {
      if (image != null) {
        String dpURL = await StorageMethods()
            .uploadImageToStorage("ProfilePicture", image, false);
        _firestore.collection('users').doc(uid).update({"dpURL": dpURL});
        print("DP Updated");
      }

      _firestore.collection('users').doc(uid).update({"username": username});
      _firestore.collection('users').doc(uid).update({"bio": bio});

      res = "Success!";
    } catch (err) {
      res = err.toString();
    }

    return res;
  }
}
