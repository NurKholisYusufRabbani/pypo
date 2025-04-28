import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay 3 detik sebelum berpindah ke halaman HomePage
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {  // Memastikan widget masih terpasang
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF624e88),
      body: Center(
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(seconds: 2),  // Animasi fade-in
          child: Image(
            image: AssetImage('assets/images/PyPo_logo.png'),
            width: 200,
          ),
        ),
      ),
    );
  }
}
