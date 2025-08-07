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
}