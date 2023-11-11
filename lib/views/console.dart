import 'package:flutter/material.dart';

class ConsoleView extends StatefulWidget {
  String consoleOut;
  final dynamic stdin;
  ConsoleView({super.key, required this.consoleOut, required this.stdin});

  @override
  State<ConsoleView> createState() => ConsoleViewState();
}

class ConsoleViewState extends State<ConsoleView> {
  ConsoleViewState();
  ScrollController scrollController = ScrollController();
  TextEditingController controller = TextEditingController();

  @override
  void didUpdateWidget(covariant ConsoleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.78,
          height: MediaQuery.of(context).size.height * 0.90,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(95, 95, 95, 0.4),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Text(
                widget.consoleOut,
                style: const TextStyle(
                  color: Color.fromRGBO(201, 201, 201, 1),
                ),
              ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(95, 95, 95, 0.4),
            border: Border.all(
              color: const Color.fromRGBO(105, 105, 105, 1),
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.78,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintStyle: TextStyle(
                color: Color.fromRGBO(201, 201, 201, 0.8),
              ),
              hintText: "Enter relevant inputs here: ",
            ),
            onSubmitted: (value) {
              if (widget.stdin != null) {
                widget.stdin.writeln(value);
              } else {
                setState(() => widget.consoleOut +=
                    "Couldn't find a relevance of input.\n");
              }
              controller.text = "";
            },
            style: const TextStyle(
              color: Color.fromRGBO(201, 201, 201, 1),
            ),
          ),
        ),
      ],
    );
  }
}
