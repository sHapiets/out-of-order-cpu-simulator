import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/physical_register.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class PhysicalRegistersWidget extends StatefulWidget {
  const PhysicalRegistersWidget({super.key});

  @override
  State<PhysicalRegistersWidget> createState() =>
      PhysicalRegistersWidgetState();
}

class PhysicalRegistersWidgetState extends State<PhysicalRegistersWidget> {
  final prf = PhysicalRegisters.singleton;

  final double widgetWidth = 420;
  final double widgetHeight = 320;

  final Size paintSize = const Size(340, 240);

  void refresh() {
    setState(() {});
  }

  Widget _stateBox(String label, bool value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: value ? Colors.green.withOpacity(0.2) : Colors.transparent,
        border: Border.all(color: value ? Colors.green : Colors.grey),
      ),

      child: Text(
        "$label:${value ? 1 : 0}",

        style: const TextStyle(fontSize: 11, fontFamily: "Roboto-Mono"),
      ),
    );
  }

  Widget _registerRow(PhysicalRegister reg) {
    final dataString = reg.data.asSignedInt().toRadixString(16).padLeft(8, '0');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),

      child: Row(
        children: [
          // REGISTER LABEL
          SizedBox(
            width: 36,

            child: Text(
              "P${reg.address}",

              style: const TextStyle(
                fontFamily: "Roboto-Mono",

                fontWeight: FontWeight.bold,

                fontSize: 13,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // FREE / VALID FLAGS
          Row(
            children: [
              _stateBox("U", !reg.isFree),

              const SizedBox(width: 4),

              _stateBox("V", reg.valid),
            ],
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(height: 1, color: Theme.of(context).dividerColor),
          ),

          const SizedBox(width: 10),

          // REGISTER DATA
          Text(
            "0x$dataString",

            style: TextStyle(fontFamily: "Roboto-Mono", fontSize: 13),
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
            // BACK PANELS
            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(20, 20),
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.physicalRegisterFile,
                    borderColor: Theme.of(context).colorScheme.primary,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: Transform.translate(
                offset: const Offset(10, 10),
                child: CustomPaint(
                  size: paintSize,
                  painter: ComponentPainter(
                    componentShape: ComponentShape.physicalRegisterFile,
                    borderColor: Theme.of(context).colorScheme.primary,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ),

            // MAIN PANEL
            Align(
              alignment: Alignment.center,
              child: CustomPaint(
                size: paintSize,
                painter: ComponentPainter(
                  componentShape: ComponentShape.physicalRegisterFile,
                  borderColor: Theme.of(context).colorScheme.primary,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            // HEADER DIVIDER
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, 75),
                child: SizedBox(
                  width: paintSize.width,
                  child: Divider(
                    thickness: 3,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // TITLE
            Align(
              alignment: Alignment.topLeft,

              child: Transform.translate(
                offset: const Offset(50, 48),

                child: const Row(
                  children: [
                    Icon(Icons.edit_rounded),
                    SizedBox(width: 6),
                    Text(
                      "physical registers",

                      style: TextStyle(fontSize: 18, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            // REGISTER LIST
            Align(
              alignment: Alignment.topCenter,
              child: Transform.translate(
                offset: const Offset(0, 100),
                child: SizedBox(
                  width: 300,
                  height: 160,
                  child: ListView.builder(
                    itemCount: prf.registers.length,
                    itemBuilder: (context, index) {
                      return _registerRow(prf.registers[index]);
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
