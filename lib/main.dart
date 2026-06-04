import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/misc/appbar_ui.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/misc/bottom_bar_ui.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/pages/main_page.dart';

void main() {
  runApp(const MainApp());
}

final themeModeNotifier = ValueNotifier(ThemeMode.dark);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, mode, child) => MaterialApp(
        title: "Out-of-Order Processor Simulator",
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mode,
        home: Scaffold(
          appBar: const AppbarUI(),
          body: Center(child: MainPage()),
          bottomNavigationBar: BottomBarUI(),
        ),
      ),
    );
  }
}

class AppTheme {
  static const processorPrimary = Color(0xFF2E6F80);

  // LIGHT
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF7F9FB),

    colorScheme: ColorScheme.fromSeed(
      seedColor: processorPrimary,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFF7F9FB),
      elevation: 0,
    ),

    textTheme: ThemeData.light().textTheme.apply(
      bodyColor: const Color(0xFF1E2933),
      displayColor: const Color(0xFF1E2933),
    ),
  );

  // DARK
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF111418),

    colorScheme: ColorScheme.fromSeed(
      seedColor: processorPrimary,
      brightness: Brightness.dark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF111418),
      elevation: 0,
    ),

    textTheme: ThemeData.dark().textTheme.apply(
      bodyColor: const Color(0xFFE8EEF2),
      displayColor: const Color(0xFFE8EEF2),
    ),
  );
}
