import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class ROBEntry {
  ROBEntry({
    this.inUse = false,
    this.instructionType = RISCVInstruction.add,
    this.pr1 = 0,
    this.pr2 = 0,
    this.imm,
    this.rd = RegisterAddress.x0,
    this.prd = 0,
    this.lprd = 0,
  });

  bool inUse = false;
  bool issued = false;
  bool completed = false;

  RISCVInstruction instructionType;
  int pr1;
  int pr2;
  Data? imm = Data.wordZero();
  RegisterAddress rd;
  int prd;
  int lprd;

  static ROBEntry empty = ROBEntry(inUse: false);
}
