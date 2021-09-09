import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

import '../theme.dart';

class Box {
  final int index, count, x, y;

  Box({
    required this.index,
    required this.count,
    required this.x,
    required this.y,
  });

  Widget initBox(double gridSpacing, {String? label}) => Container(
        key: Key('box_$index'),
        height: gridSpacing,
        width: gridSpacing,
        // margin: EdgeInsets.all(0.5),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.grey.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // color: banana,
            // border: Border.all(color: darkGreen, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        alignment: label == null ? Alignment.center : Alignment.bottomLeft,
        child: label == null
            ? FittedBox(
                child: Text(
                  '$count',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: darkGreen),
                ),
              )
            : RotatedBox(
                quarterTurns: 3,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Text(
                      label,
                      style: subStyle.copyWith(
                        color: orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
      );

  Offset getOffset(double gridSpacing) =>
      Offset(gridSpacing * (0.5 + y), gridSpacing * (0.5 + x));
}
