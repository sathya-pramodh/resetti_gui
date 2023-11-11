import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/bool_button.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:toml/toml.dart';

class ObsPage extends StatefulWidget {
  final String resettiProfile;
  const ObsPage({super.key, required this.resettiProfile});

  @override
  State<ObsPage> createState() => _ObsPageState();
}

class _ObsPageState extends State<ObsPage> {
  bool _obsEnabled = false;
  int _obsPort = -1;
  String _obsPassword = "";
  int _obsPort2 = -1;
  String _obsPassword2 = "";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            '${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml')
        .toMap();
    _obsEnabled = profile['obs']['enabled'];
    _obsPort = profile['obs']['port'];
    _obsPassword = profile['obs']['password'];
    _obsPort2 = profile['obs']['port_2'];
    _obsPassword2 = profile['obs']['password_2'];
  }

  void profUpdate() {
    String profPath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['obs']['enabled'] = _obsEnabled;
    profile['obs']['port'] = _obsPort;
    profile['obs']['password'] = _obsPassword;
    profile['obs']['port_2'] = _obsPort2;
    profile['obs']['password_2'] = _obsPassword2;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rowWithText(
          context,
          "OBS Enabled: ",
          [
            boolButton(
              _obsEnabled,
              () => setState(
                () {
                  _obsEnabled = !_obsEnabled;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        rowWithText(
          context,
          "OBS Port: ",
          [
            textField(
              _obsPort,
              (value) => setState(
                () {
                  _obsPort = int.parse(value);
                  profUpdate();
                },
              ),
            )
          ],
        ),
        rowWithText(
          context,
          "OBS Password: ",
          [
            textField(
              _obsPassword,
              (value) => setState(
                () {
                  _obsPassword = value;
                  profUpdate();
                },
              ),
              obscureText: true,
            )
          ],
        ),
        rowWithText(
          context,
          "OBS Port 2: ",
          [
            textField(
              _obsPort2,
              (value) => setState(
                () {
                  _obsPort2 = int.parse(value);
                  profUpdate();
                },
              ),
            )
          ],
        ),
        rowWithText(
          context,
          "OBS Password 2: ",
          [
            textField(
              _obsPassword2,
              (value) => setState(
                () {
                  _obsPassword2 = value;
                  profUpdate();
                },
              ),
              obscureText: true,
            )
          ],
        ),
      ],
    );
  }
}
