import 'package:flutter/material.dart';

class GameButton {
  late final id;
  late String text;
  late Color bg;
  late bool enabled;

  GameButton(
      {this.id, this.text = "", this.bg = Colors.grey, this.enabled = true});
}
