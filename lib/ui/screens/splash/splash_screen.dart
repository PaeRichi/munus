import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MunusColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tiritas.png',
              height: 220,
            ),
            const SizedBox(height: 32),
            Text(
              'MUNUS',
              style: TextStyle(
                fontFamily: MunusFonts.display,
                fontSize: 48,
                fontWeight: FontWeight.w200,
                color: MunusColors.textMain,
                letterSpacing: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}