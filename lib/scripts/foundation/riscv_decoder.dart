import 'package:out_of_order_cpu_coe197/scripts/core/units/functional_unit_types/functional_unit.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/imm_sel.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/reg_sel.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/register_address.dart';
import 'package:out_of_order_cpu_coe197/scripts/foundation/riscv_instruction_group.dart';

class RISCVDecoder {
  static RISCVInstruction instructionFromWord(Data instrWord) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    String opCodeString = instrDiv[0].asUnsignedBitString(7);
    switch (opCodeString) {
      case "0110011":
        final functString =
            "${instrDiv[2].asUnsignedBitString(3)}${instrDiv[5].asUnsignedBitString(7)}";
        switch (functString) {
          case "0000000000":
            return RISCVInstruction.add;
          case "0000100000":
            return RISCVInstruction.sub;
          case "1110000000":
            return RISCVInstruction.and;
          case "1100000000":
            return RISCVInstruction.or;
          case "1000000000":
            return RISCVInstruction.xor;
          case "0010000000":
            return RISCVInstruction.sll;
          case "1010000000":
            return RISCVInstruction.srl;
          case "1010100000":
            return RISCVInstruction.sra;
          case "0100000000":
            return RISCVInstruction.slt;
          case "0110000000":
            return RISCVInstruction.sltu;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> R-type Instruction of FUNCT3|FUNCT7: (functString: $functString) does not exist. Check loaded instruction.',
            );
        }

      case "0010011":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        String funct7string = "";
        if (funct3string == "001" || funct3string == "101") {
          funct7string = instrDiv[5].asUnsignedBitString(7);
        }

