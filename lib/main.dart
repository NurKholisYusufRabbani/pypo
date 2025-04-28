import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/saving_goal.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SavingGoalAdapter());
  await Hive.openBox<SavingGoal>('goals');
  await Hive.openBox('app'); // Box untuk menyimpan status edukasi

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
