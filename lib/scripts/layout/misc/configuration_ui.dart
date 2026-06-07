import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_instruction_group.dart';

class ConfigurationDialog extends StatefulWidget {
  const ConfigurationDialog({super.key});

  @override
  State<ConfigurationDialog> createState() => _ConfigurationDialogState();
}

class _ConfigurationDialogState extends State<ConfigurationDialog> {
  final configuration = Configuration.singleton;

  late Map<RISCVInstructionGroup, TextEditingController> latencyControllers;

  late TextEditingController physicalRegisterController;

  late TextEditingController reorderBufferController;

  @override
  void initState() {
    super.initState();

    latencyControllers = {
      for (final entry in configuration.latency.entries)
        entry.key: TextEditingController(text: entry.value.toString()),
    };

    physicalRegisterController = TextEditingController(
      text: configuration.physicalRegisterSize.toString(),
    );

    reorderBufferController = TextEditingController(
      text: configuration.reorderBufferSize.toString(),
    );
  }

  @override
  void dispose() {
    for (final controller in latencyControllers.values) {
      controller.dispose();
    }

    physicalRegisterController.dispose();
    reorderBufferController.dispose();

    super.dispose();
  }

  String formatTitle(RISCVInstructionGroup group) {
    final raw = group.name;

    return raw.toUpperCase();
  }

  Future<void> saveConfiguration() async {
    for (final entry in latencyControllers.entries) {
      final parsed = int.tryParse(entry.value.text);

      if (parsed != null) {
        configuration.setLatency(entry.key, parsed);
      }
    }

    final physicalRegisters = int.tryParse(physicalRegisterController.text);

    final reorderBuffer = int.tryParse(reorderBufferController.text);

    if (physicalRegisters != null) {
      configuration.physicalRegisterSize = physicalRegisters;
    }

    if (reorderBuffer != null) {
      configuration.reorderBufferSize = reorderBuffer;
    }

    configuration.saveChanges();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Widget buildSectionTitle(ThemeData theme, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),

      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),

          const SizedBox(width: 10),

          Text(
            title,

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberField({
    required ThemeData theme,
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,

      keyboardType: TextInputType.number,

      style: TextStyle(color: theme.colorScheme.onSurface),

      decoration: InputDecoration(
        labelText: label,

        isDense: true,

        filled: true,

        fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.35),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget buildLatencyTile({
    required ThemeData theme,
    required RISCVInstructionGroup group,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

      decoration: BoxDecoration(
        color: theme.colorScheme.surface,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              formatTitle(group),

              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),

          SizedBox(
            width: 110,

            child: buildNumberField(
              theme: theme,
              label: 'Cycles',
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.9),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),

        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.45)),
      ),

      child: Container(
        width: 400,

        constraints: const BoxConstraints(maxHeight: 600),

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),

                const SizedBox(width: 12),

                Text(
                  'Processor Configuration',

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    buildSectionTitle(
                      theme,
                      'Core Configuration',
                      Icons.memory,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: buildNumberField(
                            theme: theme,
                            label: 'Physical Registers',
                            controller: physicalRegisterController,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: buildNumberField(
                            theme: theme,
                            label: 'Reorder Buffer Size',
                            controller: reorderBufferController,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    buildSectionTitle(
                      theme,
                      'Instruction Latencies',
                      Icons.timer,
                    ),

                    ...latencyControllers.entries.map(
                      (entry) => buildLatencyTile(
                        theme: theme,
                        group: entry.key,
                        controller: entry.value,
                      ),
                    ),
                    /* 
                    const SizedBox(height: 28),

                    buildSectionTitle(
                      theme,
                      'Instruction Memory',
                      Icons.upload_file,
                    ),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await configuration.loadInstructions();

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Instruction file loaded successfully',
                                ),
                              ),
                            );
                          }
                        },

                        icon: const Icon(Icons.file_open),

                        label: const Text('Load .isq Instruction File'),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,

                          foregroundColor: theme.colorScheme.onPrimary,

                          padding: const EdgeInsets.symmetric(vertical: 16),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ), */
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      side: BorderSide(
                        color: theme.colorScheme.outline.withOpacity(0.4),
                      ),
                    ),

                    child: Text(
                      'Cancel',

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saveConfiguration,

                    icon: const Icon(Icons.save),

                    label: const Text('Save Configuration'),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,

                      foregroundColor: theme.colorScheme.onPrimary,

                      padding: const EdgeInsets.symmetric(vertical: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
