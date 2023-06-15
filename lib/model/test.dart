
import 'dart:convert';

class Test{
  String id = "";
  String name ="";
  String dec ="";
  String ExamID = "";
  List<int> img =[];

  Test({
    required this.id,
    required this.name,
    required this.dec,
    required this.img,
    required this.ExamID
  }) ;

  factory Test.fromJson(Map<String, dynamic> json) {
      String imageString = json['image'];

      // Remove the data URI prefix if present
      // if (imageString.startsWith('data:image')) {
      //   imageString = imageString.split(',')[1];
      // }

      List<int> imageBytes = base64Decode(imageString);

      return Test(
        id: json['_id'],
        name: json['name'],
        dec: json['description'],
        img: imageBytes,
        ExamID: json['examId'],
      );



  }
}