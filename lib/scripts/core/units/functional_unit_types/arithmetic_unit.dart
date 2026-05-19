import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class ArithmeticUnit extends FunctionalUnit {
  ArithmeticUnit._() : super(type: FunctionalUnitType.arithmetic);
  static final singleton = ArithmeticUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physicalRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.add:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);
        output = Data.signedAdd(a, b, DataType.word);

      case RISCVInstruction.sub:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);
        output = Data.signedSub(a, b, DataType.word);

      case RISCVInstruction.addi:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        output = Data.signedAdd(a, b, DataType.word);

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
