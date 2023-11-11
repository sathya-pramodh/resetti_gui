import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:resetti_gui/conf/conf.dart';
import 'package:toml/toml.dart';
import 'package:resetti_gui/styles/text_style.dart';

class HotkeyPage extends StatefulWidget {
  final String resettiProfile;
  final Conf conf;
  const HotkeyPage(
      {super.key, required this.conf, required this.resettiProfile});

  @override
  State<HotkeyPage> createState() => _HotkeyPageState();
}

class _HotkeyPageState extends State<HotkeyPage> {
  final Map<String, String> _assignedKeybinds = {};
  int _wallPlayN = 1;
  int _wallLockN = 1;
  int _wallResetN = 1;
  final List<DropdownMenuEntry<int>> _wallPlayOpts = [];
  final List<DropdownMenuEntry<int>> _wallLockOpts = [];
  final List<DropdownMenuEntry<int>> _wallResetOpts = [];

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml")
        .toMap();
    profile['keybinds'].forEach(
      (keybind, options) {
        options.forEach(
          (option) => _assignedKeybinds[option] = keybind,
        );
      },
    );
    for (int i = 1; i <= widget.conf.instances.length; ++i) {
      _wallPlayOpts.add(DropdownMenuEntry<int>(value: i, label: "$i"));
      _wallLockOpts.add(DropdownMenuEntry<int>(value: i, label: "$i"));
      _wallResetOpts.add(DropdownMenuEntry<int>(value: i, label: "$i"));
    }
  }

  void profUpdate() {
    String profilePath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profilePath).toMap();
    Map<String, dynamic> newKeybinds = {};
    _assignedKeybinds.forEach(
      (option, keybind) {
        if (newKeybinds[keybind] == null) {
          newKeybinds[keybind] = [];
        }
        newKeybinds[keybind].add(option);
      },
    );
    profile['keybinds'] = newKeybinds;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profilePath).writeAsStringSync(updatedProfile);
  }

  List<Widget> _contents() {
    List<Widget> contents = [];
    Map<String, String> fields = {
      "Wall Reset All Keybind: ": "wall_reset_all",
      "Ingame Toggle Resolution Keybind: ": "ingame_toggle_res",
      "Ingame Focus Keybind: ": "ingame_focus",
      "Wall Focus Keybind: ": "wall_focus",
      "Wall Reset Keybind: ": "wall_reset",
      "Wall Play Keybind: ": "wall_play",
      "Wall Lock Keybind: ": "wall_play",
      "Wall Reset Others Keybind: ": "wall_reset_others",
      "Ingame Reset Keybind: ": "ingame_reset",
      "Wall Play First Locked Keybind: ": "wall_play_first_locked",
    };
    fields.forEach(
      (key, value) {
        contents.add(
          rowWithText(
            context,
            key,
            [
              textField(
                (_assignedKeybinds[value] != null)
                    ? _assignedKeybinds[value]
                    : "",
                (val) {
                  setState(
                    () {
                      _assignedKeybinds[value] = val;
                      profUpdate();
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
    return contents;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _contents() +
          [
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(
                  "Wall Play ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                DropdownMenu<int>(
                  textStyle: textStyle,
                  initialSelection: _wallPlayN,
                  onSelected: (value) => setState(() => _wallPlayN = value!),
                  dropdownMenuEntries: _wallPlayOpts,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                Text(
                  " Keybind: ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                textField(
                  (_assignedKeybinds['wall_play($_wallPlayN)'] != null)
                      ? _assignedKeybinds['wall_play($_wallPlayN)']
                      : "",
                  (value) {
                    setState(
                      () {
                        _assignedKeybinds['wall_play($_wallPlayN)'] = value;
                        profUpdate();
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(
                  "Wall Lock ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                DropdownMenu(
                  textStyle: textStyle,
                  initialSelection: _wallLockN,
                  onSelected: (value) => setState(() => _wallLockN = value!),
                  dropdownMenuEntries: _wallLockOpts,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                Text(
                  " Keybind: ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                textField(
                  (_assignedKeybinds['wall_lock($_wallPlayN)'] != null)
                      ? _assignedKeybinds['wall_lock($_wallPlayN)']
                      : "",
                  (value) {
                    setState(
                      () {
                        _assignedKeybinds['wall_lock($_wallPlayN)'] = value;
                        profUpdate();
                      },
                    );
                  },
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(
                  "Wall Reset ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                DropdownMenu(
                  textStyle: textStyle,
                  initialSelection: _wallResetN,
                  onSelected: (value) => setState(() => _wallResetN = value!),
                  dropdownMenuEntries: _wallLockOpts,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                Text(
                  " Keybind: ",
                  style: textStyle,
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.001),
                textField(
                  (_assignedKeybinds['wall_reset($_wallPlayN)'] != null)
                      ? _assignedKeybinds['wall_reset($_wallPlayN)']
                      : "",
                  (value) {
                    setState(
                      () {
                        _assignedKeybinds['wall_reset($_wallPlayN)'] = value;
                        profUpdate();
                      },
                    );
                  },
                ),
              ],
            ),
          ],
    );
  }
}
