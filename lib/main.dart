import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:classlens/global/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  userName = await getUserName();
  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true,
          builder: (context)=>MyApp()
      ),
    ),
  );
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



