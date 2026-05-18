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

  void _issueEntry(int entryNumber) {
    final entry = reorderBuffer.buffer[entryNumber];

    debugPrint(
      "  --> instr: ${entry.instructionType.name} | pr1: P${entry.pr1} | pr2: P${entry.pr2} | | rd: ${entry.rd.name} | lprd: P${entry.lprd} |prd: P${entry.prd} ",
    );
    if (!entry.inUse) {
      debugPrint("  --> # SKIP: Entry not inUse");
      return;
    }

    if (entry.issued) {
      debugPrint("  --> # SKIP: Entry already Issued");
      return;
    }

    final fuType = entry.instructionType.functionalUnitType;
    final FunctionalUnit functionalUnit = functionalUnits.units[fuType]!;
    if (functionalUnit.isBusy) {
      debugPrint("  --> # SKIP: FU-'${fuType.name}' is still BUSY");
      return;
    }

    if (entry.pr1 != -1) {
      final pr1Valid = physicalRegisters.readValid(entry.pr1);
      if (!pr1Valid) {
        debugPrint("  --> # SKIP: PR1 = P${entry.pr1} is not yet ready!");
        return;
      }
    }

    if (entry.pr2 != -1) {
      final pr2Valid = physicalRegisters.readValid(entry.pr2);
      if (!pr2Valid) {
        debugPrint("  --> # SKIP: PR2 = P${entry.pr2} is not yet ready!");
        return;
      }
    }

    functionalUnit.issueEntry(entryNumber);
    entry.issued = true;
    debugPrint("  --># ISSUED: Successfully issued Entry No. $entryNumber!");
  }

  void run() {
    debugPrint(">> ISSUER:");
    debugPrint("-> Starting at CommitHead: ${reorderBuffer.commitHead}");

    for (
      int i = reorderBuffer.commitHead;
      i < reorderBuffer.buffer.length;
      i++
    ) {
      debugPrint("# Entry no. $i");
      _issueEntry(i);
    }
    for (int i = 0; i < reorderBuffer.commitHead; i++) {
      debugPrint("# Entry no. $i");
      _issueEntry(i);
    }
    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
