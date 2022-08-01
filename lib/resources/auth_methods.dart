import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/resources/storage_methods.dart';
import 'package:insta_clone_flutter/models/user.dart' as UserModel;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel.UserInfo> getUserInfo() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot docSnap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.UserInfo.fromSnap(docSnap);
  }

  Future<String> signUpUser({
    required String email,
    required String username,
    required String password,
    required Uint8List file,
  }) async {
    String res = "An error occured";
    try {
      if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty) {
        // Register user with email and password
        UserCredential creds = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoURL = await StorageMethods()
            .uploadImageToStorage("ProfilePicture", file, false);

        UserModel.UserInfo userInfo = UserModel.UserInfo(
          username: username,
          uid: creds.user!.uid,
          email: email,
          bio: "",
          followers: [],
          following: [],
          dpURL: photoURL,
          postIDs: [],
        );

        await _firestore
            .collection('users')
            .doc(creds.user!.uid)
            .set(userInfo.toJSON());

        res = "Success!";
      } else {
        res = "Please complete all the fields.";
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "An error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential creds = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "Success!";
      } else {
        res = "Please complete all the fields.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  void signOutUser() {
    _auth.signOut();
  }
}
