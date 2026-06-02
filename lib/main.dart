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
      title: "Out of Order Processor Simulator",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      home: Scaffold(body: Center(child: MainPage())),
    );
  }
}
