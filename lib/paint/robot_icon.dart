import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RobotIcon extends StatelessWidget {
  final Color col;
  final double scale;

  const RobotIcon({
    Key? key,
    required this.col,
    this.scale = 1.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        FaIcon(FontAwesomeIcons.robot, size: scale * 6.5, color: col),
        Padding(
          padding: EdgeInsets.only(top: scale * 7.0),
          child:
              FaIcon(FontAwesomeIcons.microchip, size: scale * 10, color: col),
        ),
        Padding(
          padding: EdgeInsets.only(top: scale * 16),
          child: Icon(Icons.headset, size: scale * 10, color: col),
        ),
      ],
    );
  }
}
