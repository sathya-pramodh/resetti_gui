import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/bool_button.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:toml/toml.dart';

class WallGeneral extends StatefulWidget {
  final String resettiProfile;
  const WallGeneral({super.key, required this.resettiProfile});

  @override
  State<WallGeneral> createState() => _WallGeneralState();
}

class _WallGeneralState extends State<WallGeneral> {
  bool _wallEnabled = false;
  bool _confinePointer = false;
  bool _gotoLocked = false;
  bool _resetUnlock = false;
  int _gracePeriod = 0;
  String _stretchRes = "";
  bool _useF1 = false;
  int _freezeAt = 0;
  int _showAt = 0;
  String _wallWindow = "";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml")
        .toMap();
    _wallEnabled = profile['wall']['enabled'];
    _confinePointer = profile['wall']['confine_pointer'];
    _gotoLocked = profile['wall']['goto_locked'];
    _resetUnlock = profile['wall']['reset_unlock'];
    _gracePeriod = profile['wall']['grace_period'];
    _stretchRes = profile['wall']['stretch_res'];
    _useF1 = profile['wall']['use_f1'];
    _freezeAt = profile['wall']['freeze_at'];
    _showAt = profile['wall']['show_at'];
    _wallWindow = profile['wall']['wall_window'];
  }

  void profUpdate() {
    String profPath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['wall']['enabled'] = _wallEnabled;
    profile['wall']['confine_pointer'] = _confinePointer;
    profile['wall']['goto_locked'] = _gotoLocked;
    profile['wall']['reset_unlock'] = _resetUnlock;
    profile['wall']['grace_period'] = _gracePeriod;
    profile['wall']['stretch_res'] = _stretchRes;
    profile['wall']['use_f1'] = _useF1;
    profile['wall']['freeze_at'] = _freezeAt;
    profile['wall']['show_at'] = _showAt;
    profile['wall']['wall_window'] = _wallWindow;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Wall Enabled: ",
          [
            boolButton(
              _wallEnabled,
              () => setState(
                () {
                  _wallEnabled = !_wallEnabled;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Confine Pointer: ",
          [
            boolButton(
              _confinePointer,
              () => setState(
                () {
                  _confinePointer = !_confinePointer;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Goto Locked: ",
          [
            boolButton(
              _gotoLocked,
              () => setState(
                () {
                  _gotoLocked = !_gotoLocked;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Reset Unlock: ",
          [
            boolButton(
              _resetUnlock,
              () => setState(
                () {
                  _resetUnlock = !_resetUnlock;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Grace Period: ",
          sliderWithText(
            _gracePeriod,
            100,
            5000,
            (rate) {
              setState(
                () {
                  _gracePeriod = rate.toInt();
                },
              );
              profUpdate();
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Stretch Resolution: ",
          [
            textField(
              _stretchRes,
              (value) => setState(
                () {
                  _stretchRes = value;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Use F1: ",
          [
            boolButton(
              _useF1,
              () => setState(
                () {
                  _useF1 = !_useF1;
                  profUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Freeze At: ",
          sliderWithText(
            _freezeAt,
            -100,
            100,
            (value) => setState(
              () {
                _freezeAt = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Show At: ",
          sliderWithText(
            _showAt,
            -100,
            100,
            (value) => setState(
              () {
                _showAt = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Wall Window: ",
          [
            textField(
              _wallWindow,
              (value) => setState(
                () {
                  _wallWindow = value;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
