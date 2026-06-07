import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/rob_entry.dart';

class ReorderBuffer {
  ReorderBuffer._() {
    initialize();
  }
  static final singleton = ReorderBuffer._();

  int commitHead = 0;
  int dispatchTail = 0;
  int get size => Configuration.singleton.reorderBufferSize;

  bool get isFull => _buffer[dispatchTail].inUse;

  List<ROBEntry> _buffer = [];
  List<ROBEntry> get buffer => _buffer;

  void initialize() {
    _buffer = List.filled(size, ROBEntry.empty);
  }

  void reset() {
    initialize();
    commitHead = 0;
    dispatchTail = 0;
  }

  void incDispatchTail({int steps = 1}) {
    dispatchTail = (dispatchTail + steps) % size;
  }

  void decDispatchTail() {
    dispatchTail = (dispatchTail % size - 1) % size;
  }

  void incCommitHead({int steps = 1}) {
    commitHead = (commitHead + steps) % size;
  }

  int addNewEntry(ROBEntry newEntry) {
    int entryNumber = dispatchTail;
    _buffer[entryNumber] = newEntry;
    incDispatchTail();
    return entryNumber;
  }

  void freeEntry(int robEntryNum) {
    _buffer[robEntryNum] = ROBEntry();
  }
}
