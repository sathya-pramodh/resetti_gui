import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/file_picker.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:resetti_gui/conf/conf.dart';
import 'package:resetti_gui/styles/text_style.dart';
import 'package:resetti_gui/styles/button_style.dart';

class ProfilePage extends StatefulWidget {
  final Conf conf;
  const ProfilePage({super.key, required this.conf});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> _resettiProfiles = [];

  String _resettiProfileSelected = "";
  String _resettiArgs = "";
  String _resettiPathPicked = "";
  String _benchPathPicked = "";
  String _multimcPathPicked = "";
  String _benchArgs = "";
  bool _validProfile = true;
  int _benchCount = 0;

  void confUpdate() {
    widget.conf.write('resetti_profile', _resettiProfileSelected);
    widget.conf.write('resetti_path', _resettiPathPicked);
    widget.conf.write('resetti_args', _resettiArgs);
    widget.conf.write('multimc_path', _multimcPathPicked);
    widget.conf.write('bench_path', _benchPathPicked);
    widget.conf.write('bench_count', _benchCount);
    widget.conf.write('bench_args', _benchArgs);
  }

  @override
  void initState() {
    super.initState();
    String profDir = "${Platform.environment['HOME']!}/.config/resetti/";
    if (!Directory(profDir).existsSync()) {
      Process.runSync('mkdir', ['-p', profDir]);
      Process.runSync(
        'cp',
        [
          '${Platform.environment['HOME']!}/.local/share/resetti/default.toml',
          profDir,
        ],
      );
    }
    _resettiProfiles = Process.runSync(
      'ls',
      [profDir],
    ).stdout.trim().split('\n');
    _resettiProfiles = _resettiProfiles.map(
      (profile) {
        if (profile.contains('.toml')) {
          return profile.replaceAll(".toml", "");
        }
        return "";
      },
    ).toList();
    _resettiProfiles.removeWhere((el) => el == '');
    if (widget.conf.resettiProfile == "") {
      widget.conf.write(
        'resetti_profile',
        _resettiProfiles[0],
      );
      _resettiProfileSelected = _resettiProfiles.first;
    } else {
      _resettiProfileSelected = widget.conf.resettiProfile;
    }
    _resettiPathPicked = widget.conf.resettiPath;
    _resettiArgs = widget.conf.resettiArgs;
    _multimcPathPicked = widget.conf.multimcPath;
    _benchPathPicked = widget.conf.benchPath;
    _benchCount = widget.conf.benchCount;
    _benchArgs = widget.conf.benchArgs;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController profileController =
        TextEditingController(text: 'default');
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        rowWithText(
          context,
          "Resetti Path: ",
          filePicker(
            context,
            _resettiPathPicked,
            (result) => setState(
              () {
                if (result != null) {
                  _resettiPathPicked = result.files.single.path!;
                }
                confUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Resetti Args: ",
          [
            textField(
              _resettiArgs,
              (result) => setState(
                () {
                  _resettiArgs = result;
                  confUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Bench Path: ",
          filePicker(
            context,
            _benchPathPicked,
            (result) => setState(
              () {
                if (result != null) {
                  _benchPathPicked = result.files.single.path!;
                  confUpdate();
                }
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Bench Args: ",
          [
            textField(
              _benchArgs,
              (result) => setState(
                () {
                  _benchArgs = result;
                  confUpdate();
                },
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Bench Reset Count: ",
          sliderWithText(
            _benchCount,
            100,
            2000,
            (value) => setState(
              () {
                _benchCount = value.toInt();
                confUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "MultiMC Path: ",
          filePicker(
            context,
            _multimcPathPicked,
            (result) {
              setState(
                () {
                  if (result != null) {
                    _multimcPathPicked = result.files.single.path!;
                  }
                  confUpdate();
                },
              );
            },
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Resetti Profile: ",
          [
            SizedBox(
              child: DropdownMenu<String>(
                textStyle: textStyle,
                initialSelection: _resettiProfileSelected,
                onSelected: (String? value) {
                  setState(
                    () {
                      _resettiProfileSelected = value!;
                      confUpdate();
                    },
                  );
                },
                dropdownMenuEntries: _resettiProfiles
                    .map<DropdownMenuEntry<String>>(
                      (profile) =>
                          DropdownMenuEntry(value: profile, label: profile),
                    )
                    .toList(),
              ),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "",
          [
            ElevatedButton(
              style: buttonStyle,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    insetPadding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.40277,
                      bottom: MediaQuery.of(context).size.height * 0.40277,
                      left: MediaQuery.of(context).size.width * 0.24218,
                      right: MediaQuery.of(context).size.width * 0.24218,
                    ),
                    backgroundColor: const Color.fromRGBO(95, 95, 95, 1),
                    child: Column(
                      children: [
                        Text(style: textStyle, "New Profile Name: "),
                        TextField(
                          textAlign: TextAlign.center,
                          style: textStyle,
                          controller: profileController,
                          onSubmitted: (value) {
                            Navigator.of(context).pop();
                            if (_resettiProfiles.contains(value)) {
                              setState(() => _validProfile = false);
                              return;
                            }
                            String profDir =
                                '${Platform.environment['HOME']!}/.config/resetti';
                            String defaultPath =
                                '${Platform.environment['HOME']!}/.local/share/resetti/default.toml';
                            Process.runSync(
                              'cp',
                              [defaultPath, '$profDir/$value.toml'],
                            );
                            setState(
                              () {
                                _resettiProfiles.add(value);
                                _resettiProfileSelected = value;
                                _validProfile = true;
                                confUpdate();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(style: textStyle, "New Profile"),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.01),
            ElevatedButton(
              style: buttonStyle,
              onPressed: () => setState(
                () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      insetPadding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.40277,
                        bottom: MediaQuery.of(context).size.height * 0.40277,
                        left: MediaQuery.of(context).size.width * 0.24218,
                        right: MediaQuery.of(context).size.width * 0.24218,
                      ),
                      backgroundColor: const Color.fromRGBO(95, 95, 95, 1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_sharp,
                            color: Color.fromRGBO(201, 201, 201, 1),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Text(
                            style: textStyle,
                            "Are you sure you want to delete '$_resettiProfileSelected'?",
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.01),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: buttonStyle,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(
                                    () {
                                      File('${Platform.environment['HOME']!}/.config/resetti/$_resettiProfileSelected.toml')
                                          .deleteSync();
                                      _resettiProfiles
                                          .remove(_resettiProfileSelected);
                                      _resettiProfileSelected =
                                          _resettiProfiles.first;
                                      confUpdate();
                                    },
                                  );
                                },
                                child: Text(style: textStyle, "Yes"),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01),
                              ElevatedButton(
                                style: buttonStyle,
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(style: textStyle, "No"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              child: Text(style: textStyle, "Delete Profile"),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
            context, (_validProfile) ? "" : "Profile Already Exists!", []),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }
}
