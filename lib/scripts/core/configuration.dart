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
    Data.fromUnsignedHexString("00A08093", DataType.word),
    Data.fromUnsignedHexString("00A08113", DataType.word),
    Data.fromUnsignedHexString("00A17213", DataType.word),
    Data.fromUnsignedHexString("00A0F193", DataType.word),
    Data.fromUnsignedHexString("00A0F193", DataType.word),
    Data.fromUnsignedHexString("00002283", DataType.word),
    Data.fromUnsignedHexString("0E509B23", DataType.word),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
  ];
}
