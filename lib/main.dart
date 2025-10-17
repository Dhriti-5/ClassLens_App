import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'global/providers/task_manager_provider.dart';
import 'splash_screen.dart';
import 'package:classlens/global/global.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:classlens/data_models/notification_hive_model.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Hive.initFlutter();
  Hive.registerAdapter(NotificationHiveModelAdapter());
  await Hive.openBox<NotificationHiveModel>('notifications');


  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("app_icon.png");
  const WindowsInitializationSettings initializationSettingsWindows = WindowsInitializationSettings(
      appName: "ClassLens",
      appUserModelId: "ClassLens.ClassLens_Frontend",
      guid: 'c454aee5-f2e8-462e-876a-a0b37c234a33',
      iconPath: 'assets/icons/app_icon.ico'
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    windows: initializationSettingsWindows
  );
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  userName = await getUserName();


  runApp(
    ProviderScope(
      child: DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
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







