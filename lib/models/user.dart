import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo {
  final String email;
  final String uid;
  final String username;
  final String dpURL;
  final String bio;
  final List followers;
  final List following;
  final List postIDs;

  const UserInfo({
    required this.email,
    required this.uid,
    required this.username,
    required this.dpURL,
    required this.bio,
    required this.followers,
    required this.following,
    required this.postIDs,
  });

  Map<String, dynamic> toJSON() {
    return {
      "email": email,
      "uid": uid,
      "username": username,
      "dpURL": dpURL,
      "bio": bio,
      "followers": followers,
      "following": following,
      "postIDs": postIDs,
    };
  }

  static UserInfo fromSnap(DocumentSnapshot docSnap) {
    var snapshot = docSnap.data() as Map<String, dynamic>;

    return UserInfo(
      email: snapshot['email'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      dpURL: snapshot['dpURL'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      postIDs: snapshot['postIDs'],
    );
  }
}
