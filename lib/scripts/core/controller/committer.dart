import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';

class Committer {
  Committer._();
  static final singleton = Committer._();

  int get latency => 1;
  int step = 0;

  final reorderBuffer = ReorderBuffer.singleton;
  final architecturalRegisters = ArchitecturalRegisters.singleton;
  final physicalRegisters = PhysicalRegisters.singleton;

  String _log = "";
  String get getLog => _log;

  void log(String text) {
    _log = _log + text;
    debugPrint(text);
  }

  void clearLog() {
    _log = "";
  }

  void commit(int commitHead) {
    final commitEntry = reorderBuffer.buffer[commitHead];

    if (step < latency) {
      log(
        "  --> # COMMITTING: Entry No. $commitHead is queued for committing!\n",
      );
      log("     --> # step -- $step/$latency\n");
      step = (step + 1).clamp(0, latency);
      return;
    }

    log("  --> # COMMITTED: Entry no. $commitHead has committed!\n");
    step = 0;

    commitEntry.commit();

    reorderBuffer.freeEntry(commitHead);
    reorderBuffer.incCommitHead();

    queueNextCommit();
  }

  void queueNextCommit() {
    final commitHead = reorderBuffer.commitHead;
    final commitEntry = reorderBuffer.buffer[reorderBuffer.commitHead];
    if (!commitEntry.completed) {
      log("  --> # SKIP: Entry No. $commitHead is not yet completed!\n");
      return;
    }

    commit(commitHead);
  }

  void run() {
    debugPrint(">> COMMITTER:");

    clearLog();

    queueNextCommit();

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