        final functString = "$funct3string$funct7string";
        switch (functString) {
          case "000":
            return RISCVInstruction.addi;
          case "111":
            return RISCVInstruction.andi;
          case "110":
            return RISCVInstruction.ori;
          case "100":
            return RISCVInstruction.xori;
          case "0010000000":
            return RISCVInstruction.slli;
          case "1010000000":
            return RISCVInstruction.srli;
          case "1010100000":
            return RISCVInstruction.srai;
          case "010":
            return RISCVInstruction.slti;
          case "011":
            return RISCVInstruction.sltiu;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> I-type Instruction of FUNCT3|FUNCT7: (functString: $functString) does not exist. Check loaded instruction.',
            );
        }
      case "0000011":
        final funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.lb;
          case "100":
            return RISCVInstruction.lbu;
          case "001":
            return RISCVInstruction.lh;
          case "101":
            return RISCVInstruction.lhu;
          case "010":
            return RISCVInstruction.lw;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> I-type LOAD Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "0100011":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.sb;
          case "001":
            return RISCVInstruction.sh;
          case "010":
            return RISCVInstruction.sw;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> S-type Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "1100011":
        final funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.beq;
          case "101":
            return RISCVInstruction.bge;
          case "111":
            return RISCVInstruction.bgeu;
          case "100":
            return RISCVInstruction.blt;
          case "110":
            return RISCVInstruction.bltu;
          case "001":
            return RISCVInstruction.bne;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> B-type Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "1101111":
        return RISCVInstruction.jal;

      case "1100111":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.jalr;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> J-type Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      case "0010111":
        return RISCVInstruction.auipc;

      case "0110111":
        return RISCVInstruction.lui;

      case "0000000":
        return RISCVInstruction.nop;

      case "1001001":
        final String funct3string = instrDiv[2].asUnsignedBitString(3);
        switch (funct3string) {
          case "000":
            return RISCVInstruction.addm;
          case "100":
            return RISCVInstruction.cmovm;
          case "111":
            return RISCVInstruction.delm;
          default:
            throw FormatException(
              '[RISCV-INSTRUCTION ERROR] --> CISC-type Instruction of FUNCT3: (functString: $funct3string) does not exist. Check loaded instruction.',
            );
        }

      default:
        throw FormatException(
          '[RISCV-INSTRUCTION ERROR] --> OpCode: "$opCodeString" does not exist. Check loaded instruction',
        );
    }
  }

  static Map<RegSel, RegisterAddress> instrRegSelMapFromWord(
    Data instrWord,
    RISCVOpCodeType opcode,
  ) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    switch (opcode) {
      case RISCVOpCodeType.R:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.I:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.none,
        };
      case RISCVOpCodeType.xI:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.none,
        };
      case RISCVOpCodeType.S:
        return {
          RegSel.rd: RegisterAddress.none,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.B:
        return {
          RegSel.rd: RegisterAddress.none,
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };
      case RISCVOpCodeType.U:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.none,
          RegSel.rs2: RegisterAddress.none,
        };
      case RISCVOpCodeType.J:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.none,
          RegSel.rs2: RegisterAddress.none,
        };
      case RISCVOpCodeType.C:
        return {
          RegSel.rd: RegisterAddress.fromData(instrDiv[1]),
          RegSel.rs1: RegisterAddress.fromData(instrDiv[3]),
          RegSel.rs2: RegisterAddress.fromData(instrDiv[4]),
        };

      case RISCVOpCodeType.E:
        return {
          RegSel.rd: RegisterAddress.none,
          RegSel.rs1: RegisterAddress.none,
          RegSel.rs2: RegisterAddress.none,
        };
    }
  }

  static Map<ImmSel, Data> instrImmSelMapFromWord(
    Data instrWord,
    RISCVOpCodeType opcode,
  ) {
    List<Data> instrDiv = [
      Data.word(instrWord.asUnsignedInt() & 0x7F),
      Data.word((instrWord.asUnsignedInt() >> 7) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 12) & 0x7),
      Data.word((instrWord.asUnsignedInt() >> 15) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 20) & 0x1F),
      Data.word((instrWord.asUnsignedInt() >> 25) & 0x7F),
    ];

    final I =
        "${instrDiv[5].asUnsignedBitString(7)}${instrDiv[4].asUnsignedBitString(5)}";
    final xI = instrDiv[4].asUnsignedBitString(5);
    final S =
        "${instrDiv[5].asUnsignedBitString(7)}${instrDiv[1].asUnsignedBitString(5)}";

    final b0 = "0";
    final b1 = instrDiv[1].asUnsignedBitString(5).substring(0, 4);
    final b2 = instrDiv[5].asUnsignedBitString(7).substring(1, 7);
    final b3 = instrDiv[1].asUnsignedBitString(5).substring(4);
    final b4 = instrDiv[5].asUnsignedBitString(7).substring(0, 1);
    final B = "$b4$b3$b2$b1$b0";

    final U =
        "${instrDiv[5].asUnsignedBitString(7)}${instrDiv[4].asUnsignedBitString(5)}${instrDiv[3].asUnsignedBitString(5)}${instrDiv[2].asUnsignedBitString(3)}";

    final j0 = "0";
    final j1 = I.substring(1, 11);
    final j2 = I.substring(11, 12);
    final j3 =
        "${instrDiv[3].asUnsignedBitString(5)}${instrDiv[2].asUnsignedBitString(3)}";
    final j4 = I.substring(0, 1);
    final J = "$j4$j3$j2$j1$j0";

    return {
      ImmSel.none: Data.wordZero(),
      ImmSel.immTypeI: Data.fromSignedBitString(I, DataType.word),
      ImmSel.immTypeXI: Data.fromSignedBitString(xI, DataType.word),
      ImmSel.immTypeS: Data.fromSignedBitString(S, DataType.word),
      ImmSel.immTypeB: Data.fromSignedBitString(B, DataType.word),
      ImmSel.immTypeU: Data.fromSignedBitString(U, DataType.word),
      ImmSel.immTypeJ: Data.fromSignedBitString(J, DataType.word),
    };
  }
}

enum RISCVOpCodeType { R, I, xI, S, B, U, J, E, C }

