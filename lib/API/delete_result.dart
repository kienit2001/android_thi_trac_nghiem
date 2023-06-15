import 'package:http/http.dart';

import '../token/set_token.dart';

void fetchDeleteResult(String id) async {
  String? token = await getToken();

  Map<String, String> headers = {
    'x_authorization': token ?? '',
    'Content-Type': 'application/json',
  };
  final response = await delete(
      Uri.parse('https://quiz-app-nodejs.onrender.com/v1/result/' + id),
      headers: headers);

  if (response.statusCode == 200) {
    print("delete thanh cong");
  } else {
    throw Exception('Failed to fetch exams');
  }
}
