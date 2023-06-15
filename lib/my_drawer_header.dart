import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/model/user.dart';
import 'package:new_project/token/set_token.dart';

class MyHeaderDrawer extends StatefulWidget {
  final User user;

  const MyHeaderDrawer({Key? key, required this.user}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  Uint8List? imageData;
  String? token;

  bool isLoading =
      true; // Thêm biến isLoading để kiểm tra trạng thái tải dữ liệu

  @override
  void initState() {
    super.initState();
    // getImageData();
    setState(() {
      imageData = Uint8List.fromList(widget.user.image);
    });
  }

  Future<void> getImageData() async {
    token = await getToken();
    if (token != null) {
      final headers = {
        'x_authorization': token!,
        'Content-Type': 'application/json',
      };

      final response = await http.get(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/user'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final bufferData = jsonResponse['user']['image']['data'];
        final List<int> intList = List<int>.from(bufferData);
        setState(() {
          imageData = Uint8List.fromList(intList);
        });
        print(bufferData.toString());
        setState(() {
          imageData = Uint8List.fromList(bufferData);
        });
      } else {
        print('Failed to load image: ${response.statusCode}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return Container(
    //     color: Colors.green[700],
    //     width: double.infinity,
    //     height: 200,
    //     padding: EdgeInsets.only(top: 20.0),
    //     child: Center(
    //       child: CircularProgressIndicator(), // Hiển thị CircularProgressIndicator khi đang tải dữ liệu
    //     ),
    //   );
    // }

    // if (user?.lastname == null) {
    //   return Container(); // Hoặc có thể hiển thị một tiến trình tải dữ liệu
    // }

    return Container(
      color: Colors.green[700],
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: 70, // Thay đổi kích thước container
            height: 70, // Thay đổi kích thước container
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: imageData != null
                  ? DecorationImage(
                      image: MemoryImage(imageData!),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: AssetImage('assets/images/img.png'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Text(
            '${widget.user.firstname} ${widget.user.lastname}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            widget.user.email,
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
