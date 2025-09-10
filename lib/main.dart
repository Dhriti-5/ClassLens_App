import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:classlens/global/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  userName = await getUserName();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'ClassLens',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Lato'
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );

  }
}



