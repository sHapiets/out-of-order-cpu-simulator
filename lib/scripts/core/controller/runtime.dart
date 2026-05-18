import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/committer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/dispatcher.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/issuer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';

class Runtime {
  int cycleNumber = 0;
  final _dispatcher = Dispatcher.singleton;
  final _issuer = Issuer.singleton;
  final _functionUnits = FunctionalUnits.singleton;
  final _committer = Committer.singleton;

  void runCycle() {
    debugPrint("CYCLE NUMBER: $cycleNumber");
    debugPrint("------------------------------");

    _dispatcher.run();
    _issuer.run();
    _functionUnits.run();
    _committer.run();

    cycleNumber++;

    debugPrint("------------------------------");
    debugPrint(" ");
  }
}
