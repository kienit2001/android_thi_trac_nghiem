import 'dart:convert';
import 'package:flutter/material.dart';

class QuizQuestion {
  final String questionText;
  final List<String> answers;
  final int correctAnswer;

  QuizQuestion({
    required this.questionText,
    required this.answers,
    required this.correctAnswer,
  });
}

class QuizPage extends StatefulWidget {
  final String jsonData;

  QuizPage({required this.jsonData});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<QuizQuestion> questions = [];
  int currentIndex = 0;
  int score = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  void loadQuestions() {
    Map<String, dynamic> jsonData = json.decode(widget.jsonData);
    List<dynamic> questionList = jsonData['questions'];
    questions = questionList.map((item) {
      return QuizQuestion(
        questionText: item['questionText'],
        answers: List<String>.from(item['answers']),
        correctAnswer: item['correctAnswer'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: questions.length,
        itemBuilder: (BuildContext context, int index) {
          return buildQuestionPage(questions[index]);
        },
        onPageChanged: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  Widget buildQuestionPage(QuizQuestion question) {
    return Column(
      children: [
        Text(
          question.questionText,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        ...question.answers.map((answer) {
          return ElevatedButton(
            onPressed: () {
              checkAnswer(question, answer);
              if (currentIndex < questions.length - 1) {
                pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Text(answer),
          );
        }),
      ],
    );
  }

  void checkAnswer(QuizQuestion question, String answer) {
    if (question.answers.indexOf(answer) == question.correctAnswer) {
      // Correct answer
      setState(() {
        score++;
      });
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
