import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:toml/toml.dart';

class DelayPage extends StatefulWidget {
  final String resettiProfile;
  const DelayPage({super.key, required this.resettiProfile});

  @override
  State<DelayPage> createState() => _DelayPageState();
}

class _DelayPageState extends State<DelayPage> {
  int _wpPause = 0;
  int _idlePause = 0;
  int _unpause = 0;
  int _stretch = 0;
  int _ghostPieFix = 0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            '${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml')
        .toMap();
    setState(
      () {
        _wpPause = profile['delay']['wp_pause'];
        _idlePause = profile['delay']['idle_pause'];
        _unpause = profile['delay']['unpause'];
        _stretch = profile['delay']['stretch'];
        _ghostPieFix = profile['delay']['ghost_pie_fix'];
      },
    );
  }

  void profUpdate() {
    String profilePath =
        '${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml';
    Map<String, dynamic> profile = TomlDocument.loadSync(profilePath).toMap();
    profile['delay']['wp_pause'] = _wpPause;
    profile['delay']['idle_pause'] = _idlePause;
    profile['delay']['unpause'] = _unpause;
    profile['delay']['stretch'] = _stretch;
    profile['delay']['ghost_pie_fix'] = _ghostPieFix;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profilePath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rowWithText(
          context,
          "World Preview Pause: ",
          sliderWithText(
            _wpPause,
            1,
            100,
            (value) {
              setState(
                () {
                  _wpPause = value.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
        rowWithText(
          context,
          "Idle Pause: ",
          sliderWithText(
            _idlePause,
            1,
            100,
            (value) {
              setState(
                () {
                  _idlePause = value.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
        rowWithText(
          context,
          "Unpause: ",
          sliderWithText(
            _unpause,
            1,
            100,
            (value) {
              setState(
                () {
                  _unpause = value.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
        rowWithText(
          context,
          "Stretch: ",
          sliderWithText(
            _stretch,
            1,
            100,
            (value) {
              setState(
                () {
                  _stretch = value.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
        rowWithText(
          context,
          "Ghost Pie Fix: ",
          sliderWithText(
            _ghostPieFix,
            1,
            100,
            (value) {
              setState(
                () {
                  _ghostPieFix = value.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
      ],
    );
  }
}
