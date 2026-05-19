import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class BitOperatorUnit extends FunctionalUnit {
  BitOperatorUnit._() : super(type: FunctionalUnitType.bitOperator);
  static final singleton = BitOperatorUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physcialRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.and:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned & bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      case RISCVInstruction.andi:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned & bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      case RISCVInstruction.or:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned | bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      case RISCVInstruction.ori:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned | bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      case RISCVInstruction.xor:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned ^ bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      case RISCVInstruction.xori:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aSigned = a.asSignedInt();
        final bSigned = b.asSignedInt();
        final resultSigned = (aSigned ^ bSigned).toSigned(
          DataType.word.bitLength,
        );
        output = Data(signedInt: resultSigned, dataType: DataType.word);

      default:
    }

    physcialRegisters.setValid(entry.prd, true);
    physcialRegisters.writeRegister(entry.prd, output);
    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
    );
  }
}
