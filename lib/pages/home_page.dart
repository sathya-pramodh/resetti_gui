import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/conf/conf.dart';
import 'package:resetti_gui/views/console.dart';
import 'package:resetti_gui/pages/settings_page.dart';
import 'package:tint/tint.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState();
  String _consoleOut = "";
  int _resettiPid = -1;
  dynamic _resettiStdin;
  late Conf conf;

  @override
  void initState() {
    super.initState();
    conf = Conf("${Platform.environment['HOME']!}/.config/resetti_gui/");
    _startProc(
      'echo',
      ['Started'],
    );
  }

  void _startProc(String exec, List<String> args, {bool? savePid}) {
    Process.start(
      exec,
      args,
      runInShell: true,
    ).then(
      (process) {
        if (savePid != null && savePid) {
          _resettiPid = process.pid;
          _resettiStdin = process.stdin;
        }

        process.stderr.transform(utf8.decoder).listen(
              (data) => setState(
                () {
                  if (data != "") {
                    _consoleOut += data.strip();
                  }
                },
              ),
            );
        process.stdout.transform(utf8.decoder).listen(
              (data) => setState(
                () {
                  _consoleOut += data.strip();
                },
              ),
            );
      },
    );
  }

  Widget _buttonWithText(String text,
      {void Function(dynamic)? onTap,
      List<PopupMenuEntry> Function(BuildContext)? itemBuilder}) {
    itemBuilder ??= (_) => [];
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      color: const Color.fromRGBO(95, 95, 95, 1),
      tooltip: null,
      onSelected: onTap,
      itemBuilder: itemBuilder,
      child: Container(
        width: 175,
        height: 35,
        padding: const EdgeInsets.only(
          top: 10,
        ),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(95, 95, 95, 1),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: Color.fromRGBO(201, 201, 201, 1),
          ),
          text,
        ),
      ),
    );
  }

  PopupMenuItem _popupMenu(String value, String text) {
    return PopupMenuItem(
      value: value,
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromRGBO(201, 201, 201, 1),
        ),
      ),
    );
  }

  void _redetectInstances() {
    ProcessResult process = Process.runSync(
      'command',
      ['xdotool', '--version'],
    );
    if (process.stdout == "" || process.stderr != "") {
      Navigator.of(context).pop();
      _startProc(
        'echo',
        [
          'Couldn\'t find "xdotool" installed. Please check if you have installed it!'
        ],
      );
    } else {
      Navigator.of(context).pop();
      List<String> workingDirs = [];
      dynamic windowIds = Process.runSync(
        'xdotool',
        [
          'search',
          '--name',
          'Minecraft\\*',
        ],
      ).stdout.split('\n');
      windowIds.forEach(
        (windowId) {
          if (windowId != '') {
            String windowPid = Process.runSync(
              'xdotool',
              [
                'getwindowpid',
                windowId,
              ],
            ).stdout;
            workingDirs.add(
              File(
                '/proc/${windowPid.trim()}/cwd',
              ).resolveSymbolicLinksSync(),
            );
          }
        },
      );
      List<String> instanceNames = [];
      workingDirs.forEach(
        (dir) {
          dir = dir.substring(0, dir.length - 11);
          String instCfg = File('$dir/instance.cfg').readAsStringSync();
          int idx = instCfg.split('=').indexWhere(
            (el) {
              return el == '[]\nname';
            },
          );
          String instName = instCfg
              .split('=')[idx + 1]
              .split('')
              .reversed
              .join()
              .substring(6)
              .split('')
              .reversed
              .join();
          instanceNames.add(instName);
          _startProc(
            'echo',
            [
              'Detected "$instName" and saved to list of instances.',
            ],
          );
        },
      );
      conf.write(
        'instances',
        instanceNames,
      );
      conf.write(
        'instance_dirs',
        workingDirs,
      );
      _startProc(
        'echo',
        [
          'Detected ${instanceNames.length} instances and saved to "${conf.path}conf.json"',
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.015625),
          ConsoleView(consoleOut: _consoleOut, stdin: _resettiStdin),
          SizedBox(width: MediaQuery.of(context).size.width * 0.046875),
          Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05555),
              _buttonWithText(
                "Instance Utilities...",
                onTap: (value) {
                  switch (value) {
                    case 'redetect':
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            insetPadding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.40277,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.40277,
                              left: MediaQuery.of(context).size.width * 0.24218,
                              right:
                                  MediaQuery.of(context).size.width * 0.24218,
                            ),
                            backgroundColor:
                                const Color.fromRGBO(95, 95, 95, 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                ),
                                const Text(
                                  "Are you sure you want to erase all data in profile and redetect all open Minecraft instances?",
                                  style: TextStyle(
                                    color: Color.fromRGBO(201, 201, 201, 1),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size.fromWidth(175),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromRGBO(95, 95, 95, 1),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromRGBO(
                                              201, 201, 201, 1),
                                        ),
                                      ),
                                      onPressed: () => _redetectInstances(),
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(201, 201, 201, 1),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size.fromWidth(175),
                                        ),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero,
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromRGBO(95, 95, 95, 1),
                                        ),
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                          const Color.fromRGBO(
                                              201, 201, 201, 1),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(201, 201, 201, 1),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                      break;
                    case 'launch':
                      if (conf.instances.isEmpty) {
                        _startProc(
                          'echo',
                          [
                            'No instances saved in profile. Check to see if you have instances detected yet.'
                          ],
                        );
                      } else {
                        conf.instances.forEach(
                          (instance) {
                            _startProc(
                              conf.multimcPath,
                              [
                                '-l',
                                '$instance',
                              ],
                            );
                            _startProc(
                              'echo',
                              ['Starting Instance "$instance".'],
                            );
                          },
                        );
                      }
                      break;

                    case 'kill':
                      _startProc(
                        'pkill',
                        [
                          'java',
                        ],
                      );
                      break;
                    case 'warmup':
                      if (conf.benchPath == "None" || conf.benchPath == "") {
                        _startProc(
                          'echo',
                          [
                            'Bench path not set. Make sure to set it in options.'
                          ],
                        );
                      } else {
                        _startProc(
                          conf.benchPath,
                          [
                            '-reset-count',
                            '${conf.benchCount}',
                          ],
                        );
                      }
                  }
                },
                itemBuilder: (context) {
                  return [
                    _popupMenu('redetect', 'Redetect Instances'),
                    _popupMenu('launch', 'Launch Instances'),
                    _popupMenu('kill', 'Kill Instances'),
                    _popupMenu('warmup', 'Warmup Instances (requires bench).')
                  ];
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00972),
              _buttonWithText(
                "File Utilities...",
                onTap: (value) {
                  switch (value) {
                    case 'clear':
                      if (conf.instanceDirs.isEmpty) {
                        _startProc(
                          'echo',
                          [
                            "Couldn't find any instances in conf.json. Make sure to redetect them."
                          ],
                        );
                        break;
                      }
                      conf.instanceDirs.forEach(
                        (dir) {
                          ProcessResult process = Process.runSync(
                            'ls',
                            ["$dir/saves/"],
                          );
                          if (process.stderr != "") {
                            _startProc('echo', ['Error: $process.stderr']);
                            return;
                          }
                          List<String> result = process.stdout.split('\n');
                          result.forEach(
                            (world) {
                              if (world.contains('Random') ||
                                  world.contains('Set')) {
                                Directory("$dir/saves/$world")
                                    .deleteSync(recursive: true);
                              }
                            },
                          );
                          _startProc('echo', ['Cleared worlds in $dir/saves']);
                        },
                      );
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    _popupMenu('clear', 'Clear Worlds'),
                  ];
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00972),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size.fromWidth(175),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(95, 95, 95, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(201, 201, 201, 1),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (context) => SettingsPage(conf: conf),
                        ),
                      )
                      .then((_) => conf.update());
                },
                child: const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  "Options...",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00972),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size.fromWidth(175),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(95, 95, 95, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(201, 201, 201, 1),
                  ),
                ),
                onPressed: () {
                  if (_resettiPid != -1) {
                    Process.runSync(
                      'kill',
                      ['$_resettiPid'],
                    );
                  }
                  _startProc(
                    conf.resettiPath,
                    [conf.resettiProfile],
                    savePid: true,
                  );
                },
                child: const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  "Start resetti",
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.00972),
              ElevatedButton(
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size.fromWidth(175),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(95, 95, 95, 1),
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromRGBO(201, 201, 201, 1),
                  ),
                ),
                onPressed: () {
                  if (_resettiPid != -1) {
                    Process.runSync(
                      'kill',
                      ['$_resettiPid'],
                    );
                  }
                },
                child: const Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                  ),
                  "Kill resetti",
                ),
              )
            ],
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.00234),
        ],
      ),
    );
  }
}
