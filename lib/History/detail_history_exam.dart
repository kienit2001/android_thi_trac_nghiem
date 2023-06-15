import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../model/answer.dart';
import '../model/cauhoi.dart';
import '../model/correctAnswer.dart';
import '../model/options.dart';
import '../token/set_token.dart';

class Detail_Exam_History extends StatefulWidget {
  final String itemId;

  const Detail_Exam_History({Key? key, required this.itemId}) : super(key: key);

  @override
  State<Detail_Exam_History> createState() => _Detail_Exam_HistoryState();
}

class _Detail_Exam_HistoryState extends State<Detail_Exam_History> {
  int questionIndex = 0;
  bool isTimeUp = false;
  int remainingTime = 3600;

  // Initial time in seconds
  late Timer timer;
  bool isSubmitted = false;

  List quizListData = [];
  List<Correct_Answer> selected_Answer_root = [];
  List<String> chudau = ["a", "b", "c", "d", "e", "f"];
  List<Answer> data = [];
  bool isEnabled = true;
  Color buttonColor = Colors.blue;
  Color buttonColor_next = Colors.blue;

  // Exam? examgoc;

  Future<List<Answer>> fetchAnswers() async {
    String? token = await getToken();

    Map<String, String> headers = {
      'x_authorization': token ?? '',
    };
    final response = await get(
        Uri.parse(
            'https://quiz-app-nodejs.onrender.com/v1/result/' + widget.itemId),
        headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      print("ASA");
      List<dynamic> correctAnswers = jsonData['message']['exam']
          ['correctAnswers']; // Access correctAnswers directly'
      // String examId = jsonData['message']['examId'];
      // String name = jsonData['message']['name'];
      // String createdBy = jsonData['message']['createdBy'];
      // String description = jsonData['message']['description'];
      int totalTime = jsonData['message']['exam']['totalTime'];
      List<Correct_Answer> correctAnswerList =
          correctAnswers.map((answer) => Correct_Answer(answer)).toList();
      List<dynamic> selected_answer = jsonData['message']['userAnswers']; //
      List<Correct_Answer> selected_Answer =
          selected_answer.map((answer) => Correct_Answer(answer)).toList();
      List<int> correctAnswers_int = [];
      correctAnswers.forEach((element) {
        correctAnswers_int.add(element);
      });
      // correctAnswerList.forEach((element) { print(element.a);});
      // print(correctAnswerList[0].a);
      List<dynamic> questionsJson = jsonData['message']['exam']['questions'];
      List<Answer> data = [];

      int j = 0;
      for (var question in questionsJson) {
        int dung = 1;
        String id = question['_id'];
        String questionText = question['questionText'];
        List<dynamic> answers = question['answers'];
        // List<String> answerList_String = answers
        //     .map((answer) => String(answer))
        //     .toList();
        List<Cauhoi> answerList =
            answers.map((answer) => Cauhoi(answer)).toList();
        List<String> answerList_string = [];
        answerList.forEach((element) {
          answerList_string.add(element.a);
        });

        // int correctAnswer = question["correctAnswer"];
        List<Options> options = [];
        int i = 0;
        print("bat dau chu ky moi");
        print(selected_Answer[j].a);

        if (selected_Answer[j].a == -1 || selected_Answer.length < j + 1) {
          answerList.forEach((element) {
            print("vaoday");
            print(correctAnswerList[j].a);
            // print(selected_Answer[j].a);
            print(element);
            if ((answerList[correctAnswerList[j].a] == element))
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFFC51456'));
            else
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFFFFFFFF'));
            i++;
            print("hetloi");
          });
        } else {
          answerList.forEach((element) {
            print(correctAnswerList[j].a);
            print(selected_Answer[j].a);
            print(element);

            if ((answerList[correctAnswerList[j].a] ==
                    answerList[selected_Answer[j].a]) &&
                (answerList[correctAnswerList[j].a] == element)) {
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFF31CD63'));
              dung = 2;
            } else if ((answerList[correctAnswerList[j].a] == element) &&
                (answerList[selected_Answer[j].a] != element)) {
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFF31CD63'));
            } else if ((answerList[correctAnswerList[j].a] != element) &&
                (answerList[selected_Answer[j].a] == element)) {
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFFC51456'));
            } else
              options.add(Options(
                  option: chudau[i],
                  value: element.toString(),
                  color: '0xFFFFFFFF'));
            i++;
          });
        }
        print(dung);
        // print();
        data.add(Answer(
          id: id,
          answer: answerList[correctAnswerList[j].a].toString(),
          answer_discription: selected_Answer[j].a != -1
              ? answerList[selected_Answer[j].a].toString()
              : "",
          is_answered: 0,
          is_answer_status_right_wrong_omitted: dung,
          title: questionText,
          options: options,
        ));

        // question_String.add(
        //     Question(questionText: questionText, answers: answerList_string));
        j++;
        print("het 1chu ky");
      }
      // question_String.forEach((element) {
      //   print(element.questionText);
      //   print(element.answers);
      // });

      /* exam = Exam(
          examId: examId,
          createdBy: createdBy,
          name: name,
          isPublic: true,
          description: description,
          totalTime: totalTime,
          questions: question_String,
          correctAnswers: correctAnswers_int);*/

      setState(() {
        selected_Answer_root = selected_Answer;
      });
      // print(exam.toString());
      return data;
    } else {
      throw Exception('Failed to fetch answers');
    }
  }

