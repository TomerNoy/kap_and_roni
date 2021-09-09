import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kap_and_roni/models/arrow.dart';

import '../theme.dart';

class ArrowsPaint extends CustomPainter {
  final List<Arrow> arrows;

  ArrowsPaint(this.arrows);

  @override
  void paint(Canvas canvas, Size size) {
    /// create pairs from random offsets
    final paintBlue = Paint()
      ..color = blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintRed = Paint()
      ..color = red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final paintHeadRed = Paint()
      ..color = red
      ..style = PaintingStyle.fill;

    final paintHeadBlue = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;

    for (var pair in arrows) {
      final paint = pair.startCount < pair.endCount ? paintBlue : paintRed;
      final paintHead =
          pair.startCount < pair.endCount ? paintHeadBlue : paintHeadRed;
      final diffY = pair.start.dy - pair.end.dy;
      final diffX = pair.start.dx - pair.end.dx;

      /// calculate beginning of shaft line
      const radius = 13.0; // shaft gap from start and end point
      final distance = math.sqrt((diffX * diffX) + (diffY * diffY));
      final ratio = radius / distance; // distance ratio
      final startLine = Offset(
        (1 - ratio) * pair.start.dx + (ratio * pair.end.dx),
        (1 - ratio) * pair.start.dy + (ratio * pair.end.dy),
      );

      /// calculate end of shaft line
      final endLine = Offset(
        (1 - ratio) * pair.end.dx + (ratio * pair.start.dx),
        (1 - ratio) * pair.end.dy + (ratio * pair.start.dy),
      );

      /// calculate end of arrow head
      const arrowHeadShift = 8; // arrow head gap from end point
      final distance2 = math.sqrt((diffX * diffX) + (diffY * diffY));
      final ratioOfDistance2 = arrowHeadShift / distance2;

      final endOfArrow = Offset(
        (1 - ratioOfDistance2) * pair.end.dx +
            (ratioOfDistance2 * pair.start.dx),
        (1 - ratioOfDistance2) * pair.end.dy +
            (ratioOfDistance2 * pair.start.dy),
      );

      final slope = math.atan2(diffY, diffX);
      final rect = Rect.fromCenter(
        center: endOfArrow,
        width: radius * 1.5,
        height: radius * 1.5,
      );

      /// draw arrow
      canvas
        ..drawCircle(pair.start, radius, paint) //root
        ..drawLine(startLine, endLine, paint) // shaft
        ..drawArc(rect, slope - 0.5, 1, true, paintHead); //head
    }
  }

  @override
  bool shouldRepaint(CustomPainter old) => false;
}
