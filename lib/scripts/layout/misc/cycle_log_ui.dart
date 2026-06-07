import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/committer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/dispatcher.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/issuer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/resolver.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_painter.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class CycleLogUI extends StatefulWidget {
  const CycleLogUI({super.key});

  @override
  State<CycleLogUI> createState() => CycleLogUIState();
}

class CycleLogUIState extends State<CycleLogUI> {
  final runtime = Runtime.singleton;
  final double widgetWidth = 560;
  final double widgetHeight = 820;

  final Size paintSize = const Size(520, 780);

  // ====================================
  // CONTROLLER LOGS
  // ====================================

  String dispatcherLog = "";
  String issuerLog = "";
  String functionalUnitLog = "";
  String committerLog = "";
  String resolverLog = "";

  // ====================================
  // SECTION
  // ====================================

  Widget _logSection({
    required int flex,
    required String title,
    required IconData icon,
    required String log,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),

          border: Border.all(color: Theme.of(context).dividerColor),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(icon, size: 22),

                const SizedBox(width: 8),

                Text(
                  title,

                  style: const TextStyle(
                    fontFamily: "Nunito",

                    fontWeight: FontWeight.bold,

                    fontSize: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  log.isEmpty ? "-- no activity --" : log,

                  style: const TextStyle(
                    fontFamily: "Roboto-Mono",

                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
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

        child: ValueListenableBuilder(
          valueListenable: Runtime.singleton.cycleNumber,
          builder: (context, value, child) {
            return Stack(
              children: [
                // BACKGROUND
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

                // TITLE
                Align(
                  alignment: Alignment.topLeft,

                  child: Transform.translate(
                    offset: const Offset(50, 35),

                    child: const Row(
                      children: [
                        Icon(Icons.terminal_rounded),

                        SizedBox(width: 8),
                        Text(
                          "cycle log",

                          style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // CYCLE NUMBER
                Align(
                  alignment: Alignment.topRight,

                  child: Transform.translate(
                    offset: const Offset(-50, 40),

                    child: Text(
                      "Cycle $value",

                      style: TextStyle(
                        fontFamily: "Roboto-Mono",
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // DIVIDER
                Align(
                  alignment: Alignment.topCenter,

                  child: Transform.translate(
                    offset: const Offset(0, 80),

                    child: SizedBox(
                      width: paintSize.width - 24,

                      child: Divider(
                        thickness: 3,

                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                // LOG SECTIONS
                Align(
                  alignment: Alignment.center,

                  child: Transform.translate(
                    offset: const Offset(0, 25),
                    child: SizedBox(
                      width: 450,
                      height: 650,

                      child: Column(
                        children: [
                          _logSection(
                            flex: 22,
                            title: "Dispatcher",
                            icon: Icons.input_rounded,
                            log: Dispatcher.singleton.getLog,
                          ),
                          _logSection(
                            flex: 40,
                            title: "Issuer",
                            icon: Icons.send_rounded,
                            log: Issuer.singleton.getLog,
                          ),

                          /* 
                          _logSection(
                            title: "Functional Units",
                            icon: Icons.precision_manufacturing_rounded,
                            log: functionalUnitLog,
                          ), */
                          _logSection(
                            flex: 30,
                            title: "Committer",
                            icon: Icons.edit_note_rounded,
                            log: Committer.singleton.getLog,
                          ),

                          _logSection(
                            flex: 30,
                            title: "Resolver",
                            icon: Icons.restore_rounded,
                            log: Resolver.singleton.getLog,
                          ),
                        ],
                      ),
                    ),
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
