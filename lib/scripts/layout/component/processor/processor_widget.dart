import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/memory/memory_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/reorder_buffer/reorder_buffer_widget.dart';

class ProcessorWidget extends StatefulWidget {
  const ProcessorWidget({super.key});

  @override
  State<ProcessorWidget> createState() => _ProcessorWidgetState();
}

class _ProcessorWidgetState extends State<ProcessorWidget> {
  final widgetWidth = 1280.0;
  final widgetHeight = 720.0;

  final Offset memoryPosition = const Offset(550, -50);
  final Offset robPosition = const Offset(0, 0);

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        width: widgetWidth,
        height: widgetHeight,
        margin: EdgeInsets.all(50),
        child: ValueListenableBuilder(
          valueListenable: Runtime.singleton.cycleNumber,
          builder: (context, value, child) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                    offset: robPosition,
                    child: ReorderBufferWidget(),
                  ),
                ),
                Align(
                  alignment: AlignmentGeometry.center,
                  child: Transform.translate(
                    offset: memoryPosition,
                    child: MemoryWidget(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
