import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:new_project/home.dart';
import 'package:new_project/login/singup.dart';
import 'package:new_project/model/user.dart';
import 'package:new_project/token/set_token.dart';

import '../API/getAPIuser.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(String email, String password) async {
    print(email);
    print(password);
    try {
      Response response = await post(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/login'),
        body: {'username': email.trim(), 'password': password.trim()},
      );
      if (response.statusCode == 200) {
        print("account created successfully");
        final jsonData = json.decode(response.body);
        saveToken(
          jsonData['accessToken'].toString(),
          jsonData['refreshToken'].toString(),
        );
        User? user = await getUserData();
        print("login");
        print(user?.lastname);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else {
        print("failed");
        showErrorDialog(
            'Đăng nhập thất bại. Vui lòng kiểm tra thông tin đăng nhập của bạn.');
      }
    } catch (e) {
      print(e.toString());
      showErrorDialog('An error occurred while logging in.');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi đăng nhập'),
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

  void forgotPassword(String email) async {
    try {
      Response response = await post(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/forgot-password'),
        body: {
          'email': email.trim(),
        },
      );

      if (response.statusCode == 200) {
        print("Reset password request sent successfully");
        // Hiển thị thông báo cho người dùng rằng yêu cầu đã được gửi thành công
      } else {
        print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 30),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                login(
                  emailController.text.toString(),
                  passwordController.text.toString(),
                );
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                forgotPassword(emailController.text.toString());
              },
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
