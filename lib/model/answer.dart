import 'options.dart';

class Answer {
  late String id;

  late String answer;
  late String answer_discription;
  late int is_answered;
  late int is_answer_status_right_wrong_omitted;
  late String title;
  late List<Options> options;

  //
  // Answer(this.id, this.answer, this.answer_discription, this.is_answered,
  //    this.is_answer_status_right_wrong_omitted, this.title, this.options, {required List<Options> options, required title, required is_answer_status_right_wrong_omitted, required is_answered, required answer_discription, required answer, required id});

  Answer({
    required this.id,
    required this.answer,
    required this.answer_discription,
    required this.is_answered,
    required this.is_answer_status_right_wrong_omitted,
    required this.title,
    required this.options,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answer: json['answer'],
      answer_discription: json['answer_discription'],
      is_answered: json['is_answered'],
      is_answer_status_right_wrong_omitted:
          json['is_answer_status_right_wrong_omitted'],
      title: json['title'],
      options: List<Options>.from(
          json['options'].map((optionJson) => Options.fromJson(optionJson))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answer': answer,
      'answer_discription': answer_discription,
      'is_answered': is_answered,
      'is_answer_status_right_wrong_omitted':
          is_answer_status_right_wrong_omitted,
      'title': title,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}
