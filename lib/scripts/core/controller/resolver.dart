import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/branch_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/jump_unit.dart';

class Resolver {
  Resolver._();
  static final singleton = Resolver._();

  final reorderBuffer = ReorderBuffer.singleton;
  final branchUnit = BranchUnit.singleton;
  final jumpUnit = JumpUnit.singleton;

  String _log = "";
  String get getLog => _log;

  void log(String text) {
    _log = _log + text;
    debugPrint(text);
  }

  void clearLog() {
    _log = "";
  }

  void _undoEntry(int entryNumber) {
    final physicalRegister = PhysicalRegisters.singleton;
    final architecturalRegisters = ArchitecturalRegisters.singleton;

    final entry = reorderBuffer.buffer[entryNumber];
    physicalRegister.freePR(entry.prd);
    architecturalRegisters.renameRegister(entry.rd, entry.lprd);

    reorderBuffer.freeEntry(reorderBuffer.dispatchTail);
  }

  int _entryForwardDistance(int head, int tail, int entriesNum) {
    return (tail - head + entriesNum) % entriesNum;
  }

  void resolve() {
    final undoDispatch = branchUnit.undoDispatch || jumpUnit.undoDispatch;

    if (!undoDispatch) {
      log("  --> # SKIP: Branch/Jump FU's have no RoB dispatch undo requests.");
      return;
    }

    int undoEndEntry = 0;
    void Function(bool) resolveUnit = (_) {};

    /// BOTH JUMP AND BRANCH UNITS WANT TO UNDO
    final conflictUndo = branchUnit.undoDispatch && jumpUnit.undoDispatch;
    if (conflictUndo) {
      final commitHead = reorderBuffer.commitHead;
      final branchEntryDistance = _entryForwardDistance(
        commitHead,
        branchUnit.robEntryNumber,
        reorderBuffer.size,
      );
      final jumpEntryDistance = _entryForwardDistance(
        commitHead,
        jumpUnit.robEntryNumber,
        reorderBuffer.size,
      );
      if (branchEntryDistance <= jumpEntryDistance) {
        jumpUnit.resolved(false);
        resolveUnit = branchUnit.resolved;
        undoEndEntry = branchUnit.robEntryNumber;
      } else {
        branchUnit.resolved(false);
        resolveUnit = jumpUnit.resolved;
        undoEndEntry = jumpUnit.robEntryNumber;
      }
    } else {
      if (branchUnit.undoDispatch) {
        resolveUnit = branchUnit.resolved;
        undoEndEntry = branchUnit.robEntryNumber;
      }
      if (jumpUnit.undoDispatch) {
        resolveUnit = jumpUnit.resolved;
        undoEndEntry = jumpUnit.robEntryNumber;
      }
    }

    reorderBuffer.decDispatchTail();

    if (reorderBuffer.dispatchTail == undoEndEntry) {
      reorderBuffer.incDispatchTail();
      resolveUnit(true);
      log("  --> # END: Resuming dispatch...");
      return;
    }

    _undoEntry(reorderBuffer.dispatchTail);
    log("  --> # RESOLVING: Undo Entry No. (${reorderBuffer.dispatchTail})!");
  }

  void run() {
    debugPrint(">> RESOLVER:");

    clearLog();

    resolve();

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
