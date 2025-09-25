import 'package:flutter/material.dart';
import 'package:medigo/core/utils/theme.dart';
import 'package:medigo/features/auth/presentation/forget_password/oTP_verfication_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: OtpVerficationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
