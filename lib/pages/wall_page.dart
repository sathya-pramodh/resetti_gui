import 'package:flutter/material.dart';
import 'package:resetti_gui/pages/wall_general.dart';
import 'package:resetti_gui/pages/wall_moving.dart';
import 'package:resetti_gui/pages/wall_performance.dart';

class WallPage extends StatefulWidget {
  final String resettiProfile;
  const WallPage({super.key, required this.resettiProfile});

  @override
  State<WallPage> createState() => _WallPageState();
}

class _WallPageState extends State<WallPage> {
  String _currentPage = "General";

  Widget _contents() {
    switch (_currentPage) {
      case "General":
        return WallGeneral(resettiProfile: widget.resettiProfile);
      case "Moving":
        return WallMoving(resettiProfile: widget.resettiProfile);
      case "Performance":
        return WallPerformance(resettiProfile: widget.resettiProfile);
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
      onPressed: onPressed,
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
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton(
              "General",
              () => setState(() => _currentPage = "General"),
            ),
            _navButton(
              "Moving",
              () => setState(() => _currentPage = "Moving"),
            ),
            _navButton(
              "Performance",
              () => setState(() => _currentPage = "Performance"),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        _contents(),
      ],
    );
  }
}
