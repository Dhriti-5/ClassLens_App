import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getRememberMe() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("rememberMe") ?? false;
}