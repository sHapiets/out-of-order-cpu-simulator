import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class RenameTableWidget extends StatefulWidget {
  const RenameTableWidget({super.key});

  @override
  State<RenameTableWidget> createState() => RenameTableWidgetState();
}

class RenameTableWidgetState extends State<RenameTableWidget> {
  final arf = ArchitecturalRegisters.singleton;

  final double widgetWidth = 250;
  final double widgetHeight = 280;

  final Size paintSize = const Size(200, 300);

  void refresh() {
    setState(() {});
  }

  late final List<RegisterAddress> registers = RegisterAddress.values
      .where(
        (reg) =>
            reg != RegisterAddress.none &&
            reg != RegisterAddress.pc &&
            reg != RegisterAddress.x0,
      )
      .toList();

  Widget _registerRow(RegisterAddress reg) {
    final rename = arf.renameTable[reg] ?? -1;

    final value = rename == -1 ? "--" : "P$rename";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),

      child: Row(
        children: [
          SizedBox(
            width: 30,

            child: Text(
              reg.name,

              style: const TextStyle(
                fontFamily: "Roboto-Mono",

                fontWeight: FontWeight.bold,

                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Container(height: 1, color: Theme.of(context).dividerColor),
          ),

          const SizedBox(width: 8),

          Text(
            value,

            style: TextStyle(
              fontFamily: "Roboto-Mono",

              fontSize: 15,

              color: Theme.of(context).colorScheme.primary,
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
                  componentShape: ComponentShape.renameTable,
                  borderColor: Theme.of(context).colorScheme.primary,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,

              child: Transform.translate(
                offset: const Offset(50, -20),
                child: const Row(
                  children: [
                    Icon(Icons.alt_route_rounded),

                    SizedBox(width: 6),

                    Text(
                      "rename table",

                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,

              child: Transform.translate(
                offset: const Offset(8, 8),

                child: SizedBox(
                  width: 160,
                  height: 240,

                  child: ListView.builder(
                    itemCount: registers.length,

                    itemBuilder: (context, index) {
                      return _registerRow(registers[index]);
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
