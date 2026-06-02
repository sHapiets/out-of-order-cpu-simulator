import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_instruction_group.dart';

class Configuration {
  Configuration._();
  static final singleton = Configuration._();

  Map<RISCVInstructionGroup, int> latency = {
    RISCVInstructionGroup.arithemetic: 5,
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

  int getLatency(RISCVInstructionGroup instrGroup) => latency[instrGroup]!;

  void setLatency(RISCVInstructionGroup instrGroup, int newLatency) {
    latency[instrGroup] = newLatency;
  }

  List<Data> instructions = [
    Data.fromUnsignedHexString("00500093", DataType.word), // addi x1, x0, 5
    Data.fromUnsignedHexString("00500113", DataType.word), // addi x2, x0, 5
    // beq x1, x2, +16  (branch TAKEN)
    Data.fromUnsignedHexString("00208663", DataType.word),

    // ---------- SHOULD BE FLUSHED ----------
    Data.fromUnsignedHexString("06300193", DataType.word), // addi x3, x0, 99
    Data.fromUnsignedHexString("04D00213", DataType.word), // addi x4, x0, 77
    Data.fromUnsignedHexString("03700293", DataType.word), // addi x5, x0, 55
    Data.fromUnsignedHexString("02100313", DataType.word), // addi x6, x0, 33
    // --------------------------------------

    // branch target:
    Data.fromUnsignedHexString("00100393", DataType.word), // addi x7, x0, 1
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
  ];
}
