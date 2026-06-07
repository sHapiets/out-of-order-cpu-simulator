import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/functional_units/functional_units_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/memory/memory_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/register/architectural_registers_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/register/physical_registers_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/register/rename_table_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/reorder_buffer/reorder_buffer_widget.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/misc/cycle_log_ui.dart';

class ProcessorWidget extends StatefulWidget {
  const ProcessorWidget({super.key});

  @override
  State<ProcessorWidget> createState() => _ProcessorWidgetState();
}

class _ProcessorWidgetState extends State<ProcessorWidget> {
  final widgetWidth = 1280.0;
  final widgetHeight = 720.0;

  final Offset pRPosition = const Offset(40, -288);
  final Offset aRPostion = const Offset(486, -280);

  final Offset rTPosition = const Offset(-540, 50);
  final Offset robPosition = const Offset(-40, 50);
  final Offset memoryPosition = const Offset(490, 50);

  final Offset fUPosition = const Offset(-40, 300);

  final cycleLogUI = CycleLogUI();

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Row(
        children: [
          Container(
            width: widgetWidth,
            height: widgetHeight,
            margin: EdgeInsets.all(0),
            child: ListenableBuilder(
              listenable: Configuration.singleton,
              builder: (context, child) {
                return ValueListenableBuilder(
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
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Transform.translate(
                            offset: aRPostion,
                            child: ArchitecturalRegisterWidget(),
                          ),
                        ),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Transform.translate(
                            offset: pRPosition,
                            child: PhysicalRegistersWidget(),
                          ),
                        ),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Transform.translate(
                            offset: rTPosition,
                            child: RenameTableWidget(),
                          ),
                        ),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Transform.translate(
                            offset: fUPosition,
                            child: FunctionalUnitsWidget(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 120,
            height: 800,
            child: VerticalDivider(thickness: 3),
          ),
          CycleLogUI(),
        ],
      ),
    );
  }
}
