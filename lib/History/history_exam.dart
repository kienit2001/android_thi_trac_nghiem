import 'package:flutter/material.dart';

import '../API/delete_result.dart';
import '../API/getAPI_result.dart';
import '../model/result_update.dart';
import 'detail_history_exam.dart';

class History_exam extends StatefulWidget {
  const History_exam({Key? key}) : super(key: key);

  @override
  State<History_exam> createState() => _History_examState();
}

class _History_examState extends State<History_exam> {
  List<Exam_result> exams = [];
  bool isLoading = true;
  bool hasData = false;

  @override
  void initState() {
    super.initState();
    fetchExams().then((examList) {
      setState(() {
        exams = examList;
        isLoading = false;
        hasData = examList.isNotEmpty;
      });
    }).catchError((error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    });
  }

  void _deleteExam(String examId) {
    fetchDeleteResult(examId);
    setState(() {
      exams.removeWhere((exam) => exam.id == examId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : !hasData
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Không có lịch sử thi",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: exams.length,
                  itemBuilder: (context, index) {
                    final exam = exams[index];
                    return GestureDetector(
                      onTap: () {
                        // Handle the tap event here
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Detail_Exam_History(itemId: exam.id),
                          ),
                        );
                        // Perform any desired action when a list item is tapped
                      },
                      child: Card(
                        color: Colors.grey[100],
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            exam.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            exam.description,
                            style: TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Score: ${exam.score}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Perform delete action here
                                  _deleteExam(exam.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