  void loadData() async {
    try {
      // Fetch data from API and get jsonString
      List<Answer> fetchedData = await fetchAnswers();
      // print(examgoc?.toString());
      List<Map<String, dynamic>> quizz =
          fetchedData.map((answer) => answer.toJson()).toList();
      String jsonString = jsonEncode(quizz);
      print(jsonString);

      // Update quizListData with data from jsonString
      List<dynamic> decodedData = jsonDecode(jsonString);
      List<Map<String, dynamic>> updatedQuizListData = [];
      for (var item in decodedData) {
        updatedQuizListData.add(item);
      }

      setState(() {
        quizListData = updatedQuizListData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  // void startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
  //     if (remainingTime < 1) {
  //       t.cancel();
  //       // Hết thời gian, tự động nộp bài
  //       quizResult(context);
  //     } else {
  //       setState(() {
  //         remainingTime -= 1;
  //       });
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    print("load");
    loadData();
    selected_Answer_root.forEach((element) {
      print(element.toString());
    });
    print(quizListData);
    // startTimer();
    // startTimer();
  }

  final _pageController = PageController(initialPage: 1);
  int questionINdex = 1;

  int userPercentage = 0;
  int wrongQ = 0;
  int ommitedQuestion = 0;
  int totalRight = 0;

  void showQuestionPopup(
    BuildContext context,
    List<Answer> questions,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Danh sách câu hỏi'),
          backgroundColor: Colors.blue, // Thay đổi màu nền của hộp thoại
          content: Container(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              children: List.generate(questions.length, (index) {
                final answer = questions[index];
                final buttonColor =
                    questions[index].is_answer_status_right_wrong_omitted == 1
                        ? Colors.red
                        : Colors.green;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: buttonColor,
                  ),
                  child: Text(
                    'Câu ${index + 1}',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 5),
                      curve: Curves.easeIn,
                    );
                    Navigator.pop(context);
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // String remainingTimeString = formatTime(remainingTime);
    return Scaffold(
      backgroundColor: const Color(0xFF053251),
      appBar: AppBar(
        title: const Text("Quiz Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Question :${questionINdex + 1}/${quizListData.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Chuyển đổi chuỗi JSON thành danh sách câu hỏi

                      List<Answer> questions = [];
                      print(quizListData);

                      try {
                        // Chuyển đổi chuỗi JSON thành danh sách câu hỏi

                        print(quizListData);
                        if (quizListData is List) {
                          questions = quizListData
                              .map((json) => Answer.fromJson(json))
                              .toList();
                        }
                      } catch (e) {
                        print('Lỗi khi phân tích chuỗi JSON: $e');
                      }
                      showQuestionPopup(context, questions);
                    },

                    icon: Icon(Icons.account_balance_wallet_outlined),
                    splashColor: Colors.grey.withOpacity(0.5),
                    // Color when the button is tapped
                    highlightColor: Colors.transparent,
                    // Color when the button is held down
                    iconSize: 30.0,
                    // Size of the icon
                    padding: EdgeInsets.all(12.0),
                    // Padding around the icon
                    color: Colors.blue,
                    // Color of the button
                  ),
                ),
              ],
            ),

            // Text(
            //   "Time Remaining: $remainingTimeString",
            //   style: const TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //     color: Colors.white,
            //   ),
            // ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: quizListData.length,
                onPageChanged: (page) {
                  print("Current page $page");

                  // print(quizListData);
                  // getApi();
                  setState(
                    () {
                      questionINdex = page;
                      buttonColor = page > 0 ? Colors.blue : Colors.grey;
                      buttonColor_next = page < quizListData.length - 1
                          ? Colors.blue
                          : Colors.grey;
                    },
                  );
                },
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFAB40),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            quizListData[index]['title'],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      quizListData[index]
                                  ['is_answer_status_right_wrong_omitted'] ==
                              1
                          ? Text(
                              "Câu Đúng là: -> ${quizListData[index]['answer']} ",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : const SizedBox(),
                      SizedBox(
                        height: 20,
                      ),
                      ...quizListData[index]['options']
                          .map(
                            (data) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(
                                        int.parse(
                                          data['color'],
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),

                                    onPressed: () {},

                                    // } else {}

                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Color(
                                                int.parse(
                                                  data['color'],
                                                ),
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                data['option'].toUpperCase(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          child: Text(
                                            data['value'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 6),
                        curve: Curves.easeInBack,
                      );
                    },
                    label: Text("Back"),
                    backgroundColor: buttonColor,
                  ),

// Wrap the FloatingActionButton with IgnorePointer and Opacity widgets

                  FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text("Quay Lại"),
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 5),
                        curve: Curves.easeIn,
                      );
                    },
                    label: Text("Next"),
                    backgroundColor: buttonColor_next,
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

// void submitQuiz(BuildContext context) {
//   // Hàm này sẽ được gọi khi hết thời gian và bạn muốn tự động nộp bài
//   // Gọi API hoặc thực hiện hành động nộp bài tại đây
//   quizResult(context);
// }

// String formatTime(int seconds) {
//   int minutes = seconds ~/ 60;
//   int remainingSeconds = seconds % 60;
//   String minutesStr = minutes.toString().padLeft(2, '0');
//   String secondsStr = remainingSeconds.toString().padLeft(2, '0');
//   return "$minutesStr:$secondsStr";
// }
