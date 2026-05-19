import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
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
    final memory = Memory.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    switch (instr) {
      case RISCVInstruction.lb:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final Data output = memory.loadByteSigned(memAddress);

        physcialRegisters.setValid(entry.prd, true);
        physcialRegisters.writeRegister(entry.prd, output);
        debugPrint("      --->>> WRITE IN PR:");
        debugPrint(
          "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
        );

      case RISCVInstruction.lbu:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final Data output = memory.loadByteUnsigned(memAddress);

        physcialRegisters.setValid(entry.prd, true);
        physcialRegisters.writeRegister(entry.prd, output);
        debugPrint("      --->>> WRITE IN PR:");
        debugPrint(
          "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
        );

      case RISCVInstruction.lh:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final Data output = memory.loadHalfSigned(memAddress);

        physcialRegisters.setValid(entry.prd, true);
        physcialRegisters.writeRegister(entry.prd, output);
        debugPrint("      --->>> WRITE IN PR:");
        debugPrint(
          "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
        );

      case RISCVInstruction.lhu:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final Data output = memory.loadHalfUnsigned(memAddress);

        physcialRegisters.setValid(entry.prd, true);
        physcialRegisters.writeRegister(entry.prd, output);
        debugPrint("      --->>> WRITE IN PR:");
        debugPrint(
          "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
        );

      case RISCVInstruction.lw:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final Data output = memory.loadWord(memAddress);

        physcialRegisters.setValid(entry.prd, true);
        physcialRegisters.writeRegister(entry.prd, output);
        debugPrint("      --->>> WRITE IN PR:");
        debugPrint(
          "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
        );

      default:
    }
  }
}
