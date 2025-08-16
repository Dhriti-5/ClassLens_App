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
}