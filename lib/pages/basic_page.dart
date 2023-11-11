import 'dart:io';

import 'package:resetti_gui/components/bool_button.dart';
import 'package:resetti_gui/components/file_picker.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:toml/toml.dart';
import 'package:flutter/material.dart';

class BasicPage extends StatefulWidget {
  final String resettiProfile;
  const BasicPage({super.key, required this.resettiProfile});

  @override
  State<BasicPage> createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  String _resetCountPicked = "";
  bool _unpauseOnFocus = true;
  int _pollRate = 100;
  String _playRes = "";
  String _altRes = "";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            '${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml')
        .toMap();
    _resetCountPicked = profile['reset_count'];
    _unpauseOnFocus = profile['unpause_focus'];
    _pollRate = profile['poll_rate'];
    _playRes = profile['play_res'];
    _altRes = profile['alt_res'];
  }

  void profUpdate() {
    String profPath =
        '${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml';
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['reset_count'] = _resetCountPicked;
    profile["unpause_focus"] = _unpauseOnFocus;
    profile["poll_rate"] = _pollRate;
    profile["play_res"] = _playRes;
    profile["alt_res"] = _altRes;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rowWithText(
          context,
          "Reset Count File: ",
          filePicker(
            context,
            _resetCountPicked,
            (result) {
              if (result != null) {
                setState(
                  () => _resetCountPicked = result.files.single.path!,
                );
              }
              profUpdate();
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Unpause on focus: ",
          [
            boolButton(
              _unpauseOnFocus,
              () => setState(
                () {
                  _unpauseOnFocus = !_unpauseOnFocus;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Poll Rate: ",
          sliderWithText(
            _pollRate,
            100,
            1000,
            (rate) => setState(
              () {
                _pollRate = rate.toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Play Resolution: ",
          [
            textField(
              _playRes,
              (res) {
                setState(
                  () => _playRes = res,
                );
                profUpdate();
              },
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Alternate Resolution: ",
          [
            textField(
              _altRes,
              (res) {
                setState(
                  () => _altRes = res,
                );
                profUpdate();
              },
            )
          ],
        ),
      ],
    );
  }
}
