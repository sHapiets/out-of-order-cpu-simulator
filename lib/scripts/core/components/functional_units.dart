import 'package:flutter/material.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/bit_operator_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/arithmetic_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/bit_shifter_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';

class FunctionalUnits {
  FunctionalUnits._();
  static final singleton = FunctionalUnits._();

  Map<FunctionalUnitType, FunctionalUnit> units = {
    FunctionalUnitType.arithmetic: ArithmeticUnit.singleton,
    FunctionalUnitType.bitOperator: BitOperatorUnit.singleton,
    FunctionalUnitType.bitShift: BitShifterUnit.singleton,
  };

  void run() {
    debugPrint(">> FUNCTIONAL UNITS");
    for (final fUnit in units.values) {
      fUnit.run();

      debugPrint(" --> TYPE: '${fUnit.type.name}'");
      debugPrint("   # isBusy -- '${fUnit.isBusy}'");
      if (fUnit.isBusy) {
        debugPrint("      # Entry No. -- (${fUnit.robEntryNumber})");
        debugPrint("      # step -- ${fUnit.step}/${fUnit.entryLatency}");
      }

      if (fUnit.isComplete) {
        debugPrint("   # COMPLETED -- '${fUnit.isBusy}'");
        fUnit.complete();
      }
    }

    debugPrint(">> END >>");
    debugPrint(" ");
  }
}
