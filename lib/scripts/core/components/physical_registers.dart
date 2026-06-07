import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/physical_register.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';

class PhysicalRegisters {
  PhysicalRegisters._() {
    initialize(10);
  }
  static final singleton = PhysicalRegisters._();

  List<PhysicalRegister> _registers = [];
  List<PhysicalRegister> get registers => _registers;

  void initialize(int registerAmount) {
    for (int address = 0; address < registerAmount; address++) {
      _registers.add(PhysicalRegister.newRegister(address));
    }
  }

  void reset() {
    _registers = [];
    initialize(10);
  }

  bool _invalidRegisterAddress(int address) => _registers.length <= address;

  int ownPR(bool autoValid) {
    for (int i = 0; i < _registers.length; i++) {
      final register = _registers[i];
      if (register.isFree) {
        register.own();
        register.setValid(autoValid);
        return i;
      }
    }

    /// FLAG IS -1 FOR NO FREE PR
    return -1;
  }

  void freePR(int address) {
    if (address == -1) return;

    _registers[address].free();
  }

  bool readValid(int address) {
    return _registers[address].valid;
  }

  Data readRegister(int address) {
    if (address == -1) {
      return Data.wordZero();
    }

    return _registers[address].data;
  }

  void writeRegister(int address, Data newData) {
    if (_invalidRegisterAddress(address)) {
      debugPrint("Chosen register (address = P$address) is INVALID!");
      return;
    }

    _registers[address].writeData(newData);
  }

  void setValid(int address, bool valid) {
    if (_invalidRegisterAddress(address)) {
      debugPrint("Chosen register (address = P$address) is INVALID!");
      return;
    }

    _registers[address].setValid(valid);
  }
}
