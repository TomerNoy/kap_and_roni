import 'package:flutter/material.dart';
import 'package:kap_and_roni/theme.dart';

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;

  const ProgressBar({
    Key? key,
    required this.max,
    required this.current,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 30,
              decoration: BoxDecoration(color: Colors.grey[300]),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: percent,
              height: 30,
              decoration: const BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
