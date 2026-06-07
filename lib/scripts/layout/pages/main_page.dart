import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/processor/processor_widget.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final runtime = Runtime.singleton;
  final processorWidget = ProcessorWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.fromLTRB(10, 25, 10, 15),
      child: Stack(
        children: [
          Align(alignment: AlignmentGeometry.center, child: processorWidget),
        ],
      ),
    );
  }
}
