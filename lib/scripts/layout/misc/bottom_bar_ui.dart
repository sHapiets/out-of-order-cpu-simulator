import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';

class BottomBarUI extends StatelessWidget {
  BottomBarUI({super.key});

  final runtime = Runtime.singleton;

  // =====================================
  // BUTTON FUNCTIONS
  // =====================================

  void _loadInstruction() {
    debugPrint("LOAD INSTRUCTION");
  }

  void _runCycle() {
    runtime.runCycle();
  }

  void _reset() {
    runtime.reset();
  }
  // =====================================
  // STEP ITEM
  // =====================================

  Widget _stepItem({
    required BuildContext context,
    required String step,
    required String label,
    required String subLabel,
    required IconData icon,
    required VoidCallback onPressed,
    bool highlighted = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        // STEP NUMBER
        Container(
          width: 22,
          height: 22,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: colorScheme.primary.withValues(alpha: 0.08),
          ),

          child: Center(
            child: Text(
              step,

              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // ICON BUTTON
        Container(
          width: highlighted ? 64 : 54,
          height: highlighted ? 64 : 54,

          decoration: BoxDecoration(
            shape: BoxShape.circle,

            color: colorScheme.surface,

            border: Border.all(color: colorScheme.outlineVariant),

            boxShadow: highlighted
                ? [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                      color: Colors.black.withValues(alpha: 0.04),
                    ),
                  ]
                : [],
          ),

          child: IconButton(
            onPressed: onPressed,

            icon: Icon(icon, size: highlighted ? 34 : 26),

            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        // LABELS
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              label,

              style: TextStyle(
                fontFamily: "Nunito",
                fontWeight: FontWeight.bold,
                fontSize: highlighted ? 15 : 13,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              subLabel,

              style: TextStyle(
                fontFamily: "Roboto-Mono",
                fontSize: 11,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _arrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),

      child: Icon(
        Icons.arrow_forward_rounded,
        size: 24,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }

  // =====================================
  // BUILD
  // =====================================

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // STEP 1
          _stepItem(
            context: context,

            step: "1",

            label: "Load Instruction",
            subLabel: "open binary file",

            icon: Icons.upload_file_rounded,

            onPressed: _loadInstruction,
          ),

          _arrow(context),

          // STEP 2
          ValueListenableBuilder(
            valueListenable: runtime.cycleNumber,

            builder: (context, value, child) {
              return _stepItem(
                context: context,

                step: "2",

                label: "Run",
                subLabel: "Cycle $value",
                highlighted: true,
                icon: Icons.play_arrow_rounded,

                onPressed: _runCycle,
              );
            },
          ),

          _arrow(context),

          // STEP 3
          _stepItem(
            context: context,

            step: "3",

            label: "Reset",
            subLabel: "clear all states",

            icon: Icons.restart_alt_rounded,

            onPressed: _reset,
          ),
        ],
      ),
    );
  }
}
