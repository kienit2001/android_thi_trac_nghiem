import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Thi/info_exam.dart';
import 'model/test.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({Key? key}) : super(key: key);

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  TextEditingController searchController = TextEditingController();
  TextEditingController examCodeController = TextEditingController();
  String searchQuery = '';
  String examCode = '';

  List<Test> test_root = [];

  @override
  void dispose() {
    searchController.dispose();
    examCodeController.dispose();
    super.dispose();
  }

  Future<List<Test>> fetchTests() async {
    final response = await get(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/exam/all/'));
    // print("get api");
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List<dynamic> testList = jsonData['exams'];
      // print("object");
      List<Test> tests = testList.map((json) => Test.fromJson(json)).toList();
      print("---------------");
      // print(tests);
      return tests;
      // }else {
      //   throw Exception('Invalid API response');
      // }
    } else {
      throw Exception('Failed to fetch tests');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    // print(test);
    // print("load data");
  }

  void loadData() async {
    try {
      // print("get");
      List<Test> test = await fetchTests();
      // print("add thanh cong");
      // In danh sách các đối tượng Test
      // test.forEach((test) {
      //   print('ID: ${test.id}');
      //   print('Name: ${test.name}');
      //   print('Dec: ${test.dec}');
      //   print('img: ${test.img}');
      //   print('-----------------------------');
      // });
      setState(() {
        test_root = test;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void showInvalidExamCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sai mã bài thi'),
          content: Text('Vui lòng nhập lại mã bài thi để tiếp tục thi !'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void fetchData(String examCode) async {
    try {
      final response = await post(
          Uri.parse('https://quiz-app-nodejs.onrender.com/v1/exam/info-exam/'),
          body: {"examId": examCode});
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExamInfoPage(examCode)),
        );
      } else {
        showInvalidExamCodeDialog(context); // Show the dialog
        print("ex sai");
      }
      ;
    } catch (error) {
      print('Error: $error');
    }
  }

  void startExam() {
    // TODO: Handle starting the exam with the entered code
    print('Start exam with code: $examCode');
    fetchData(examCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // barappBar: AppBar(
      //   title: Text("Home"),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                      searchQuery = '';
                    });
                  },
                ),
                filled: true,
                fillColor: Color(0xFFF2F2F2),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                TextField(
                  controller: examCodeController,
                  onChanged: (value) {
                    setState(() {
                      examCode = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Mã bài thi',
                    prefixIcon: Icon(Icons.code, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: startExam,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      'Thi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    // Set the button's background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.count(
              childAspectRatio: 1.5,
              crossAxisCount: 2,
              children: test_root
                  .where((item) =>
                      item.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      item.dec
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                  .map((item) {
                return TextItem(item: item);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TextItem extends StatelessWidget {
  const TextItem({Key? key, required this.item}) : super(key: key);

  final Test item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("click ${item.name}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExamInfoPage(item.ExamID)),
        );
      },
      splashColor: Colors.red,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Ink.image(
              image: MemoryImage(
                Uint8List.fromList(item.img),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.dec,
                    style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
