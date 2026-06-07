import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/committer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/dispatcher.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/issuer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/resolver.dart';

class Runtime {
  Runtime._() {}
  static final singleton = Runtime._();

  ValueNotifier<int> cycleNumber = ValueNotifier(0);
  final _dispatcher = Dispatcher.singleton;
  final _issuer = Issuer.singleton;
  final _functionUnits = FunctionalUnits.singleton;
  final _committer = Committer.singleton;
  final _resolver = Resolver.singleton;

  void runCycle() {
    debugPrint("CYCLE NUMBER: $cycleNumber");
    debugPrint("------------------------------");

    _dispatcher.run();
    _issuer.run();
    _functionUnits.run();
    _committer.run();
    _resolver.run();

    cycleNumber.value = cycleNumber.value + 1;
  }

  void reset() {
    final rob = ReorderBuffer.singleton;
    final pRs = PhysicalRegisters.singleton;
    final aRs = ArchitecturalRegisters.singleton;
    final fUs = FunctionalUnits.singleton;
    final mem = Memory.singleton;

    rob.reset();
    pRs.reset();
    aRs.reset();
    fUs.reset();
    mem.reset();

    _dispatcher.clearLog();
    _issuer.clearLog();
    _committer.clearLog();
    _resolver.clearLog();

    cycleNumber.value = 0;
  }
}
