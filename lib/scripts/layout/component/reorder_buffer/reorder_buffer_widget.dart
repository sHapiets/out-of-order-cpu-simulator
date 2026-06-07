import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/rob_entry.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class ReorderBufferWidget extends StatefulWidget {
  const ReorderBufferWidget({super.key});

  @override
  State<ReorderBufferWidget> createState() => ReorderBufferWidgetState();
}

class ReorderBufferWidgetState extends State<ReorderBufferWidget> {
  final rob = ReorderBuffer.singleton;

  final double widgetWidth = 730;
  final double widgetHeight = 420;

  final Size paintSize = const Size(720, 315);

  Widget _buildEntryCard(int index, ROBEntry entry) {
    final isHead = rob.commitHead == index;
    final isTail = rob.dispatchTail == index;

    Color borderColor = Colors.grey.shade400;

    Widget stateBox(String label, bool value) {
      return Container(
        width: 20,
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? Colors.green : Colors.grey.shade400,
          ),
          color: value ? Colors.green.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11, fontFamily: "Roboto-Mono"),
        ),
      );
    }

    Widget dataField(IconData icon, String value, Color color) {
      return Column(
        children: [
          Icon(icon, color: color),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: "Roboto-Mono",
                fontSize: 12,
                color: color,
              ),
              children: [TextSpan(text: value)],
            ),
          ),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // HEAD / TAIL
          SizedBox(
            width: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isHead) Icon(Icons.edit_note_rounded),
                if (isHead && isTail) SizedBox(width: 5),
                if (isTail) Icon(Icons.input_rounded, size: 20),
              ],
            ),
          ),
          SizedBox(width: 20),

          // ENTRY NUMBER
          SizedBox(
            width: 22,
            child: Text(
              "$index",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Nunito",
                fontSize: 13,
              ),
            ),
          ),

          // STATE SECTION
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stateBox("U", entry.inUse),
                stateBox("I", entry.issued),
                stateBox("C", entry.completed),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 1,
            height: 24,
            color: Colors.grey.shade400,
          ),

          // DATA SECTION
          Expanded(
            flex: 8,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              runSpacing: 2,
              children: [
                dataField(
                  entry.instructionType.functionalUnitType.icon,
                  entry.instructionType.name,
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),

                dataField(
                  Icons.looks_one_rounded,
                  (entry.pr1.toString() != "-1")
                      ? "P${entry.pr1.toString()}"
                      : "",
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),

                dataField(
                  Icons.looks_two_rounded,
                  (entry.pr2.toString() != "-1")
                      ? "P${entry.pr2.toString()}"
                      : "--",
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade400,
                ),

                /* 
                dataField(
                  Icons.drag_indicator_rounded,
                  entry.imm?.asSignedInt().toRadixString(16) ?? "0",
                  Theme.of(context).textTheme.bodySmall!.color!,
                ), */
                dataField(
                  Icons.edit_rounded,
                  (entry.prd.toString() != "-1")
                      ? "P${entry.prd.toString()}"
                      : "--",
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade400,
                ),

                dataField(
                  Icons.edit_note_rounded,
                  entry.rd.name,
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),

                dataField(
                  Icons.delete_forever_rounded,
                  (entry.lprd.toString() != "-1")
                      ? "P${entry.lprd.toString()}"
                      : "--",
                  Theme.of(context).textTheme.bodySmall!.color!,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(
                  componentShape: ComponentShape.reorderBuffer,
                  borderColor: Theme.of(context).colorScheme.primary,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: const Offset(35, 20),
                child: Row(
                  children: [
                    Icon(Icons.reorder),
                    SizedBox(width: 6),
                    Text(
                      "reorder buffer",
                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 650,
                height: 250,
                child: ListView.builder(
                  itemCount: rob.buffer.length,
                  itemBuilder: (context, index) {
                    return _buildEntryCard(index, rob.buffer[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
