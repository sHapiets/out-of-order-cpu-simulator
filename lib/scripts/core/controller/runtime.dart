import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/committer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/dispatcher.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/issuer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/resolver.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/misc/cycle_log_ui.dart';

class Runtime {
  Runtime._() {
    setPresetInstructions();
  }
  static final singleton = Runtime._();

  ValueNotifier<int> cycleNumber = ValueNotifier(0);
  final _dispatcher = Dispatcher.singleton;
  final _issuer = Issuer.singleton;
  final _functionUnits = FunctionalUnits.singleton;
  final _committer = Committer.singleton;
  final _resolver = Resolver.singleton;

  void setPresetInstructions() {
    final config = Configuration.singleton;
    final memory = Memory.singleton;

    for (int i = 0; i < config.instructions.length; i++) {
      final address = Data.word((i * 4).toSigned(32));
      final instr = config.instructions[i];
      memory.storeInstruction(instr, address);
    }
  }

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
