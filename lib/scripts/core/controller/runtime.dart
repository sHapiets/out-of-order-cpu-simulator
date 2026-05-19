import 'package:flutter/cupertino.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/memory.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/configuration.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/committer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/dispatcher.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/controller/issuer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/functional_units.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';

class Runtime {
  Runtime() {
    setPresetInstructions();
  }

  int cycleNumber = 0;
  final _dispatcher = Dispatcher.singleton;
  final _issuer = Issuer.singleton;
  final _functionUnits = FunctionalUnits.singleton;
  final _committer = Committer.singleton;

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

    final archReg = ArchitecturalRegisters.singleton;
    final physReg = PhysicalRegisters.singleton;
    debugPrint(">> ARCHITECTURAL REGISTERS");
    debugPrint("  --> DATA / PR");
    for (final register in RegisterAddress.values) {
      if (register == RegisterAddress.none) continue;

      if (register == RegisterAddress.pc) {
        debugPrint(
          "    --> ${register.name} : 0x${archReg.debugGetData(register).toRadixString(16).padLeft(3, '0')}",
        );
        continue;
      }
      if (register == RegisterAddress.x0) {
        debugPrint(
          "    --> ${register.name} : ${archReg.debugGetData(register)}",
        );
        continue;
      }

      debugPrint(
        "    --> ${register.name} : P${archReg.debugGetData(register)} = 0x${physReg.readRegister(archReg.debugGetData(register)).asUnsignedHexString(8)}",
      );
    }

    debugPrint("  --> RENAME TABLE");
    for (final register in archReg.renameTable.keys) {
      debugPrint(
        "    --> ${register.name} : P${archReg.renameTable[register]}",
      );
    }

    cycleNumber++;

    debugPrint("------------------------------");
    debugPrint(" ");
  }
}
