import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: MainPage())),
    );
  }
}
