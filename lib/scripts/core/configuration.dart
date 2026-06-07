import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/runtime.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_instruction_group.dart';

class Configuration extends ChangeNotifier {
  Configuration._();
  static final singleton = Configuration._();

  Map<RISCVInstructionGroup, int> latency = {
    RISCVInstructionGroup.arithmetic: 5,
    RISCVInstructionGroup.and: 3,
    RISCVInstructionGroup.or: 3,
    RISCVInstructionGroup.xor: 3,
    RISCVInstructionGroup.shift: 1,
    RISCVInstructionGroup.slt: 2,
    RISCVInstructionGroup.load: 4,
    RISCVInstructionGroup.store: 6,
    RISCVInstructionGroup.branch: 3,
    RISCVInstructionGroup.jump: 2,
  };

  int physicalRegisterSize = 8;
  int reorderBufferSize = 10;

  int getLatency(RISCVInstructionGroup instrGroup) => latency[instrGroup]!;

  void setLatency(RISCVInstructionGroup instrGroup, int newLatency) {
    latency[instrGroup] = newLatency;
  }

  Future<void> loadInstructions() async {
    Runtime.singleton.reset();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['isq'],
      withData: true,
    );
    if (result == null) return;

    final bytes = result.files.first.bytes!;
    final content = String.fromCharCodes(bytes);

    final lines = content.split('\n');
    int lineCounter = 0;

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      final instrWord = Data.fromUnsignedBitString(line, DataType.word);
      final instrAddress = Data.word(lineCounter * 4);
      Memory.singleton.storeInstruction(instrWord, instrAddress);

      lineCounter++;
    }

    notifyListeners();
  }

  void saveChanges() {
    Runtime.singleton.reset();
    notifyListeners();
  }
}
