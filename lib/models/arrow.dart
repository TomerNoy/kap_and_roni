import 'package:flutter/cupertino.dart';

class Arrow {
  final Offset start, end;
  final int startCount, endCount;

  Arrow({
    required this.start,
    required this.end,
    required this.startCount,
    required this.endCount,
  });

  Arrow flip() => Arrow(
        start: end,
        end: start,
        startCount: endCount,
        endCount: startCount,
      );

  bool isUp() => startCount < endCount;
}
