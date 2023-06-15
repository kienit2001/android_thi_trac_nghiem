

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/user.dart';

// Lưu trữ token
Future<void> saveToken(String token, String refreshToken) async {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  await storage.write(key: 'token', value: token);
  await storage.write(key: 'refreshToken', value: refreshToken);

  print("viet token thanh cong");
 }
// Future<void> saveIDuser(User userId) async {
//   AndroidOptions _getAndroidOptions() => const AndroidOptions(
//     encryptedSharedPreferences: true,
//   );
//   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
//
//   await storage.write(key: 'userId', value: userId);
//
//
//   print("user id thanh cong");
// }
// Future<String?> getIDuser() async {
//   AndroidOptions _getAndroidOptions() => const AndroidOptions(
//     encryptedSharedPreferences: true,
//   );
//   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
//   String? value = await storage.read(key: 'userId');
//   print(value);
//   return value;
// }
// Truy xuất token
Future<String?> getToken() async {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  String? value = await storage.read(key: 'token');
  // print(value);
  return value;
}
Future<String?> getRefreshToken() async {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );
  final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  String? value = await storage.read(key: 'refreshToken');
   // print(value);
  return value;
}