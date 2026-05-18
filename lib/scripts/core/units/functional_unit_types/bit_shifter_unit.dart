import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/physical_registers.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/reorder_buffer.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_decoder.dart';

class BitShifterUnit extends FunctionalUnit {
  BitShifterUnit._() : super(type: FunctionalUnitType.bitShift);
  static final singleton = BitShifterUnit._();

  @override
  void complete() {
    super.complete();

    final reorderBuffer = ReorderBuffer.singleton;
    final physcialRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.sll:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned << shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srl:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.sra:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = physcialRegisters.readRegister(entry.pr2);

        final aSigned = a.asSignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aSigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.slli:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned << shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srli:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srai:
        Data a = physcialRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aSigned = a.asSignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aSigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      default:
    }

    physcialRegisters.setValid(entry.prd, true);
    physcialRegisters.writeRegister(entry.prd, output);
    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = ${output.asUnsignedHexString(32)}",
    );
  }
}
