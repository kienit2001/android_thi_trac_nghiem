import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  File? _imageFile;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Error messages for each field
  String _firstnameError = '';
  String _lastnameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _usernameError = '';

  Future<void> _chooseImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  Future<void> _signUp() async {
    // Reset the error messages
    setState(() {
      _firstnameError = '';
      _lastnameError = '';
      _emailError = '';
      _passwordError = '';
      _usernameError = '';
    });

    // Check if any required field is empty
    if (_firstnameController.text.isEmpty) {
      setState(() {
        _firstnameError = 'Please enter your first name';
      });
    }
    if (_lastnameController.text.isEmpty) {
      setState(() {
        _lastnameError = 'Please enter your last name';
      });
    }
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
    }
    if (_usernameController.text.isEmpty) {
      setState(() {
        _usernameError = 'Please enter your username';
      });
    }

    // If any error exists, stop the sign-up process
    if (_firstnameError.isNotEmpty ||
        _lastnameError.isNotEmpty ||
        _emailError.isNotEmpty ||
        _passwordError.isNotEmpty ||
        _usernameError.isNotEmpty) {
      return;
    }
    var request = http.MultipartRequest('POST', Uri.parse('https://quiz-app-nodejs.onrender.com/v1/register'));
    print(_firstnameController.text);
    print(_lastnameController.text);
    print(_emailController.text);
    print(_passwordController.text);
    print(_firstnameController.text);
    if (_firstnameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      _showErrorMessage('Please fill in all fields');
      return;
    }
    // Thêm các trường thông tin vào form-data
    request.fields['firstname'] = _firstnameController.text;
    request.fields['lastname'] = _lastnameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['password'] = _passwordController.text;
    request.fields['username'] = _usernameController.text;

    // Kiểm tra nếu có ảnh được chọn
    if (_imageFile != null) {
      var imageBytes = await _imageFile!.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes('image', imageBytes, filename: 'image.jpg');
      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print("them thanh cong");
        // Xử lý phản hồi thành công
        // var responseData = await response.stream.toBytes();
        // var responseString = utf8.decode(responseData);
        // var jsonData = json.decode(responseString);
        // Tiếp tục xử lý dữ liệu trả về nếu cần thiết

        // Show success message
        _showSuccessMessage();

        // Navigate back to the login screen
        Navigator.pop(context);
      } else  {
        // Xử lý các lỗi khác
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý ngoại lệ
      print('Exception: $e');

      // Hiển thị dialog thông báo
    }
    // Rest of the code...
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign up successful!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text('Sign Up')),
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                  ),
                  if (_firstnameError.isNotEmpty)
                    Text(
                      _firstnameError,
                      style: TextStyle(color: Colors.red),
                    ),
                  TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                    ),
                  ),
                  if (_lastnameError.isNotEmpty)
                    Text(
                      _lastnameError,
                      style: TextStyle(color: Colors.red),
                    ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  if (_emailError.isNotEmpty)
                    Text(
                      _emailError,
                      style: TextStyle(color: Colors.red),
                    ),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  if (_passwordError.isNotEmpty)
                    Text(
                      _passwordError,
                      style: TextStyle(color: Colors.red),
                    ),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  if (_usernameError.isNotEmpty)
                    Text(
                      _usernameError,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20.0),
                  TextButton(
                    onPressed: _chooseImage,
                    child: Text('Choose Image'),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _signUp,
                    child: Text('Sign Up'),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text('Are you sure you want to exit the sign-up process?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text('Confirm'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Quay Lại'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
