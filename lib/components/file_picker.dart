import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:resetti_gui/styles/button_style.dart';
import 'package:resetti_gui/styles/text_style.dart';

List<Widget> filePicker(BuildContext context, dynamic stateVar,
    FutureOr Function(FilePickerResult?) result) {
  return [
    ElevatedButton(
      style: buttonStyle,
      onPressed: () {
        FilePicker.platform.pickFiles().then(result);
      },
      child: Text(
        style: textStyle,
        "Pick",
      ),
    ),
    SizedBox(width: MediaQuery.of(context).size.width * 0.001),
    Text(
      style: textStyle,
      stateVar.toString(),
    ),
  ];
}
