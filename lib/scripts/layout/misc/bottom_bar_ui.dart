import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';

class BottomBarUI extends StatelessWidget {
  BottomBarUI({super.key});
  final runtime = Runtime.singleton;

  void _run() {
    runtime.runCycle();
  }

  void _reset() {
    debugPrint("RESET");
  }

  void _openFile() {
    debugPrint("OPEN FILE");
  }

  void _menu() {
    debugPrint("MENU");

    // TODO:
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),

        child: FilledButton(
          onPressed: onPressed,

          style: ElevatedButton.styleFrom(
            elevation: 0,

            padding: const EdgeInsets.symmetric(vertical: 18),

            backgroundColor: Theme.of(context).colorScheme.surface,

            foregroundColor: Theme.of(context).colorScheme.primary,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),

              side: BorderSide(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.25),
              ),
            ),
          ),

          child: Icon(icon),
          /* 
          label: Text(
            label,

            style: const TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.bold,
            ),
          ), */
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          // RUN
          _buildButton(
            context: context,

            icon: Icons.play_arrow_rounded,

            label: "Run",

            onPressed: _run,
          ),

          // RESET
          _buildButton(
            context: context,

            icon: Icons.restart_alt_rounded,

            label: "Reset",

            onPressed: _reset,
          ),

          // OPEN FILE
          _buildButton(
            context: context,

            icon: Icons.folder_open_rounded,

            label: "Open File",

            onPressed: _openFile,
          ),

          // MENU
          _buildButton(
            context: context,

            icon: Icons.menu_rounded,

            label: "Menu",

            onPressed: _menu,
          ),
        ],
      ),
    );
  }
}
