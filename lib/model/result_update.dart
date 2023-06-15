class Exam_result {
  final int score;
  final String examId;
  final String name;
  final String description;
  final String id;

  Exam_result({
    required this.score,
    required this.examId,
    required this.name,
    required this.description,
    required this.id,
  });

  factory Exam_result.fromJson(Map<String, dynamic> json) {
    return Exam_result(
      score: json['score'],
      examId: json['examId'],
      name: json['name'],
      description: json['description'],
      id: json['_id'],
    );
  }
}
