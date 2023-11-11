import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:toml/toml.dart';

class HookPage extends StatefulWidget {
  final String resettiProfile;
  const HookPage({super.key, required this.resettiProfile});

  @override
  State<HookPage> createState() => _HookPageState();
}

class _HookPageState extends State<HookPage> {
  String _resetHook = "";
  String _altResHook = "";
  String _normalResHook = "";
  String _wallUnlockHook = "";
  String _wallLockHook = "";
  String _wallPlayHook = "";
  String _wallResetHook = "";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml")
        .toMap();

    _resetHook = profile['hooks']['reset'];
    _altResHook = profile['hooks']['alt_res'];
    _normalResHook = profile['hooks']['normal_res'];
    _wallLockHook = profile['hooks']['wall_lock'];
    _wallUnlockHook = profile['hooks']['wall_unlock'];
    _wallPlayHook = profile['hooks']['wall_play'];
    _wallResetHook = profile['hooks']['wall_reset'];
  }

  void profUpdate() {
    String profPath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['hooks']['reset'] = _resetHook;
    profile['hooks']['alt_res'] = _altResHook;
    profile['hooks']['normal_res'] = _normalResHook;
    profile['hooks']['wall_lock'] = _wallLockHook;
    profile['hooks']['wall_unlock'] = _wallUnlockHook;
    profile['hooks']['wall_play'] = _wallPlayHook;
    profile['hooks']['wall_reset'] = _wallResetHook;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        rowWithText(
          context,
          "Reset Hook: ",
          [
            textField(
              _resetHook,
              (res) => setState(
                () {
                  _resetHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Alternate Resolution Hook: ",
          [
            textField(
              _altResHook,
              (res) => setState(
                () {
                  _altResHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Normal Resolution Hook: ",
          [
            textField(
              _normalResHook,
              (res) => setState(
                () {
                  _normalResHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Wall Lock Hook: ",
          [
            textField(
              _wallLockHook,
              (res) => setState(
                () {
                  _wallLockHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Wall Unlock Hook: ",
          [
            textField(
              _wallUnlockHook,
              (res) => setState(
                () {
                  _wallUnlockHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Wall Play Hook: ",
          [
            textField(
              _wallPlayHook,
              (res) => setState(
                () {
                  _wallPlayHook = res;
                  profUpdate();
                },
              ),
            ),
          ],
        ),
        rowWithText(
          context,
          "Wall Reset Hook: ",
          [
            textField(
              _wallResetHook,
              (res) => setState(
                () {
                  _wallResetHook = res;
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
