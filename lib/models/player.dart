import 'package:flutter/material.dart';

class Player {
  int atBox;
  final String name;
  final Color color;

  Player(this.name, this.color, {this.atBox = 0});
}
