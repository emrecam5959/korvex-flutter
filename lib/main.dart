import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(const KorvexApp());
}

class KorvexApp extends StatelessWidget {
  const KorvexApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Korvex File Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AuthScreen(),
    );
  }
}
