import 'package:flutter/painting.dart';
import 'package:out_of_order_cpu_coe197/scripts/layout/component/_painter/component_shape.dart';

class ComponentPaint {
  static Path paths(Size size, ComponentShape componentShape) {
    switch (componentShape) {
      case ComponentShape.functionalUnit:
        return Path()
          ..moveTo(0, size.height)
          ..lineTo(0, size.height * 0.6)
          ..lineTo(size.width * 0.2, size.height / 2)
          ..lineTo(0, size.height * 0.4)
          ..lineTo(0, size.height * 0)
          ..lineTo(size.width, size.height * 0.2)
          ..lineTo(size.width, size.height * 0.8)
          ..close();
      case ComponentShape.memory:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(20));
        return Path()
          ..addRRect(rrect)
          ..moveTo(size.width * 0.90, 0)
          ..lineTo(size.width * 0.81, size.height * 0.07)
          ..lineTo(size.width * 0.72, 0)
          ..close();
      case ComponentShape.physicalRegisterFile:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        return Path()
          ..addRect(rect)
          ..moveTo(size.width * 0.99, 0)
          ..lineTo(size.width * 0.90, size.height * 0.07)
          ..lineTo(size.width * 0.81, 0)
          ..close(); /* 
      case ComponentShape.architecturalRegisterFile:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);
        return Path()
          ..addRect(rect)
          ..moveTo(0, size.height * 0.1)
          ..lineTo(size.width * 0.08, size.height * 0.5)
          ..lineTo(0, size.height * 0.9)
          ..close(); */
      case ComponentShape.multiplexer:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width * 0.85, size.height)
          ..lineTo(size.width * 0.15, size.height)
          ..close();
      case ComponentShape.reorderBuffer:
        final rect = Rect.fromLTWH(0, 0, size.width, size.height);

        return Path()
          ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)));
      default:
        return Path()
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width * 0.85, size.height)
          ..lineTo(size.width * 0.15, size.height)
          ..close();
    }
  }
}
