import 'package:flutter/material.dart';
import 'package:resetti_gui/conf/conf.dart';
import 'package:resetti_gui/pages/basic_page.dart';
import 'package:resetti_gui/pages/delays_page.dart';
import 'package:resetti_gui/pages/hooks_page.dart';
import 'package:resetti_gui/pages/hotkeys_page.dart';
import 'package:resetti_gui/pages/obs_page.dart';
import 'package:resetti_gui/pages/profile_page.dart';
import 'package:resetti_gui/pages/wall_page.dart';

class SettingsPage extends StatefulWidget {
  final Conf conf;
  const SettingsPage({super.key, required this.conf});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _currentPage = "Profile";

  @override
  void initState() {
    super.initState();
    widget.conf.update();
  }

  Widget _contents() {
    switch (_currentPage) {
      case 'Profile':
        return ProfilePage(conf: widget.conf);
      case 'Basic':
        return BasicPage(resettiProfile: widget.conf.resettiProfile);
      case 'Delays':
        return DelayPage(resettiProfile: widget.conf.resettiProfile);
      case 'Hooks':
        return HookPage(resettiProfile: widget.conf.resettiProfile);
      case 'Keybinds':
        return HotkeyPage(
          conf: widget.conf,
          resettiProfile: widget.conf.resettiProfile,
        );
      case 'Obs':
        return ObsPage(resettiProfile: widget.conf.resettiProfile);
      case 'Wall':
        return WallPage(resettiProfile: widget.conf.resettiProfile);
      default:
        return const CircularProgressIndicator();
    }
  }

  Widget _navButton(String text, void Function() onPressed) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          (_currentPage == text)
              ? Colors.blueAccent
              : const Color.fromRGBO(95, 95, 95, 1),
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          const Size.fromWidth(125),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          const Color.fromRGBO(201, 201, 201, 1),
        ),
      ),
      onPressed: () {
        widget.conf.update();
        onPressed();
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navButton(
                "Back",
                () => Navigator.of(context).pop(),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width * 0.001,
              ),
              _navButton(
                "Profile",
                () => setState(() => _currentPage = "Profile"),
              ),
              _navButton(
                "Basic",
                () => setState(() => _currentPage = "Basic"),
              ),
              _navButton(
                "Delays",
                () => setState(() => _currentPage = "Delays"),
              ),
              _navButton(
                "Hooks",
                () => setState(() => _currentPage = "Hooks"),
              ),
              _navButton(
                "Keybinds",
                () => setState(() => _currentPage = "Keybinds"),
              ),
              _navButton(
                "Obs",
                () => setState(() => _currentPage = "Obs"),
              ),
              _navButton(
                "Wall",
                () => setState(() => _currentPage = "Wall"),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height * 0.0001,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          _contents(),
        ],
      ),
    );
  }
}
