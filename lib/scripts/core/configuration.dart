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
}
