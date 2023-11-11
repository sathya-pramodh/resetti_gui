import 'package:flutter/material.dart';

ButtonStyle buttonStyle = ButtonStyle(
  fixedSize: MaterialStateProperty.all<Size>(
    const Size.fromWidth(175),
  ),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  ),
  backgroundColor: MaterialStateProperty.all<Color>(
    const Color.fromRGBO(95, 95, 95, 1),
  ),
  foregroundColor: MaterialStateProperty.all<Color>(
    const Color.fromRGBO(201, 201, 201, 1),
  ),
);
