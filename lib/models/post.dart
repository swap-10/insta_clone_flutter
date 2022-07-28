import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String description;
  final String postID;
  final String datePosted;
  final String postURL;
  final likes;

  const Post({
    required this.uid,
    required this.description,
    required this.postID,
    required this.datePosted,
    required this.postURL,
    required this.likes,
  });

  Map<String, dynamic> toJSON() {
    return {
      "uid": uid,
      "description": description,
      "postID": postID,
      "datePosted": datePosted,
      "postURL": postURL,
      "likes": likes,
    };
  }

  static Post fromSnap(DocumentSnapshot docSnap) {
    var snapshot = docSnap.data() as Map<String, dynamic>;

    return Post(
      uid: snapshot['uid'],
      description: snapshot['description'],
      postID: snapshot['postID'],
      datePosted: snapshot['datePosted'],
      postURL: snapshot['postURL'],
      likes: snapshot['likes'],
    );
  }
}
