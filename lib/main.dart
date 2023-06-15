import 'package:flutter/material.dart';
import 'package:new_project/model/user.dart';
import 'package:new_project/login/login.dart';
import 'package:new_project/test.dart';

import 'API/getAPIuser.dart';

void main() async{

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}