import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_project/model/user.dart';

import '../token/set_token.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;
  final ValueNotifier<User?> userNotifier;

  const EditProfilePage(this.user, this.userNotifier, {super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  late Uint8List _imageData;

  @override
  void initState() {
    super.initState();

    _imageData = Uint8List.fromList(widget.user!.image);
    _firstNameController.text = widget.user!.firstname;
    _lastNameController.text = widget.user!.lastname;
  }
  //
  Future<void> patchData(String firstName, String lastName, Uint8List yourImageBytes) async {
    print("vào");
    var url = Uri.parse('https://quiz-app-nodejs.onrender.com/v1/user/update');

    // Tạo request
    var request = MultipartRequest('PATCH', url);
    String? token = await getToken();

    request.headers['x_authorization'] = ' $token';

    // Thêm các trường dữ liệu vào form-data
    request.fields['firstname'] = firstName;
    request.fields['lastname'] = lastName;

    // Chuyển đổi Uint8List thành Stream<List<int>> để tạo multipart file
    Uint8List imageBytes = yourImageBytes;
    var stream = ByteStream.fromBytes(imageBytes)
    ;
    var length = imageBytes.length;
    var multipartFile = MultipartFile('image', stream, length, filename: 'image.jpg');
    request.files.add(multipartFile);
    print('123123');
    // Gửi request và xử lý phản hồi
    var response = await request.send();
    print('ádas');
    if (response.statusCode == 200) {
      print('Patch thành công!');
    } else {
      print('Patch thất bại!');
    }
  }
  void _saveChanges() {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    Uint8List? image = _imageData;
    patchData(firstName,lastName,image);

    List<int> intList = image.toList();
    print(widget.user?.firstname);
    print(firstName);
    if (widget.user != null) {
      widget.user!.firstname = firstName;
      widget.user!.lastname = lastName;
      widget.user?.image = intList;
    }

    print("sau uaudate");
    print(widget.user?.firstname);

    widget.userNotifier.value = widget.user!
        .copyWith(firstname: firstName, lastname: lastName,image:intList );
    // Navigate back to the profile page


    Navigator.pop(context, widget.user);
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _imageData = Uint8List.fromList(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Choose Image'),
              onTap: _pickImage,
            ),
            SizedBox(height: 16),
            if (_imageData != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: MemoryImage(_imageData!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
