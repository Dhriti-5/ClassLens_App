import 'package:shared_preferences/shared_preferences.dart';

late String userName;
late int userID;

Future<bool> getRememberMe() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("rememberMe") ?? false;
}

Future<String> getUserName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("teacherName") ?? "Teacher";
}

Future<int> getUserID() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt("teacherID") ?? 0;
}