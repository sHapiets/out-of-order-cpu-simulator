import 'package:flutter/widgets.dart';
import 'package:out_of_order_cpu_coe197/scripts/core/components/architectural_registers.dart';
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
    final physicalRegisters = PhysicalRegisters.singleton;

    final entry = reorderBuffer.buffer[robEntryNumber];
    final instr = entry.instructionType;

    Data output = Data.wordZero();

    switch (instr) {
      case RISCVInstruction.sll:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned << shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srl:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.sra:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = physicalRegisters.readRegister(entry.pr2);

        final aSigned = a.asSignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aSigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.slli:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned << shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srli:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aUnsigned = a.asUnsignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aUnsigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      case RISCVInstruction.srai:
        Data a = physicalRegisters.readRegister(entry.pr1);
        Data b = entry.imm!;

        final aSigned = a.asSignedInt();
        final shamt = b.asUnsignedInt() & 0x1F;

        final result = (aSigned >> shamt).toSigned(DataType.word.bitLength);

        output = Data(signedInt: result, dataType: DataType.word);
        break;

      default:
    }

    physicalRegisters.setValid(entry.prd, true);
    physicalRegisters.writeRegister(entry.prd, output);

    entry.setCommitFunction(() {
      final architecturalRegisters = ArchitecturalRegisters.singleton;

      architecturalRegisters.setPR(entry.rd, entry.prd);
      physicalRegisters.freePR(entry.lprd);
    });

    debugPrint("      --->>> WRITE IN PR:");
    debugPrint(
      "            --->>>  P${entry.prd} = 0x${output.asUnsignedHexString(8)}",
    );
  }
}
