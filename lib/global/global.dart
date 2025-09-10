import 'package:shared_preferences/shared_preferences.dart';

late String userName;

Future<bool> getRememberMe() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("rememberMe") ?? false;
}

Future<String> getUserName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("teacherName") ?? "Teacher";
}