enum RISCVInstruction {
  nop(
    opCodeType: RISCVOpCodeType.E,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  // =========================
  // R-Type Arithmetic
  // =========================

  add(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  sub(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  and(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.and,
  ),

  or(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.or,
  ),

  xor(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.xor,
  ),

  sll(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  srl(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  sra(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  slt(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.slt,
    instrGroup: RISCVInstructionGroup.slt,
  ),

  sltu(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.slt,
    instrGroup: RISCVInstructionGroup.slt,
  ),

  // =========================
  // I-Type Arithmetic
  // =========================

  addi(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  andi(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.and,
  ),

  ori(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.or,
  ),

  xori(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.bitOperator,
    instrGroup: RISCVInstructionGroup.xor,
  ),

  slli(
    opCodeType: RISCVOpCodeType.xI,
    immSelType: ImmSel.immTypeXI,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  srli(
    opCodeType: RISCVOpCodeType.xI,
    immSelType: ImmSel.immTypeXI,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  srai(
    opCodeType: RISCVOpCodeType.xI,
    immSelType: ImmSel.immTypeXI,
    functionalUnitType: FunctionalUnitType.bitShift,
    instrGroup: RISCVInstructionGroup.shift,
  ),

  slti(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.slt,
    instrGroup: RISCVInstructionGroup.slt,
  ),

  sltiu(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.slt,
    instrGroup: RISCVInstructionGroup.slt,
  ),

  // =========================
  // Loads
  // =========================

  lb(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.load,
  ),

  lbu(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.load,
  ),

  lh(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.load,
  ),

  lhu(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.load,
  ),

  lw(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.load,
  ),

  // =========================
  // Stores
  // =========================

  sb(
    opCodeType: RISCVOpCodeType.S,
    immSelType: ImmSel.immTypeS,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.store,
  ),

  sh(
    opCodeType: RISCVOpCodeType.S,
    immSelType: ImmSel.immTypeS,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.store,
  ),

  sw(
    opCodeType: RISCVOpCodeType.S,
    immSelType: ImmSel.immTypeS,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.store,
  ),

  // =========================
  // Branches
  // =========================

  beq(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  bge(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  bgeu(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  blt(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  bltu(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  bne(
    opCodeType: RISCVOpCodeType.B,
    immSelType: ImmSel.immTypeB,
    functionalUnitType: FunctionalUnitType.branch,
    instrGroup: RISCVInstructionGroup.branch,
  ),

  // =========================
  // Jumps
  // =========================

  jal(
    opCodeType: RISCVOpCodeType.J,
    immSelType: ImmSel.immTypeJ,
    functionalUnitType: FunctionalUnitType.jump,
    instrGroup: RISCVInstructionGroup.jump,
  ),

  jalr(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.jump,
    instrGroup: RISCVInstructionGroup.jump,
  ),

  // =========================
  // U-Type
  // =========================

  auipc(
    opCodeType: RISCVOpCodeType.U,
    immSelType: ImmSel.immTypeU,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  lui(
    opCodeType: RISCVOpCodeType.U,
    immSelType: ImmSel.immTypeU,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  // =========================
  // Custom Instructions
  // =========================

  addm(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  cmovm(
    opCodeType: RISCVOpCodeType.R,
    immSelType: ImmSel.none,
    functionalUnitType: FunctionalUnitType.arithmetic,
    instrGroup: RISCVInstructionGroup.arithmetic,
  ),

  delm(
    opCodeType: RISCVOpCodeType.I,
    immSelType: ImmSel.immTypeI,
    functionalUnitType: FunctionalUnitType.memory,
    instrGroup: RISCVInstructionGroup.store,
  );

  const RISCVInstruction({
    required this.opCodeType,
    required this.immSelType,
    required this.functionalUnitType,
    required this.instrGroup,
  });

  final RISCVOpCodeType opCodeType;
  final ImmSel immSelType;
  final FunctionalUnitType functionalUnitType;
  final RISCVInstructionGroup instrGroup;
}
