import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';

class Committer {
  Committer._();
  static final singleton = Committer._();

  int get latency => 1;
  int step = 0;

  final reorderBuffer = ReorderBuffer.singleton;
  final architecturalRegisters = ArchitecturalRegisters.singleton;
  final physicalRegisters = PhysicalRegisters.singleton;

  void commit(int commitHead) {
    final commitEntry = reorderBuffer.buffer[commitHead];

    if (step < latency) {
      debugPrint(
        "  --> # COMMITTING: Entry No. $commitHead is queued for committing!",
      );
      debugPrint("     --> # step -- $step/$latency");
      step = (step + 1).clamp(0, latency);
      return;
    }

    debugPrint("  --> # COMMITTED: Entry no. $commitHead has committed!");
    step = 0;

    final FunctionalUnitType fuType =
        commitEntry.instructionType.functionalUnitType;
    if (fuType == FunctionalUnitType.memory) {
    } else {
      architecturalRegisters.setPR(commitEntry.rd, commitEntry.prd);
    }

    physicalRegisters.freePR(commitEntry.lprd);
    reorderBuffer.freeEntry(commitHead);
    reorderBuffer.incCommitHead();

    queueNextCommit();
  }

  void queueNextCommit() {
    final commitHead = reorderBuffer.commitHead;
    final commitEntry = reorderBuffer.buffer[reorderBuffer.commitHead];
    if (!commitEntry.completed) {
      debugPrint("  --> # SKIP: Entry No. $commitHead is not yet completed");
      return;
    }

    commit(commitHead);
  }

  void run() {
    debugPrint(">> COMMITTER:");

    queueNextCommit();

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
