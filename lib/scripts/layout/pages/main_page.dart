import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final runtime = Runtime();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          runtime.runCycle();
        },
        child: const Text('RUN'),
      ),
    );
  }
}
