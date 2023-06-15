

import 'dart:convert';

import 'package:http/http.dart';

import '../model/user.dart';
import '../token/set_token.dart';

Future<User?> getUserData() async {
  String? token = await getToken();

  Map<String, String> headers = {
    'x_authorization': token ?? '',
    'Content-Type': 'application/json',
  };
  var url = Uri.parse('https://quiz-app-nodejs.onrender.com/v1/user');
  var response = await get(url,headers: headers);

  if (response.statusCode == 200) {
    print("loi");
    var jsonData = jsonDecode(response.body);
    var user = User.fromJson(jsonData['user']);
    print("loi tai day");
    print('User ID: ${user.id}');
    print('First Name: ${user.firstname}');
    print('Last Name: ${user.lastname}');
    return user;
    // ...
  } else {
    print('Failed to fetch user data. Error: ${response.statusCode}');
  }
}