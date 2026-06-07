import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';

class Issuer {
  Issuer._();
  static final singleton = Issuer._();

  final reorderBuffer = ReorderBuffer.singleton;
  final functionalUnits = FunctionalUnits.singleton;
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

  void _issueEntry(int entryNumber) {
    final entry = reorderBuffer.buffer[entryNumber];

    if (!entry.inUse) {
      log("  --> # SKIP: Entry not in Use!\n");
      return;
    }

    if (entry.issued) {
      log("  --> # SKIP: Entry already Issued!\n");
      return;
    }

    final fuType = entry.instructionType.functionalUnitType;
    final FunctionalUnit functionalUnit = functionalUnits.units[fuType]!;
    if (functionalUnit.isBusy) {
      log("  --> # SKIP: FU-'${fuType.name}' is still BUSY!\n");
      return;
    }

    if (entry.pr1 != -1) {
      final pr1Valid = physicalRegisters.readValid(entry.pr1);
      if (!pr1Valid) {
        log("  --> # SKIP: PR1 = P${entry.pr1} is not yet ready!\n");
        return;
      }
    }

    if (entry.pr2 != -1) {
      final pr2Valid = physicalRegisters.readValid(entry.pr2);
      if (!pr2Valid) {
        log("  --> # SKIP: PR2 = P${entry.pr2} is not yet ready!\n");
        return;
      }
    }

    functionalUnit.issueEntry(entryNumber);
    entry.issued = true;
    log("  --># ISSUED: Successfully issued Entry No. $entryNumber!\n");
  }

  void run() {
    debugPrint(">> ISSUER:");

    clearLog();

    log("-> Starting at CommitHead: ${reorderBuffer.commitHead}\n");

    for (
      int i = reorderBuffer.commitHead;
      i < reorderBuffer.buffer.length;
      i++
    ) {
      log("# Entry no. $i\n");
      _issueEntry(i);
    }
    for (int i = 0; i < reorderBuffer.commitHead; i++) {
      log("# Entry no. $i\n");
      _issueEntry(i);
    }

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
