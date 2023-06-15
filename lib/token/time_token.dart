import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:new_project/token/set_token.dart';

// Hàm để set token
void setToken(String token,String refreshToken) {

  // Gọi hàm để lưu trữ token vào bộ nhớ
  saveToken(token,refreshToken);
  // Cập nhật token trong ứng dụng của bạn
  // Ví dụ: updateToken(token);
}

// Hàm để lấy token mới sau một khoảng thời gian
void getTokenAfterDelay() {
  const duration = Duration(minutes: 5);

  Timer(duration, () async {
    print("get time moi ");
    String? token = await getToken();
    String? refreshToken = await getRefreshToken();
    if (token != null && refreshToken != null) {
      print(token);
      print(refreshToken);
      getAPIRefreshToken(token, refreshToken);
    }
  });
}

void getAPIRefreshToken(String token,refreshToken) async {
  try {
    print("get......");
    print(token);
    print(refreshToken);
    Map<String, String> headers = {'x_authorization': token};
    Response response = await post(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/refresh'),
        headers: headers,
        body: {
          "refreshToken" :refreshToken
        }
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      saveToken(jsonData['accessToken'].toString(),refreshToken);

    } else {
      print("failed");
    }
  }
  catch (e) {
    print(e.toString());
  }
}