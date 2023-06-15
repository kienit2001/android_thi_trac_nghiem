import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:new_project/Thi/result_screen.dart';
import 'package:new_project/token/set_token.dart';

import '../API/getiduser.dart';
import '../model/answer.dart';
import '../model/cauhoi.dart';
import '../model/correctAnswer.dart';
import '../model/options.dart';
import '../model/result.dart';

class QuizScreen extends StatefulWidget {
  final String itemId; // Define the itemId variable

  const QuizScreen({Key? key, required this.itemId}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  DateTime startTime = DateTime.now(); // Add a variable to store the start time
  DateTime endTime = DateTime.now();
  bool _isTimerRunning = false; // Add a variable to store the end time
  int questionIndex = 0;
  bool isTimeUp = false;
  int remainingTime = 3600;
  bool _isLoading = false;
  bool isEnabled = true;
  Color buttonColor = Colors.grey;
  Color buttonColor_next = Colors.blue;

  // Initial time in seconds
  late Timer timer;
  bool isSubmitted = false;

  List quizListData = [];

  List<String> chudau = ["a", "b", "c", "d", "e", "f"];
  List<Answer> data = [];
  Exam? examgoc;

  Future<List<Answer>> fetchAnswers() async {
    final response = await get(Uri.parse(
        'https://quiz-app-nodejs.onrender.com/v1/exam/' + widget.itemId));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      print("ASA");
      // int time =  jsonData
      List<dynamic> correctAnswers =
          jsonData['message']['correctAnswers']; // Access correctAnswers
      // directly'
      int time = jsonData['message']['totalTime'];
      String examId = jsonData['message']['examId'];
      String name = jsonData['message']['name'];
      String createdBy = jsonData['message']['createdBy'];
      String description = jsonData['message']['description'];
      int totalTime = jsonData['message']['totalTime'];
      List<Correct_Answer> correctAnswerList =
          correctAnswers.map((answer) => Correct_Answer(answer)).toList();
      List<int> correctAnswers_int = [];
      correctAnswers.forEach((element) {
        correctAnswers_int.add(element);
      });
      // correctAnswerList.forEach((element) { print(element.a);});
      // print(correctAnswerList[0].a);
      List<dynamic> questionsJson = jsonData['message']['questions'];
      List<Answer> data = [];
      Exam exam;
      List<Question> question_String = [];
      int j = 0;
      for (var question in questionsJson) {
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
        answerList.forEach((element) {
          options.add(Options(
              option: chudau[i],
              value: element.toString(),
              color: '0xFFFFFFFF'));
          i++;
        });
        print(answerList[correctAnswerList[j].a]);
        data.add(Answer(
          id: id,
          answer: answerList[correctAnswerList[j].a].toString(),
          answer_discription: "",
          is_answered: 0,
          is_answer_status_right_wrong_omitted: 0,
          title: questionText,
          options: options,
        ));

        question_String.add(
            Question(questionText: questionText, answers: answerList_string));
        j++;
      }
      question_String.forEach((element) {
        print(element.questionText);
        print(element.answers);
      });

      exam = Exam(
          examId: examId,
          createdBy: createdBy,
          name: name,
          isPublic: true,
          description: description,
          totalTime: totalTime,
          questions: question_String,
          correctAnswers: correctAnswers_int);

      setState(() {
        remainingTime = time;
        examgoc = exam;
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
      print(examgoc?.toString());
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

  void startTimer() {
    startTime = DateTime.now(); // Set the start time

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if ((remainingTime < 1) || _isTimerRunning) {
        t.cancel();

        // Hết thời gian, tự động nộp bài
        quizResult(context);
      } else {
        setState(() {
          remainingTime -= 1;
        });
      }
    });
  }

  void stopTimer() {
    setState(() {
      timer.cancel();
      _isTimerRunning = true;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print("load");
    loadData();
    print(quizListData);
    // startTime = DateTime.now();
    startTimer();
    // startTimer();
  }

  final _pageController = PageController(initialPage: 1);
  int questionINdex = 1;

  int userPercentage = 0;
  int wrongQ = 0;
  int ommitedQuestion = 0;
  int totalRight = 0;

  Future<bool> quizResult(BuildContext context) async {
    stopTimer();
    // setState(() {
    //   _isLoading = true;
    // });
    endTime = DateTime.now(); // Set the end time
    print("vao");
    //
    // print(startTime);
    // print(endTime);
    print("vao");
    // Calculate the duration of the quiz
    Duration duration = endTime.difference(startTime);
    int secondsElapsed = duration.inSeconds;
    print(secondsElapsed);
    try {
      String? token = await getToken();

      Map<String, String> headers = {
        'x_authorization': token ?? '',
        'Content-Type': 'application/json',
      };

      List<int> userAnswers = [];

      print(examgoc.toString());
      print("id user");
      String? fetchUser = await fetchUserID();
      print(fetchUser);
      int j = 0;
      quizListData.forEach((element1) {
        int i = 0;
        print("adasd");
        print(element1['answer_discription'].toString());

        if (element1['answer_discription'].toString() == "") {
          userAnswers.add(-1);
        } else
          examgoc?.questions[j].answers.forEach((element) {
            print(element);
            if (element1['answer_discription'].toString().trim() ==
                element.toString().trim()) {
              print("jasbdjas");
              userAnswers.add(i);
            }
            i++;
          });
        j++;

        print(userAnswers);
      });
      examgoc?.questions.forEach((element) {});
      print("so giay:" + secondsElapsed.toString());
      print(examgoc?.toJson());
      String requestBody = jsonEncode({
        'timeFinish': secondsElapsed, // Pass the duration to the API
        'userId': fetchUser,
        'userAnswers': userAnswers,
        'exam': examgoc?.toJson(),
      });

      print(requestBody);

      Response response = await post(
        Uri.parse('https://quiz-app-nodejs.onrender.com/v1/result'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('post thanh cong');
      } else {
        final jsonData = json.decode(response.body);
        print(jsonData);
      }

      return true;
    } catch (e) {
      return false;
      print('loi');
      print(e.toString());
    }
  }

  String formatTime(int timeInSeconds) {
    int minutes = timeInSeconds ~/ 60;
    int seconds = timeInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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
                final buttonColor = answer.answer_discription == ""
                    ? Colors.white
                    : Colors.green;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    primary: buttonColor, // Thay đổi màu nút
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
    String remainingTimeString = formatTime(remainingTime);
    return Scaffold(
      backgroundColor: const Color(0xFF053251),
      appBar: AppBar(
        title: const Text("Quiz Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question :${questionINdex + 1}/${quizListData.length}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Time Remaining: $remainingTimeString",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
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

                      buttonColor_next = quizListData.length == 0
                          ? Colors.blue
                          : buttonColor_next = page < quizListData.length - 1
                              ? Colors.blue
                              : Colors.grey;
                      ;
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
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
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
                                    onPressed: () {
                                      // if ((quizListData[index]['is_answered'] == 0) ||
                                      //     (quizListData[index]['is_answered'] == 1 &&
                                      //         data['answer_discription'] !=
                                      //             data['value'])) {
                                      print("thay doi chonj");
                                      setState(() {
                                        // Set the color of the previously selected option to white
                                        quizListData[index]['options']
                                            .forEach((option) {
                                          option['color'] = "0xFFFFFFFF";
                                        });
                                        // Set the color of the currently selected option
                                        data['answer_discription'] = "";
                                        data['color'] = "0xFF31CD63";
                                        data['answer_discription'] =
                                            data['value'];
                                        print(data['answer_discription']);

                                        if (data['value'] ==
                                            quizListData[index]['answer']) {
                                          quizListData[index][
                                              'is_answer_status_right_wrong_omitted'] = 1;
                                        } else {
                                          quizListData[index][
                                              'is_answer_status_right_wrong_omitted'] = 2;
                                        }
                                        quizListData[index]['is_answered'] = 1;
                                        quizListData[index]
                                                ['answer_discription'] =
                                            data['answer_discription'];
                                      });
                                    },
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
                    onPressed: isEnabled ? _onButtonPressed : null,
                    label: Text("Back"),
                    backgroundColor: buttonColor,
                  ),
                  FloatingActionButton.extended(
                    onPressed: () {
                      print("Submit ");

                      showDialog(
                          context: context,
                          builder: (_) {
                            return Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              color: Colors.black.withOpacity(0.5),
                            );
                          });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Dang nop bai"),
                        ),
                      );
                      quizResult(context).then((value) {
                        if (value) {
                          userPercentage = 0;
                          wrongQ = 0;
                          ommitedQuestion = 0;
                          totalRight = 0;

                          for (int i = 0; i < quizListData.length; i++) {
                            if (quizListData[i]
                                    ['is_answer_status_right_wrong_omitted'] ==
                                0) {
                              ommitedQuestion++;
                            }
                            if (quizListData[i]
                                    ['is_answer_status_right_wrong_omitted'] ==
                                1) {
                              totalRight++;
                            }
                            if (quizListData[i]
                                    ['is_answer_status_right_wrong_omitted'] ==
                                2) {
                              wrongQ++;
                            }
                          }

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Nop bai xong"),
                            ),
                          );

                          userPercentage =
                              ((totalRight / quizListData.length) * 100)
                                  .round();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                userPercentage: userPercentage,
                                totalRight: totalRight,
                                wrongQ: wrongQ,
                                ommitedQuestion: ommitedQuestion,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("noi bai loi"),
                            ),
                          );
                        }
                      });
                    },
                    label: Text("Nộp bài"),
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

  void _onButtonPressed() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 6),
      curve: Curves.easeInBack,
    );
    // Button press logic
    print('Button pressed');
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
