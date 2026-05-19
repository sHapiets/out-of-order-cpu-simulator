import 'package:flutter/rendering.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';

class ArchitecturalRegisters {
  ArchitecturalRegisters._();
  static final singleton = ArchitecturalRegisters._();

  final Map<RegisterAddress, int> _data =
      {for (final register in RegisterAddress.values) register: -1}
        ..remove(RegisterAddress.none)
        ..update(RegisterAddress.pc, (_) => 0)
        ..update(RegisterAddress.x0, (_) => 0);

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

  void incPC() {
    _data[RegisterAddress.pc] = _data[RegisterAddress.pc]! + 4;
  }

  void decPC() {
    _data[RegisterAddress.pc] = _data[RegisterAddress.pc]! - 4;
  }

  int get pc => _data[RegisterAddress.pc]!;

  void setPR(RegisterAddress regAdd, int pRAdd) {
    if (regAdd == RegisterAddress.none ||
        regAdd == RegisterAddress.pc ||
        regAdd == RegisterAddress.x0) {
      debugPrint(
        "----- INVALID regAdd: ${regAdd.name} cannot be written using .setPR",
      );
    }

    _data[regAdd] = pRAdd;
  }

  int getPR(RegisterAddress regAdd) {
    if (regAdd == RegisterAddress.none ||
        regAdd == RegisterAddress.pc ||
        regAdd == RegisterAddress.x0) {
      debugPrint(
        "----- INVALID regAdd: ${regAdd.name} is not bounded by a PR!",
      );
      return -1;
    }

    return _data[regAdd]!;
  }
}
