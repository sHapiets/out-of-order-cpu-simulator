import 'package:flutter/rendering.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';

class ArchitecturalRegisters {
  ArchitecturalRegisters._() {
    initialize();
  }
  static final singleton = ArchitecturalRegisters._();

  Map<RegisterAddress, int> _data = {};

  Map<RegisterAddress, int> renameTable = {};

  void initialize() {
    _data = {for (final register in RegisterAddress.values) register: -1}
      ..remove(RegisterAddress.none)
      ..update(RegisterAddress.pc, (_) => 0)
      ..update(RegisterAddress.x0, (_) => 0);

    renameTable = {for (final register in RegisterAddress.values) register: -1}
      ..remove(RegisterAddress.none)
      ..remove(RegisterAddress.pc)
      ..remove(RegisterAddress.x0);
  }

  void reset() {
    initialize();
  }

  void renameRegister(RegisterAddress regAdd, int prAdd) {
    renameTable[regAdd] = prAdd;
  }

  int getRename(RegisterAddress regAdd) {
    if (regAdd == RegisterAddress.none) {
      return -1;
    }

    if (renameTable[regAdd] == null) {
      return -1;
    }

    if (renameTable[regAdd] == -1) {
      final newPRAddress = PhysicalRegisters.singleton.ownPR(true);

      if (newPRAddress == -1) {
        return -1;
      }

      renameRegister(regAdd, newPRAddress);
      setPR(regAdd, newPRAddress);
      return newPRAddress;
    }

    return renameTable[regAdd]!;
  }

  void setPC(int newPC) {
    _data[RegisterAddress.pc] = newPC;
  }

  void offsetPC(int offset) {
    _data[RegisterAddress.pc] = _data[RegisterAddress.pc]! + offset;
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

  int debugGetData(RegisterAddress regAdd) {
    return _data[regAdd]!;
  }
}
