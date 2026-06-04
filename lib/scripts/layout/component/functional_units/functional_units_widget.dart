import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class FunctionalUnitsWidget extends StatefulWidget {
  const FunctionalUnitsWidget({super.key});

  @override
  State<FunctionalUnitsWidget> createState() => FunctionalUnitsWidgetState();
}

class FunctionalUnitsWidgetState extends State<FunctionalUnitsWidget> {
  final functionalUnits = FunctionalUnits.singleton;

  final double widgetWidth = 1000;
  final double widgetHeight = 300;

  void refresh() {
    setState(() {});
  }

  Widget _buildUnitCard(FunctionalUnit unit) {
    final isBusy = unit.isBusy;

    final borderColor = unit.isComplete
        ? Colors.green
        : isBusy
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).dividerColor;

    return SizedBox(
      width: 150,
      height: 120,

      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,

            child: CustomPaint(
              size: const Size(160, 100),

              painter: ComponentPainter(
                componentShape: ComponentShape.functionalUnit,

                borderColor: borderColor,

                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),

          // CONTENT
          Align(
            alignment: Alignment.center,

            child: SizedBox(
              width: 90,
              height: 90,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  // ICON + NAME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(unit.type.icon, size: 18),

                      const SizedBox(width: 6),

                      Flexible(
                        child: Text(
                          unit.type.name,

                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontSize: 12,

                            fontFamily: "Nunito",

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Divider(height: 8, color: Theme.of(context).dividerColor),

                  // ROB ENTRY
                  _infoRow(
                    "ROB",
                    isBusy ? unit.robEntryNumber.toString() : "--",
                  ),

                  // CURRENT STEP
                  _infoRow(
                    "STEP",
                    isBusy ? "${unit.step}/${unit.entryLatency}" : "--",
                  ),

                  // COMPLETE
                  /* _infoRow("DONE", unit.isComplete ? "1" : "0"),
 */
                  // INSTRUCTION
                  /* _infoRow(
                    "INSTR",
                    isBusy ? unit.entry.instructionType.name : "--",
                  ), */
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: "Roboto-Mono",
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),

        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Roboto-Mono",
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final units = functionalUnits.units.values.toList();

    return FittedBox(
      fit: BoxFit.contain,

      child: SizedBox(
        width: widgetWidth,
        height: widgetHeight,

        child: Stack(
          children: [
            // TITLE
            Align(
              alignment: Alignment.topLeft,

              child: Transform.translate(
                offset: const Offset(20, 80),

                child: const Row(
                  children: [
                    Icon(Icons.precision_manufacturing_rounded),

                    SizedBox(width: 8),

                    Text(
                      "functional units",

                      style: TextStyle(fontSize: 20, fontFamily: "Nunito"),
                    ),
                  ],
                ),
              ),
            ),

            // UNITS GRID
            Align(
              alignment: Alignment.center,

              child: Transform.translate(
                offset: const Offset(0, 20),

                child: Wrap(
                  spacing: 14,
                  runSpacing: 14,

                  alignment: WrapAlignment.center,

                  children: units.map((unit) {
                    return _buildUnitCard(unit);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
