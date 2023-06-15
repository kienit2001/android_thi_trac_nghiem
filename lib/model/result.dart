class Exam {
final String examId;
final String createdBy;
final String name;
final bool isPublic;
final String description;
final int totalTime;
final List<Question> questions;
final List<int> correctAnswers;

Exam({
  required this.examId,
  required this.createdBy,
  required this.name,
  required this.isPublic,
  required this.description,
  required this.totalTime,
  required this.questions,
  required this.correctAnswers,
});



  Map<String, dynamic> toJson() {
  List<Map<String, dynamic>> questionsJson =
  questions.map((question) => question.toJson()).toList();

  return {
    'examId': examId,
    'createdBy': createdBy,
    'name': name,
    'isPublic': isPublic,
    'description': description,
    'totalTime': totalTime,
    'questions': questionsJson,
    'correctAnswers': correctAnswers,
  };
}

@override
  String toString() {
    return 'Exam{examId: $examId, createdBy: $createdBy, name: $name, isPublic: $isPublic, description: $description, totalTime: $totalTime, questions: $questions, correctAnswers: $correctAnswers}';
  }
}

class Question {
  final String questionText;
  final List<String> answers;

  Question({required this.questionText, required this.answers});

  Map<String, dynamic> toJson() {
    return {
      'questionText': questionText,
      'answers': answers,
    };
  }
}