import 'package:flutter/painting.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class ComponentPaint {
  static Path paths(Size size, ComponentShape componentShape) {
    switch (componentShape) {
      case ComponentShape.functionalUnit:
        return Path()
          ..moveTo(size.width * 0.18, size.height)
          ..lineTo(size.width * 0.82, size.height)
          ..lineTo(size.width * 0.94, 0)
          ..lineTo(size.width * 0.06, 0)
          ..close();
      case ComponentShape.memory:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
        return Path()
          ..addRRect(rrect)
          ..close();
      case ComponentShape.architecturalRegisterFile:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        return Path()
          ..addRect(rect)
          ..close(); /* 
      case ComponentShape.physicallRegisterFile:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        return Path()
          ..addRect(rect)
          ..moveTo(0, size.height * 0.1)
          ..lineTo(size.width * 0.08, size.height * 0.5)
          ..lineTo(0, size.height * 0.9)
          ..close(); */
      case ComponentShape.physicalRegisterFile:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        return Path()
          ..addRect(rect)
          ..close();
      case ComponentShape.multiplexer:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width * 0.85, size.height)
          ..lineTo(size.width * 0.15, size.height)
          ..close();
      case ComponentShape.renameTable:
        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(10, 10, size.width, size.height),
          const Radius.circular(12),
        );

        return Path()..addRRect(rect);
      case ComponentShape.reorderBuffer:
        final outerRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(16),
        );

        final innerRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
          const Radius.circular(12),
        );

        return Path()
          ..addRRect(outerRect)
          ..addRRect(innerRect); /* 
      default:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width * 0.85, size.height)
          ..lineTo(size.width * 0.15, size.height)
          ..close(); */
    }
  }
}
