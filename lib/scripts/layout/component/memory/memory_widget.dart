import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class MemoryWidget extends StatefulWidget {
  const MemoryWidget({super.key});

  @override
  State<MemoryWidget> createState() => _MemoryWidgetState();
}

class _MemoryWidgetState extends State<MemoryWidget> {
  final memory = Memory.singleton;

  final double widgetHeight = 320.0;
  final double widgetWidth = 240.0;

  final Size paintSize = const Size(200, 240);

  bool instrMemoryOnDisplay = true;

  Widget _memoryRow(int addressIndex) {
    final memoryWord = memory.byteMemory[addressIndex];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Row(
        children: [
          SizedBox(
            width: 55,

            child: Text(
              "0x${(addressIndex * 4).toRadixString(16).padLeft(3, "0")}",

              style: const TextStyle(fontSize: 15, fontFamily: "Roboto-Mono"),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: memoryWord.map((memoryByte) {
                return Text(
                  memoryByte.asUnsignedHexString(2),

                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "Roboto-Mono",
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================
  // MEMORY TABLE
  // =====================================

  Widget _memoryTable() {
    final start = instrMemoryOnDisplay ? 0 : memory.dynamicWordAddressBegin;

    final end = instrMemoryOnDisplay
        ? memory.instrWordAddressLimit
        : memory.dynamicWordAddressLimit;

    return ListView.builder(
      itemCount: end - start + 1,

      itemBuilder: (context, index) {
        return _memoryRow(start + index);
      },
    );
  }

  // =====================================
  // BUILD
  // =====================================

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,

      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,

        child: Stack(
          children: [
            // BACKGROUND
            Align(
              alignment: Alignment.center,

              child: CustomPaint(
                size: paintSize,

                painter: ComponentPainter(
                  componentShape: ComponentShape.memory,

                  borderColor: Theme.of(context).colorScheme.primary,

                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            // TITLE
            Align(
              alignment: Alignment.topLeft,

              child: Transform.translate(
                offset: const Offset(35, 42),

                child: const Row(
                  children: [
                    Icon(Icons.memory_rounded),

                    SizedBox(width: 6),

                    Text(
                      "memory",

                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            // DIVIDER
            Align(
              alignment: Alignment.topCenter,

              child: Transform.translate(
                offset: const Offset(0, 65),

                child: SizedBox(
                  width: paintSize.width,

                  child: Divider(
                    thickness: 3,

                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // MEMORY TABLE
            Align(
              alignment: Alignment.topCenter,

              child: Transform.translate(
                offset: const Offset(0, 90),

                child: SizedBox(height: 120, width: 160, child: _memoryTable()),
              ),
            ),

            // LABEL
            Align(
              alignment: Alignment.bottomCenter,

              child: Transform.translate(
                offset: const Offset(0, -80),

                child: Text(
                  instrMemoryOnDisplay ? "instruction space" : "dynamic space",

                  style: const TextStyle(fontSize: 14, fontFamily: "Nunito"),
                ),
              ),
            ),

            // SWITCH BUTTON
            Align(
              alignment: Alignment.bottomCenter,

              child: Transform.translate(
                offset: const Offset(0, -45),

                child: IconButton(
                  onPressed: () {
                    setState(() {
                      instrMemoryOnDisplay = !instrMemoryOnDisplay;
                    });
                  },

                  icon: Icon(
                    Icons.swap_horizontal_circle_sharp,

                    color: Theme.of(context).colorScheme.primary,
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
