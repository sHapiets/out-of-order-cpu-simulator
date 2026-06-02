import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class BranchUnit extends FunctionalUnit {
  BranchUnit._() : super(type: FunctionalUnitType.branch);
  static final singleton = BranchUnit._();

  bool undoDispatch = false;

  @override
  void complete() {
    final physicalRegisters = PhysicalRegisters.singleton;

    final instr = entry.instructionType;
    final op1 = physicalRegisters.readRegister(entry.pr1);
    final op2 = physicalRegisters.readRegister(entry.pr2);

    bool branchTaken = false;

    switch (instr) {
      case RISCVInstruction.beq:
        if (op1.signedInt == op2.signedInt) {
          branchTaken = true;
        }

      case RISCVInstruction.bge:
        if (op1.signedInt >= op2.signedInt) {
          branchTaken = true;
        }

      case RISCVInstruction.bgeu:
        if (op1.asUnsignedInt() >= op2.asUnsignedInt()) {
          branchTaken = true;
        }

      case RISCVInstruction.blt:
        if (op1.signedInt < op2.signedInt) {
          branchTaken = true;
        }

      case RISCVInstruction.bltu:
        if (op1.asUnsignedInt() < op2.asUnsignedInt()) {
          branchTaken = true;
        }

      case RISCVInstruction.bne:
        if (op1.signedInt != op2.signedInt) {
          branchTaken = true;
        }

      default:
    }

    if (!branchTaken) {
      super.complete();

      debugPrint("    --->>> BRANCH NOT TAKEN!");
      return;
    }

    debugPrint("      --->>> BRANCH TAKEN! Resolving invalidated entries....");
    undoDispatch = true;
  }

  void resolved(bool setPC) {
    if (setPC) {
      final offset = entry.imm!.asSignedInt();
      final architecturalRegisters = ArchitecturalRegisters.singleton;
      architecturalRegisters.offsetPC(offset);
      debugPrint(
        "  --> Branch PC to PC = 0x${architecturalRegisters.pc.toRadixString(16).toUpperCase()}",
      );
    }
    super.complete();
    undoDispatch = false;
    debugPrint("  --> Freeing Branch Unit...");
  }
}
