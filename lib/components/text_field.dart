import 'package:flutter/material.dart';
import 'package:resetti_gui/styles/text_style.dart';

Widget textField(dynamic stateVar, void Function(String) onSubmitted,
    {bool? obscureText}) {
  return SizedBox(
    width: 150,
    child: TextField(
      obscureText: (obscureText != null) ? obscureText : false,
      controller: TextEditingController(text: stateVar.toString()),
      textAlign: TextAlign.center,
      style: textStyle,
      onSubmitted: onSubmitted,
    ),
  );
}
