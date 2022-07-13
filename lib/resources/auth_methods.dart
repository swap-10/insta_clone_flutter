import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone_flutter/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

        await _firestore.collection('users').doc(creds.user!.uid).set({
          'username': username,
          'uid': creds.user!.uid,
          'email': email,
          'bio': "",
          'followers': [],
          'following': [],
          "DP_url": photoURL,
        });

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
}