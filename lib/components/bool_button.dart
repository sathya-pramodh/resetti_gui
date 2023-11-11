import 'package:flutter/material.dart';
import 'package:resetti_gui/styles/button_style.dart';
import 'package:resetti_gui/styles/text_style.dart';

Widget boolButton(bool stateVar, void Function() onPressed) {
  return ElevatedButton(
    style: buttonStyle,
    onPressed: onPressed,
    child: Text(
      style: textStyle,
      stateVar.toString(),
    ),
  );
}
