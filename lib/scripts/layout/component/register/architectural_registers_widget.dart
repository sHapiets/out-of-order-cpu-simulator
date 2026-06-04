import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class ArchitecturalRegisterWidget extends StatefulWidget {
  const ArchitecturalRegisterWidget({super.key});

  @override
  State<ArchitecturalRegisterWidget> createState() =>
      ArchitecturalRegisterWidgetState();
}

class ArchitecturalRegisterWidgetState
    extends State<ArchitecturalRegisterWidget> {
  final arf = ArchitecturalRegisters.singleton;

  final double widgetWidth = 280;
  final double widgetHeight = 320;

  final Size paintSize = const Size(200, 260);

  void refresh() {
    setState(() {});
  }

  late final List<RegisterAddress> registers = RegisterAddress.values
      .where((reg) => reg != RegisterAddress.none)
      .toList();

  Widget _registerRow(RegisterAddress reg) {
    String value;

    if (reg == RegisterAddress.pc) {
      value = "0x${arf.pc.toRadixString(16).padLeft(3, '0')}";
    } else if (reg == RegisterAddress.x0) {
      value = "0";
    } else if (arf.getPR(reg) == -1) {
      value = "--";
    } else {
      value = "P${arf.getPR(reg)}";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      /* decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
 */
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
            style: TextStyle(fontFamily: "Roboto-Mono", fontSize: 15),
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
              alignment: AlignmentGeometry.center,
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(
                  componentShape: ComponentShape.architecturalRegisterFile,
                  borderColor: Theme.of(context).colorScheme.primary,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            Align(
              alignment: AlignmentGeometry.topCenter,
              child: Transform.translate(
                offset: Offset(0, 60),
                child: SizedBox(
                  width: paintSize.width,
                  child: Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Transform.translate(
                offset: const Offset(50, 38),
                child: const Row(
                  children: [
                    Icon(Icons.edit_note_rounded),
                    SizedBox(width: 6),
                    Text(
                      "arch. registers",
                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, 80),
                child: SizedBox(
                  width: 180,
                  height: 200,

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
