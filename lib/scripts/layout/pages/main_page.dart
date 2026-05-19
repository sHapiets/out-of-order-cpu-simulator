import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/processor/processor_widget.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final runtime = Runtime();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Stack(
        children: [
          Align(alignment: AlignmentGeometry.center, child: ProcessorWidget()),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                runtime.runCycle();
              },
              child: const Text('RUN'),
            ),
          ),
        ],
      ),
    );
  }
}
