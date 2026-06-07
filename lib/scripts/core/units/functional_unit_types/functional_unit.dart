import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/rob_entry.dart';

class FunctionalUnit {
  FunctionalUnit({required this.type});

  final FunctionalUnitType type;

  int robEntryNumber = -1;
  int step = 0;
  bool isBusy = false;

  void reset() {
    robEntryNumber = -1;
    step = 0;
    isBusy = false;
  }

  ROBEntry get entry {
    final reorderBuffer = ReorderBuffer.singleton;
    return reorderBuffer.buffer[robEntryNumber];
  }

  int get entryLatency {
    final instr = entry.instructionType;
    final instrGroup = instr.instrGroup;

    final config = Configuration.singleton;
    final latency = config.getLatency(instrGroup);

    return latency;
  }

  bool get isComplete => (isBusy && (step == entryLatency));

  void issueEntry(int entryNumber) {
    isBusy = true;
    robEntryNumber = entryNumber;
    step = 0;
  }

  void run() {
    if (!isBusy) return;

    step = (step + 1).clamp(0, entryLatency);
  }

  void complete() {
    isBusy = false;
    ReorderBuffer.singleton.buffer[robEntryNumber].completed = true;
  }
}

enum FunctionalUnitType {
  arithmetic(icon: Icons.calculate_rounded),
  bitOperator(icon: Icons.data_object_rounded),
  bitShift(icon: Icons.code_rounded),
  slt(icon: Icons.arrow_forward_ios_rounded),
  memory(icon: Icons.memory_rounded),
  branch(icon: Icons.call_split_rounded),
  jump(icon: Icons.wrap_text_rounded);

  const FunctionalUnitType({required this.icon});

  final IconData icon;
}
