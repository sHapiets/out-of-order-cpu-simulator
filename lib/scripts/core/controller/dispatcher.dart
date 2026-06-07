import 'package:flutter/rendering.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/branch_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/rob_entry.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/reg_sel.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class Dispatcher {
  Dispatcher._();
  static final singleton = Dispatcher._();

  Data instrWord = Data.wordZero();

  final reorderBuffer = ReorderBuffer.singleton;
  final physicalRegisters = PhysicalRegisters.singleton;
  final architecturalRegisters = ArchitecturalRegisters.singleton;
  final memory = Memory.singleton;

  String _log = "";
  String get getLog => _log;

  void log(String text) {
    _log = _log + text;
    debugPrint(text);
  }

  void clearLog() {
    _log = "";
  }

  void fetch() {
    final pc = Data.word(architecturalRegisters.pc.toSigned(32));
    log("  --> # FETCHING INSTR AT PC = 0x${pc.asUnsignedHexString(3)}!\n");
    instrWord = memory.loadWord(pc);
  }

  void dispatch() {
    final branchUnit = BranchUnit.singleton;
    if (branchUnit.undoDispatch) {
      log("  --> # SKIP: Dispatch blocked due to RoB flushing!\n");
      return;
    }

    /// DECODE
    final RISCVInstruction instr = RISCVDecoder.instructionFromWord(instrWord);

    if (instr == RISCVInstruction.nop) {
      log("  --> # END: INSTR. SET HAS TERMINATED!\n");
      return;
    }

    /// ROB IS FULL
    if (reorderBuffer.isFull) {
      log("  --> # SKIP: RoB is full!\n");
      return;
    }

    final opRegisters = RISCVDecoder.instrRegSelMapFromWord(
      instrWord,
      instr.opCodeType,
    );

    final RegisterAddress op1 = opRegisters[RegSel.rs1]!;
    final RegisterAddress op2 = opRegisters[RegSel.rs2]!;

    final int pr1 = architecturalRegisters.getRename(op1);
    final int pr2 = architecturalRegisters.getRename(op2);

    final RegisterAddress rd = opRegisters[RegSel.rd]!;

    int lprd = -1;
    int prd = -1;

    /// GET FREE PR
    if (rd != RegisterAddress.none) {
      lprd = architecturalRegisters.getRename(rd);
      prd = physicalRegisters.ownPR(false);

      /// ALL PRs ARE TAKEN
      if (prd == -1) {
        log("  --> # SKIP: Physical Registers are all taken.\n");
        return;
      }

      architecturalRegisters.renameRegister(rd, prd);
    }

    final imm = RISCVDecoder.instrImmSelMapFromWord(
      instrWord,
      instr.opCodeType,
    )[instr.immSelType];

    int dispatchTail = reorderBuffer.addNewEntry(
      ROBEntry(
        inUse: true,
        instructionType: instr,
        pr1: pr1,
        pr2: pr2,
        imm: imm,
        rd: rd,
        prd: prd,
        lprd: lprd,
      ),
    );

    architecturalRegisters.incPC();
    log("  --> # DISPATCHED TO ROB - Entry No. $dispatchTail!\n");
  }

  void run() {
    debugPrint(">> DISPATCHER: ");

    clearLog();

    fetch();
    dispatch();

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
