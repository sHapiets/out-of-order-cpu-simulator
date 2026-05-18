import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';

enum RegSel {
  rs1,
  rs2,
  rd,
  pc;

  const RegSel();
  static const fromIntDataMapping = {
    0: RegSel.rs1,
    1: RegSel.rs2,
    2: RegSel.rd,
    3: RegSel.pc,
  };

  factory RegSel.fromData(Data data) {
    final RegSel? regSelFromData = fromIntDataMapping[data.asUnsignedInt()];

    if (regSelFromData == null) {
      throw FormatException(
        '[REGSEL ERROR] --> Invalid Data.intData to Register Address. Check ROM RegSel.',
      );
    }

    return regSelFromData;
  }
}
