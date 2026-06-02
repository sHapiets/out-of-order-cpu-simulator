import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class SLTUnit extends FunctionalUnit {
  SLTUnit._() : super(type: FunctionalUnitType.slt);
  static final singleton = SLTUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physicalRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.slt:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);

        bool isLessThan = a.asSignedInt() < b.asSignedInt();

        output = Data.word(isLessThan ? 1 : 0);

      case RISCVInstruction.sltu:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);

        bool isLessThan = a.asUnsignedInt() < b.asUnsignedInt();

        output = Data.word(isLessThan ? 1 : 0);

      case RISCVInstruction.slti:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        bool isLessThan = a.asSignedInt() < b.asSignedInt();

        output = Data.word(isLessThan ? 1 : 0);

      case RISCVInstruction.sltiu:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        bool isLessThan = a.asUnsignedInt() < b.asUnsignedInt();

        output = Data.word(isLessThan ? 1 : 0);

      default:
    }

    physicalRegisters.setValid(entry.prd, true);
    physicalRegisters.writeRegister(entry.prd, output);

    entry.setCommitFunction(() {
      final architecturalRegisters = ArchitecturalRegisters.singleton;

      architecturalRegisters.setPR(entry.rd, entry.prd);
      physicalRegisters.freePR(entry.lprd);
    });

    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
    );
  }
}
