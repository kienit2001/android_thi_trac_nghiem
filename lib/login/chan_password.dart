import 'package:flutter/material.dart';

import 'package:http/http.dart';


import '../token/set_token.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  bool _isLoading = false;

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });
    String? token = await getToken();

    Map<String, String> headers = {
      'x_authorization': token ?? '',
    };
    // Lấy giá trị từ các trường nhập liệu
    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;
    print(token ?? '');
    print(oldPassword);
    print(newPassword);
    // Gửi yêu cầu thay đổi mật khẩu đến máy chủ
    final response = await patch(
      Uri.parse('https://quiz-app-nodejs.onrender.com/v1/user/'),
      headers: headers,
      body: {
        "old_password": oldPassword,
        "new_password": newPassword
      },
    );



    // Kiểm tra phản hồi từ máy chủ
    if (response.statusCode == 200) {
      // Thay đổi thành công
      _showAlertDialog('Thành công', 'Thay đổi mật khẩu thành công!');

      // Chờ một khoảng thời gian ngắn để hiển thị thông báo
      await Future.delayed(Duration(seconds: 2));

      // Quay lại trang trước đó
      Navigator.pop(context);
    } else {
      // Thay đổi thất bại
      _showAlertDialog('Lỗi', 'Thay đổi mật khẩu thất bại!');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thay đổi mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu cũ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_open),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Thay đổi mật khẩu'),
            ),
          ],
        ),
      ),
    );
  }
}