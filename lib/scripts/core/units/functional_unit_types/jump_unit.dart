import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class JumpUnit extends FunctionalUnit {
  JumpUnit._() : super(type: FunctionalUnitType.jump);
  static final singleton = JumpUnit._();

  bool undoDispatch = false;

  @override
  void complete() {
    final physicalRegisters = PhysicalRegisters.singleton;

    final pc = ArchitecturalRegisters.singleton.pc;

    debugPrint("      --->>> JUMP DETECTED! Resolving invalidated entries....");
    undoDispatch = true;

    final oldPC = pc + 4;
    physicalRegisters.setValid(entry.prd, true);
    physicalRegisters.writeRegister(entry.prd, Data.word(oldPC));

    entry.setCommitFunction(() {
      final architecturalRegisters = ArchitecturalRegisters.singleton;

      architecturalRegisters.setPR(entry.rd, entry.prd);
      physicalRegisters.freePR(entry.lprd);
    });

    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = 0x${oldPC.toRadixString(16).padLeft(8, '0')}",
    );
  }

  void resolved(bool setPC) {
    if (setPC) {
      final physicalRegisters = PhysicalRegisters.singleton;
      final pc = ArchitecturalRegisters.singleton.pc;

      int newPC = 0;

      final instr = entry.instructionType;

      switch (instr) {
        case RISCVInstruction.jal:
          newPC = pc + entry.imm!.asSignedInt();

        case RISCVInstruction.jalr:
          final op1 = physicalRegisters.readRegister(entry.pr1);
          newPC = op1.asSignedInt() + entry.imm!.asSignedInt();

        default:
      }

      final architecturalRegisters = ArchitecturalRegisters.singleton;
      architecturalRegisters.setPC(newPC);
      debugPrint(
        "  --> Jump PC to PC = 0x${architecturalRegisters.pc.toRadixString(16).toUpperCase()}",
      );
    }
    super.complete();
    undoDispatch = false;
    debugPrint("  --> Freeing Jump Unit...");
  }
}
