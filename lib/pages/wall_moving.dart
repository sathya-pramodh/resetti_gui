import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/bool_button.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:resetti_gui/styles/text_style.dart';
import 'package:resetti_gui/styles/button_style.dart';
import 'package:toml/toml.dart';

class WallMoving extends StatefulWidget {
  final String resettiProfile;
  const WallMoving({super.key, required this.resettiProfile});

  @override
  State<WallMoving> createState() => _WallMovingState();
}

class _WallMovingState extends State<WallMoving> {
  bool _movingEnabled = false;
  bool _useGaps = false;
  bool _forceResetBeforePlay = false;
  int _currentGroup = 0;
  List<Map<String, dynamic>> _movingGroups = [];
  Map<String, dynamic> _movingLock = {};

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml")
        .toMap();
    _movingEnabled = profile['wall']['moving']['enabled'];
    _useGaps = profile['wall']['moving']['use_gaps'];
    _forceResetBeforePlay =
        profile['wall']['moving']['force_reset_before_play'];
    _movingGroups = profile['wall']['moving']['groups'];
    _movingLock = profile['wall']['moving']['locks'];
    _currentGroup = 1;
  }

  void profUpdate() {
    String profPath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['wall']['moving']['enabled'] = _movingEnabled;
    profile['wall']['moving']['use_gaps'] = _useGaps;
    profile['wall']['moving']['groups'] = _movingGroups;
    profile['wall']['moving']['locks'] = _movingLock;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Moving Enabled: ",
                  [
                    boolButton(
                      _movingEnabled,
                      () => setState(
                        () {
                          _movingEnabled = !_movingEnabled;
                          profUpdate();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Force Reset Before Play: ",
                  [
                    boolButton(
                      _forceResetBeforePlay,
                      () => setState(
                        () {
                          _forceResetBeforePlay = !_forceResetBeforePlay;
                          profUpdate();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Use Gaps: ",
                  [
                    boolButton(
                      _useGaps,
                      () => setState(
                        () {
                          _useGaps = !_useGaps;
                          profUpdate();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.2),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                rowWithText(
                  context,
                  "Group: ",
                  [
                    DropdownMenu<int>(
                      textStyle: textStyle,
                      initialSelection: _currentGroup,
                      onSelected: (value) => setState(
                        () => _currentGroup = value!,
                      ),
                      dropdownMenuEntries: () {
                        List<DropdownMenuEntry<int>> entries = [];
                        for (int idx = 1; idx <= _movingGroups.length; ++idx) {
                          entries.add(
                            DropdownMenuEntry(
                              label: "$idx",
                              value: idx,
                            ),
                          );
                        }
                        return entries;
                      }(),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Position: ",
                  [
                    textField(
                      _movingGroups[_currentGroup - 1]['position'],
                      (value) {
                        setState(
                          () {
                            _movingGroups[_currentGroup - 1]['position'] =
                                value;
                            profUpdate();
                          },
                        );
                      },
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Width: ",
                  sliderWithText(
                    _movingGroups[_currentGroup - 1]['width'],
                    1,
                    50,
                    (value) {
                      setState(
                        () {
                          _movingGroups[_currentGroup - 1]['width'] =
                              value.toInt();
                        },
                      );
                      profUpdate();
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Height: ",
                  sliderWithText(
                    _movingGroups[_currentGroup - 1]['height'],
                    1,
                    50,
                    (value) {
                      setState(
                        () {
                          _movingGroups[_currentGroup - 1]['height'] =
                              value.toInt();
                        },
                      );
                      profUpdate();
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                rowWithText(
                  context,
                  "Cosmetic: ",
                  [
                    boolButton(
                      (_movingGroups[_currentGroup - 1]['cosmetic'] != null)
                          ? _movingGroups[_currentGroup - 1]['cosmetic']
                          : false,
                      () => setState(
                        () {
                          _movingGroups[_currentGroup - 1]['cosmetic'] =
                              (_movingGroups[_currentGroup - 1]['cosmetic'] !=
                                      null)
                                  ? !_movingGroups[_currentGroup - 1]
                                      ['cosmetic']
                                  : true;
                          profUpdate();
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    ElevatedButton(
                      onPressed: () => setState(
                        () {
                          _movingGroups.add(
                            {
                              "position": "1920x1080+0,0",
                              "width": 1,
                              "height": 1,
                              "cosmetic": true
                            },
                          );
                          _currentGroup = _movingGroups.length;
                          profUpdate();
                        },
                      ),
                      style: buttonStyle,
                      child: Text(style: textStyle, "Add Group"),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    ElevatedButton(
                      onPressed: () => setState(
                        () {
                          _movingGroups.removeAt(_currentGroup - 1);
                          _currentGroup =
                              (_currentGroup - 1 > 0) ? _currentGroup - 1 : 1;
                          profUpdate();
                        },
                      ),
                      style: buttonStyle,
                      child: Text(style: textStyle, "Remove Group"),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text(style: textStyle, "Lock: "),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            rowWithText(
              context,
              "Position: ",
              [
                textField(
                  _movingLock['position'],
                  (value) {
                    setState(
                      () {
                        _movingLock['position'] = value;
                        profUpdate();
                      },
                    );
                  },
                )
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            rowWithText(
              context,
              "Width: ",
              sliderWithText(
                _movingLock['width'],
                1,
                50,
                (value) {
                  setState(
                    () {
                      _movingLock['width'] = value.toInt();
                    },
                  );
                  profUpdate();
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            rowWithText(
              context,
              "Height: ",
              sliderWithText(
                _movingLock['height'],
                1,
                50,
                (value) {
                  setState(
                    () {
                      _movingLock['height'] = value.toInt();
                    },
                  );
                  profUpdate();
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
