import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';

class PhysicalRegister {
  PhysicalRegister({required this.address});

  final int address;
  Data _data = Data.wordZero();
  bool _free = true;
  bool _valid = false;

  bool get hasValidData => _valid;
  bool get isFree => _free;
  Data get data => _data;
  bool get valid => _valid;

  static PhysicalRegister newRegister(int address) =>
      PhysicalRegister(address: address);

  void setValid(bool validBool) {
    _valid = validBool;
  }

  void writeData(Data newData) {
    _data = newData;
  }

  void own() {
    _free = false;
  }

  void free() {
    _data = Data.wordZero();
    _free = true;
    _valid = false;
  }
}
