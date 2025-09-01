import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:classlens/data_models/departments.dart';


class ApiServices{

  static Future<List<Departments>> getDepartments() async{

    const String apiUrl = 'http://127.0.0.1:8000/api/getDepartments/';

    try{

      final responce = await http.get(Uri.parse(apiUrl));

      if(responce.statusCode == 200){
        final List<dynamic> jsonData = jsonDecode(responce.body);

        return jsonData.map(
                (json) => Departments.fromJson(json as Map<String, dynamic>)
        ).toList();
      }
      else{
        throw Exception('Failed to load Departments${responce.statusCode}');
      }

    }
    catch(e){
      print(e.toString());
      throw Exception("Failed to load : ${e}");
    }
  }

  static Future<String?> signUpTeacher({required final String name, required String email, required String password,required String? departmentID}) async{

    const String endpoint = "http://127.0.0.1:8000/api/registerNewTeacher";
    final url = Uri.parse(endpoint);

    try{

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8'
      };

     final body = jsonEncode({
       "name":name,
       "email":email,
       "password":password,
       "departmentID":departmentID
     });

     final responce = await http.post(
       url,
       headers: headers,
       body: body
     );

     if(responce.statusCode==201){
       print('Sign up successful!');
       return "success";
     }
     else{
       return "failed";
     }

    }
    catch(e){
      print(e.toString());
      return 'Could not connect to the server.';
    }
  }

  static Future<bool> sendOpt({required final String email}) async {
    const String endpoint = "http://127.0.0.1:8000/api/sendOtp";
    final url = Uri.parse(endpoint);

    try{

      const headers = {
        'Content-Type': 'application/json; charset=UTF-8'
      };

      final body = jsonEncode({
        "email":email
      });

      final responce = await http.post(url,headers: headers,body: body);

      if(responce.statusCode==200){
        print("mail sent");
        return Future.value(true);
      }
      else{
        print("mail not sent");
        return Future.value(false);
      }

    }
    catch(e){
      print(e.toString());
      return Future.value(false);
    }
  }

  static Future<bool> verifyOpt({required final String email, required final int otp})async{
    const endpoint = "http://127.0.0.1:8000/api/verifyOtp";
    final url = Uri.parse(endpoint);

    try{
      const headers = {
        'Content-Type': 'application/json; charset=UTF-8'
      };

      final body = jsonEncode({
        "email":email,
        "otp":otp
      });

      final responce = await http.post(url,headers: headers,body: body);

      if(responce.statusCode==200){
        print("otp verified");
        return Future.value(true);
      }
      else{
        return Future.value(false);
      }
    }
    catch(e){
      print(e.toString());
      return Future.value(false);
    }
  }

  static Future<bool> setPassword({required final String email, required final String password}) async{
    const endpoint = "http://127.0.0.1:8000/api/setPassword";
    final url = Uri.parse(endpoint);

    const headers ={
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final body=jsonEncode({
      'email':email,
      'password':password
    });

    try{
      final responce = await http.post(url,headers: headers,body: body);

      if(responce.statusCode==200){
        print("otp verified");
        return Future.value(true);
      }
      else{
        return Future.value(false);
      }
    }
    catch(e){
      print(e.toString());
      return Future.value(false);
    }
  }

  static Future<bool> validateTeacher({required final String email, required final String password}) async{
    const endpoint = "http://127.0.0.1:8000/api/validateTeacher";
    final url = Uri.parse(endpoint);

    const headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };

    final body=jsonEncode({
      'email':email,
      'password':password

    });

    try{
      final responce = await http.post(url,headers: headers,body: body);

      if(responce.statusCode==200){

        print("teacher validated successfully");
        return Future.value(true);
      }
      else{
        print("teacher validation failed");
        return Future.value(false);
      }

    }
    catch(e){
      print(e.toString());
      return Future.value(false);
    }
  }
}