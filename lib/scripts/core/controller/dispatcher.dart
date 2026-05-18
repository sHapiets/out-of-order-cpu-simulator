import 'package:flutter/rendering.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/rob_entry.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/reg_sel.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class Dispatcher {
  Dispatcher._();
  static final singleton = Dispatcher._();

  int pc = 0;
  Data instrWord = Data.wordZero();

  final reorderBuffer = ReorderBuffer.singleton;
  final physicalRegisters = PhysicalRegisters.singleton;
  final architecturalRegisters = ArchitecturalRegisters.singleton;

  List<Data> instructions = [
    Data.fromUnsignedHexString("00A08093", DataType.word),
    Data.fromUnsignedHexString("00A08113", DataType.word),
    Data.fromUnsignedHexString("00A17213", DataType.word),
    Data.fromUnsignedHexString("00A0F193", DataType.word),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
    Data.wordZero(),
  ];

  void fetch() {
    instrWord = instructions[pc];
  }

  void dispatch() {
    /// ROB IS FULL
    if (reorderBuffer.isFull) {
      debugPrint(" --> # SKIP: RoB is full!");
      return;
    }

    /// DECODE
    final RISCVInstruction instr = RISCVDecoder.instructionFromWord(instrWord);

    final opRegisters = RISCVDecoder.instrRegSelMapFromWord(
      instrWord,
      instr.opCodeType,
    );

    final RegisterAddress op1 = opRegisters[RegSel.rs1]!;
    final RegisterAddress op2 = opRegisters[RegSel.rs2]!;

    final int pr1 = architecturalRegisters.getRename(op1);
    final int pr2 = architecturalRegisters.getRename(op2);

    final RegisterAddress rd = opRegisters[RegSel.rd]!;
    final int lprd = architecturalRegisters.getRename(rd);
    final int prd = physicalRegisters.ownPR(false);

    /// ALL PRs ARE TAKEN
    if (prd == -1) {
      debugPrint("  --> # SKIP: Physical Registers are all taken.");
      return;
    }

    architecturalRegisters.renameRegister(rd, prd);

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

    pc += 1;

    debugPrint("  --> # DISPATCHED TO ROB - Entry No. $dispatchTail!");
  }

  void run() {
    debugPrint(">> DISPATCHER: ");

    fetch();
    dispatch();

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
