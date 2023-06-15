import 'dart:convert';

import 'package:http/http.dart';

import '../model/result.dart';
import '../model/result_update.dart';
import '../token/set_token.dart';

Future<List<Exam_result>> fetchExams() async {
  String? token = await getToken();

  Map<String, String> headers = {
    'x_authorization': token ?? '',
    'Content-Type': 'application/json',
  };
  final response = await get(Uri.parse('https://quiz-app-nodejs.onrender.com/v1/result'),headers: headers);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    List<dynamic> message = data['message'];

    return message.map<Exam_result>((item) => Exam_result.fromJson(item)).toList();
  } else {
    throw Exception('Failed to fetch exams');
  }
}

