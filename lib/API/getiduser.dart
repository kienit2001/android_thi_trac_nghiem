

import 'dart:convert';

import 'package:http/http.dart';

import '../token/set_token.dart';

Future<String> fetchUserID() async {
  String? token = await getToken();

  Map<String, String> headers = {
    'x_authorization': token ?? '',
    'Content-Type': 'application/json',
  };
    final response = await get(Uri.parse('https://quiz-app-nodejs.onrender.com/v1/user'),
        headers: headers
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['user']['_id'].toString();
    }else {
      throw Exception('Failed to fetch answers');
    }
    return "";
    }