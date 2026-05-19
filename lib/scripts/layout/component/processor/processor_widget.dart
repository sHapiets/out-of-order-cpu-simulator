import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/memory/memory_widget.dart';

class ProcessorWidget extends StatefulWidget {
  const ProcessorWidget({super.key});

  @override
  State<ProcessorWidget> createState() => _ProcessorWidgetState();
}

class _ProcessorWidgetState extends State<ProcessorWidget> {
  final widgetWidth = 1280.0;
  final widgetHeight = 720.0;

  final Offset memoryPosition = const Offset(550, -50);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: MediaQuery.of(context).size.height / 720 * 0.8,
      child: Container(
        width: widgetWidth,
        height: widgetHeight,
        padding: EdgeInsetsGeometry.all(20),
        color: const Color.fromARGB(0, 124, 203, 51),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentGeometry.center,
              child: Transform.translate(
                offset: memoryPosition,
                child: MemoryWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
