import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_instruction_group.dart';

class MemoryUnit extends FunctionalUnit {
  MemoryUnit._() : super(type: FunctionalUnitType.memory);
  static final singleton = MemoryUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physicalRegisters = PhysicalRegisters.singleton;
    final memory = Memory.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data loadOutput = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.lb:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        loadOutput = memory.loadByteSigned(memAddress);

      case RISCVInstruction.lbu:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        loadOutput = memory.loadByteUnsigned(memAddress);

      case RISCVInstruction.lh:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        loadOutput = memory.loadHalfSigned(memAddress);

      case RISCVInstruction.lhu:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        loadOutput = memory.loadHalfUnsigned(memAddress);

      case RISCVInstruction.lw:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        loadOutput = memory.loadWord(memAddress);

      case RISCVInstruction.sb:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final newByte = physicalRegisters.readRegister(entry.pr2);

        entry.setCommitFunction(() {
          memory.storeByte(newByte, memAddress);
        });
        debugPrint("      --->>> AWAITING STORE COMMIT!");

      case RISCVInstruction.sh:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final newHalf = physicalRegisters.readRegister(entry.pr2);

        entry.setCommitFunction(() {
          memory.storeHalf(newHalf, memAddress);
        });
        debugPrint("      --->>> AWAITING STORE COMMIT!");

      case RISCVInstruction.sw:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;
        final memAddress = Data.signedAdd(a, b, DataType.word);

        final newWord = physicalRegisters.readRegister(entry.pr2);

        entry.setCommitFunction(() {
          memory.storeWord(newWord, memAddress);
        });
        debugPrint("      --->>> AWAITING STORE COMMIT!");

      default:
    }

    if (entry.instructionType.instrGroup == RISCVInstructionGroup.load) {
      physicalRegisters.setValid(entry.prd, true);
      physicalRegisters.writeRegister(entry.prd, loadOutput);

      entry.setCommitFunction(() {
        final architecturalRegisters = ArchitecturalRegisters.singleton;

        architecturalRegisters.setPR(entry.rd, entry.prd);
        physicalRegisters.freePR(entry.lprd);
      });

      debugPrint("      --->>> WRITE IN PR:");
      debugPrint(
        "            --->>>  P${entry.prd} = 0x${loadOutput.asUnsignedHexString(8)}",
      );
    }
  }
}
