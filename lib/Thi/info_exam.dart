import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_project/Thi/quiz_screen.dart';

class ExamInfoPage extends StatefulWidget {
  final String id;

  ExamInfoPage(this.id);

  @override
  _ExamInfoPageState createState() => _ExamInfoPageState();
}

class _ExamInfoPageState extends State<ExamInfoPage> {
  Map<String, dynamic> examInfo = {};
  String id_exam = "";

  @override
  void initState() {
    super.initState();
    fetchData();
    setState(() {});
  }

  void fetchData() async {
    try {
      print(widget.id);
      final response = await http.post(
          Uri.parse('https://quiz-app-nodejs.onrender.com/v1/exam/info-exam/'),
          body: {"examId": widget.id});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          examInfo = data['message'];
          id_exam = data['message']['_id'];
        });
      } else {
        print('Failed to fetch data from API');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bài thi '),
      ),
      body: Center(
        child: examInfo.isEmpty
            ? CircularProgressIndicator() // Hiển thị tiến trình khi đang lấy dữ liệu
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Tên Môn: ${examInfo['name']}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Thời gian thi: ${examInfo['totalTime']} giây',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Số câu thi: ${examInfo['totalQuestions']}',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Quay lại'),
                        onPressed: () {
                          Navigator.pop(context);
                          // Xử lý sự kiện khi nhấn nút Quay lại
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Thi'),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Xác nhận'),
                                content: Text('Bạn có chắc muốn bắt đầu thi?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuizScreen(
                                                  itemId: id_exam,
                                                )),
                                      );
                                      // Xử lý sự kiện khi nhấn nút Đồng ý
                                    },
                                    child: Text('Đồng ý'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Đóng dialog
                                    },
                                    child: Text('Hủy'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
