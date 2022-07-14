class UserInfo {
  final String email;
  final String uid;
  final String username;
  final String dpURL;
  final String bio;
  final List followers;
  final List following;

  const UserInfo({
    required this.email,
    required this.uid,
    required this.username,
    required this.dpURL,
    required this.bio,
    required this.followers,
    required this.following,
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
    };
  }
}
