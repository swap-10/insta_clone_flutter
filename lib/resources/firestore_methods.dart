import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone_flutter/models/post.dart';
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
      String photoURL =
          await StorageMethods().uploadImageToStorage("Posts", file, true);

      String postID = const Uuid().v1();
      Post post = Post(
        uid: uid,
        description: description,
        postID: postID,
        datePosted: DateTime.now().toString(),
        postURL: photoURL,
        likes: [],
      );

      _firestore.collection('posts').doc(postID).set(post.toJSON());
      res = "Success!";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
