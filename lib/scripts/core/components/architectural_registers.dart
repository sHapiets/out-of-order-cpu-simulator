import 'package:flutter/rendering.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';

class ArchitecturalRegisters {
  ArchitecturalRegisters._();
  static final singleton = ArchitecturalRegisters._();

  Map<RegisterAddress, int> pR = {
    for (final register in RegisterAddress.values) register: -1,
  }..remove(RegisterAddress.none);

  Map<RegisterAddress, int> renameTable = {
    for (final register in RegisterAddress.values) register: -1,
  }..remove(RegisterAddress.none);

  void renameRegister(RegisterAddress regAdd, int prAdd) {
    renameTable[regAdd] = prAdd;
  }

  int getRename(RegisterAddress regAdd) {
    if (regAdd == RegisterAddress.none) {
      return -1;
    }

    if (renameTable[regAdd] == null) {
      debugPrint("regAdd: ${regAdd.name} does not exist in the renameTable!");
      return -1;
    }

    if (renameTable[regAdd] == -1) {
      final newPRAddress = PhysicalRegisters.singleton.ownPR(true);
      renameRegister(regAdd, newPRAddress);
      setPR(regAdd, newPRAddress);
      return newPRAddress;
    }

    return renameTable[regAdd]!;
  }

  void setPR(RegisterAddress regAdd, int pRAdd) {
    pR[regAdd] = pRAdd;
  }

  int getPR(RegisterAddress regAdd) {
    if (pR[regAdd] == null) {
      debugPrint("regAdd: ${regAdd.name} does not exist in the data!");
      return -1;
    }

    return pR[regAdd]!;
  }
}
