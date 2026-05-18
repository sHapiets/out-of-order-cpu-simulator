import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class MemoryUnit extends FunctionalUnit {
  MemoryUnit._() : super(type: FunctionalUnitType.memory);
  static final singleton = MemoryUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physcialRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      default:
    }

    physcialRegisters.setValid(entry.prd, true);
    physcialRegisters.writeRegister(entry.prd, output);
    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = ${output.asUnsignedHexString(32)}",
    );
  }
}
