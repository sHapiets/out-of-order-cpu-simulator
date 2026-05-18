import 'package:out_of_order_cpu_coe197/scripts/foundation/data.dart';

enum ImmSel {
  none,
  immTypeI,
  immTypeXI,
  immTypeS,
  immTypeB,
  immTypeU,
  immTypeJ;

  const ImmSel();
  static const Map<int, ImmSel> fromIntDataMapping = {
    0: immTypeI,
    1: immTypeS,
    2: immTypeB,
    3: immTypeU,
    4: immTypeJ,
  };

  factory ImmSel.fromData(Data data) {
    final immSelected = fromIntDataMapping[data.asUnsignedInt()];
    if (immSelected == null) {
      throw FormatException(
        '[IMM.SEL ERROR] --> Data.intData: ${data.asUnsignedInt()} does not correspond to any ImmSel value. Check the loaded ROM.',
      );
    } else {
      return immSelected;
    }
  }
}
