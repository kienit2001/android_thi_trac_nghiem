// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
//
// import 'package:new_project/quiz_screen.dart';
//
// import 'model/test.dart';
//
//
// class Detail_test extends StatelessWidget {
//   Detail_test({Key? key}) : super(key: key);
//
//
//   var url = Uri.parse('https://example.com/api/data');
//
//
//   static const nameRoute = '/Detail';
//
//   final List subjectListData = const [
//     {"subject_name": "Hindi", "subject_id": "1001"},
//     {"subject_name": "English", "subject_id": "1002"},
//     {"subject_name": "Science", "subject_id": "1003"},
//     {"subject_name": "Math", "subject_id": "1004"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Subject List"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 10,
//             ),
//             ...subjectListData
//                 .map(
//                   (e) => Padding(
//                 padding: const EdgeInsets.only(bottom: 8),
//                 child: ListTile(
//                   onTap: () {
//                     print(e['subject_id']);
//
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const QuizScreen(),
//                       ),
//                     );
//                   },
//                   tileColor: Colors.teal,
//                   textColor: Colors.white,
//                   iconColor: Colors.white,
//                   title: Text(
//                     e['subject_name'],
//                   ),
//                   trailing: const Icon(Icons.arrow_forward),
//                 ),
//               ),
//             )
//                 .toList()
//           ],
//         ),
//       ),
//     );
//   }
// }