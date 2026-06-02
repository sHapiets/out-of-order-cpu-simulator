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

  final double widgetWidth = 700;
  final double widgetHeight = 420;

  final Size paintSize = const Size(660, 300);

  Widget _buildEntryCard(int index, ROBEntry entry) {
    final isHead = rob.commitHead == index;
    final isTail = rob.dispatchTail == index;
    final isUsed = entry.inUse;
    final isIssued = entry.issued;
    final isCompleted = entry.completed;

    Color borderColor = Colors.grey.shade400;

    if (isUsed && !isIssued && !isCompleted) {
      borderColor = Colors.orange;
    }

    if (isUsed && isIssued && !isCompleted) {
      borderColor = Colors.blue;
    }

    if (isUsed && isIssued && isCompleted) {
      borderColor = Colors.green;
    }

    Widget stateBox(String label, bool value) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? Colors.green : Colors.grey.shade400,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          "$label:${value ? 1 : 0}",
          style: const TextStyle(fontSize: 11, fontFamily: "Roboto-Mono"),
        ),
      );
    }

    Widget dataField(String label, String value) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: "Roboto-Mono",
            fontSize: 11,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
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
          // ENTRY NUMBER
          SizedBox(
            width: 52,
            child: Text(
              "ROB$index",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Nunito",
                fontSize: 13,
              ),
            ),
          ),

          // HEAD / TAIL
          SizedBox(
            width: 58,
            child: Row(
              children: [
                if (isHead)
                  const Text(
                    "H",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                if (isTail)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Text(
                      "T",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
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
                dataField("op", entry.instructionType.name),

                dataField("p1", entry.pr1.toString()),

                dataField("p2", entry.pr2.toString()),

                dataField(
                  "imm",
                  entry.imm?.asSignedInt().toRadixString(16) ?? "0",
                ),

                dataField("rd", entry.rd.name),

                dataField("prd", entry.prd.toString()),

                dataField("lprd", entry.lprd.toString()),
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
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: const Offset(35, 20),
                child: const Row(
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
              child: Transform.translate(
                offset: const Offset(0, 30),
                child: SizedBox(
                  width: 620,
                  height: 250,
                  child: ListView.builder(
                    itemCount: rob.buffer.length,
                    itemBuilder: (context, index) {
                      return _buildEntryCard(index, rob.buffer[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
