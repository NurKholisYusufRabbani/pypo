import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'models/saving_goal.dart';
import 'services/notification_service.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi timezone
  tz.initializeTimeZones();

  // Inisialisasi notifikasi
  await NotificationService().initialized();

  // Minta izin notifikasi (Android 13+ dan iOS)
  await Permission.notification.request();

  // Inisialisasi Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SavingGoalAdapter());
  await Hive.openBox<SavingGoal>('goals');
  await Hive.openBox('app');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PyPo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(),
    );
  }
}
