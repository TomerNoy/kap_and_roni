import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const BlinkingText({Key? key, required this.text, required this.style})
      : super(key: key);

  @override
  _BlinkingTextState createState() => _BlinkingTextState();
}

class _BlinkingTextState extends State<BlinkingText> {
  var isOn = true, isBlinking = true;
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(
        const Duration(milliseconds: 500), (_) => setState(() => isOn = !isOn));
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: widget.style.copyWith(color: isOn ? null : Colors.transparent),
    );
  }
}
