import 'package:flutter/material.dart';
import 'package:resetti_gui/styles/text_style.dart';

Widget rowWithText(
    BuildContext context, String title, List<Widget> otherChildren) {
  return Row(
    children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          Text(
            style: textStyle,
            title,
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.001),
        ] +
        otherChildren,
  );
}
