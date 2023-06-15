import 'dart:convert';

class User {
  final String id;
  List<int> image;
  String firstname;
  final String email;
  String lastname;
  final String username;

  User({
    required this.id,
    required this.image,
    required this.firstname,
    required this.email,
    required this.lastname,
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    String base64Image = json['image'];
    List<int> imageBytes = base64Decode(base64Image);

    return User(
      id: json['_id'],
      image: imageBytes,
      firstname: json['firstname'],
      email: json['email'],
      lastname: json['lastname'],
      username: json['username'],
    );
  }


User copyWith({
    String? id,
    List<int>? image,
    String? firstname,
    String? email,
    String? lastname,
    String? username,
  }) {
    return User(
      id: id ?? this.id,
      image: image ?? this.image,
      firstname: firstname ?? this.firstname,
      email: email ?? this.email,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
    );
  }

}
