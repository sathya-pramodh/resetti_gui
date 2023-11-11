import 'package:flutter/material.dart';
import 'package:resetti_gui/styles/text_style.dart';

List<Widget> sliderWithText(dynamic stateVar, double min, double max,
    void Function(dynamic) onChanged) {
  return [
    Slider(
      min: min,
      max: max,
      divisions: (max - min).toInt(),
      value: stateVar.toDouble(),
      label: stateVar.round().toString(),
      onChanged: onChanged,
    ),
    Text(
      style: textStyle,
      stateVar.round().toString(),
    ),
  ];
}
