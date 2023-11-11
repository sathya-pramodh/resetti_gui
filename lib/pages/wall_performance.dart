import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/components/row_with_text.dart';
import 'package:resetti_gui/components/slider_with_text.dart';
import 'package:resetti_gui/components/text_field.dart';
import 'package:toml/toml.dart';
import 'package:resetti_gui/styles/button_style.dart';
import 'package:resetti_gui/styles/text_style.dart';

class WallPerformance extends StatefulWidget {
  final String resettiProfile;
  const WallPerformance({super.key, required this.resettiProfile});

  @override
  State<WallPerformance> createState() => _WallPerformanceState();
}

class _WallPerformanceState extends State<WallPerformance> {
  String _sleepbgPath = "";
  String _affinity = "";
  double _maxCpus = 0;
  int _sequenceActiveCpus = 0;
  int _sequenceBackgroundCpus = 0;
  int _sequenceLockCpus = 0;
  int _advancedCcxSplit = 0;
  int _advancedAffinityIdle = 0;
  int _advancedAffinityLow = 0;
  int _advancedAffinityMid = 0;
  int _advancedAffinityHigh = 0;
  int _advancedAffinityActive = 0;
  int _advancedBurstLength = 0;
  int _advancedLowThreshold = 0;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> profile = TomlDocument.loadSync(
            "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml")
        .toMap();
    _sleepbgPath = profile['wall']['performance']['sleepbg_path'];
    _affinity = profile['wall']['performance']['affinity'];
    _sequenceActiveCpus =
        profile['wall']['performance']['sequence']['active_cpus'];
    _sequenceBackgroundCpus =
        profile['wall']['performance']['sequence']['background_cpus'];
    _sequenceLockCpus = profile['wall']['performance']['sequence']['lock_cpus'];
    _advancedCcxSplit = profile['wall']['performance']['advanced']['ccx_split'];
    _advancedAffinityIdle =
        profile['wall']['performance']['advanced']['affinity_idle'];
    _advancedAffinityLow =
        profile['wall']['performance']['advanced']['affinity_low'];
    _advancedAffinityMid =
        profile['wall']['performance']['advanced']['affinity_mid'];
    _advancedAffinityHigh =
        profile['wall']['performance']['advanced']['affinity_high'];
    _advancedAffinityActive =
        profile['wall']['performance']['advanced']['affinity_active'];
    _advancedBurstLength =
        profile['wall']['performance']['advanced']['burst_length'];
    _advancedLowThreshold =
        profile['wall']['performance']['advanced']['low_threshold'];
    _maxCpus = double.parse(Process.runSync('nproc', []).stdout);
  }

  void profUpdate() {
    String profPath =
        "${Platform.environment['HOME']!}/.config/resetti/${widget.resettiProfile}.toml";
    Map<String, dynamic> profile = TomlDocument.loadSync(profPath).toMap();
    profile['wall']['performance']['sleepbg_path'] = _sleepbgPath;
    profile['wall']['performance']['affinity'] = _affinity;
    profile['wall']['performance']['sequence']['active_cpus'] =
        _sequenceActiveCpus;
    profile['wall']['performance']['sequence']['background_cpus'] =
        _sequenceBackgroundCpus;
    profile['wall']['performance']['sequence']['lock_cpus'] = _sequenceLockCpus;
    profile['wall']['performance']['advanced']['ccx_split'] = _advancedCcxSplit;
    profile['wall']['performance']['advanced']['affinity_idle'] =
        _advancedAffinityIdle;
    profile['wall']['performance']['advanced']['affinity_mid'] =
        _advancedAffinityMid;
    profile['wall']['performance']['advanced']['affinity_high'] =
        _advancedAffinityHigh;
    profile['wall']['performance']['advanced']['affinity_active'] =
        _advancedAffinityActive;
    profile['wall']['performance']['advanced']['burst_length'] =
        _advancedBurstLength;
    profile['wall']['performance']['advanced']['low_threshold'] =
        _advancedLowThreshold;
    String updatedProfile = TomlDocument.fromMap(profile).toString();
    File(profPath).writeAsStringSync(updatedProfile);
  }

  List<Widget> _affinitySettings() {
    if (_affinity == "sequence") {
      return [
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        rowWithText(
          context,
          "Sequence",
          [],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Active CPUs: ",
          sliderWithText(
            _sequenceActiveCpus,
            1,
            _maxCpus.toDouble(),
            (value) => setState(
              () {
                _sequenceActiveCpus = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Background CPUs: ",
          sliderWithText(
            _sequenceBackgroundCpus,
            1,
            _maxCpus.toDouble(),
            (value) => setState(
              () {
                _sequenceBackgroundCpus = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Lock CPUs: ",
          sliderWithText(
            _sequenceLockCpus,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _sequenceLockCpus = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        )
      ];
    } else {
      return [
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        rowWithText(
          context,
          "Advanced",
          [],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "CCX Split: ",
          sliderWithText(
            _advancedCcxSplit,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedCcxSplit = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Affinity Idle: ",
          sliderWithText(
            _advancedAffinityIdle,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedAffinityIdle = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Affinity Low: ",
          sliderWithText(
            _advancedAffinityLow,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedAffinityLow = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Affinity Mid: ",
          sliderWithText(
            _advancedAffinityMid,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedAffinityMid = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Affinity High: ",
          sliderWithText(
            _advancedAffinityHigh,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedAffinityHigh = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Affinity Active: ",
          sliderWithText(
            _advancedAffinityActive,
            1,
            _maxCpus,
            (value) => setState(
              () {
                _advancedAffinityActive = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Burst Length: ",
          sliderWithText(
            _advancedBurstLength,
            0,
            10000,
            (value) => setState(
              () {
                _advancedBurstLength = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        rowWithText(
          context,
          "Low Threshold: ",
          sliderWithText(
            _advancedLowThreshold,
            0,
            100,
            (value) => setState(
              () {
                _advancedLowThreshold = value.round().toInt();
                profUpdate();
              },
            ),
          ),
        )
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            rowWithText(
              context,
              "SleepBG Path: ",
              [
                textField(
                  _sleepbgPath,
                  (value) => setState(
                    () {
                      _sleepbgPath = value;
                      profUpdate();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            rowWithText(
              context,
              "Affinity: ",
              [
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () => setState(
                    () {
                      _affinity =
                          (_affinity == "sequence") ? "advanced" : "sequence";
                      profUpdate();
                    },
                  ),
                  child: Text(
                    style: textStyle,
                    _affinity,
                  ),
                )
              ],
            ),
          ] +
          _affinitySettings(),
    );
  }
}
