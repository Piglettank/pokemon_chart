import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class Position {
  int x, y;
  Position(this.x, this.y);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Position> highlights = [];
  int selectedRow = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .only(top: 20, left: 20, right: 10, bottom: 10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 80),
                    for (final type in Types.values)
                      Expanded(child: TopRowType(type)),
                  ],
                ),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constrains) {
                      return Row(
                        children: [
                          SizedBox(
                            height: constrains.maxHeight,
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                for (final type in Types.values)
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 80,
                                          padding: .only(left: 8),
                                          decoration: BoxDecoration(
                                            color: type.color,
                                            border: Border(
                                              top: _borderSide(),
                                              right: _borderSide(),
                                            ),
                                          ),
                                          child: Align(
                                            alignment: .centerLeft,
                                            child: OutlinedText(
                                              type.name.capitalize,
                                            ),
                                          ),
                                        ),
                                        if (selectedRow != 0 &&
                                            selectedRow != type.index)
                                          Container(
                                            width: 80,
                                            color: Colors.black54,
                                          ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: constrains.maxHeight,
                              child: Column(
                                children: [
                                  for (final attack in Types.values)
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: _borderSide(),
                                            right: _borderSide(),
                                          ),
                                          color: attack.color.withAlpha(40),
                                        ),

                                        child: GestureDetector(
                                          behavior: .opaque,
                                          onTap: () {
                                            setState(() {
                                              if (selectedRow == attack.index) {
                                                selectedRow = 0;
                                              } else {
                                                selectedRow = attack.index;
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              for (final defence
                                                  in Types.values)
                                                Expanded(
                                                  child: Builder(
                                                    builder: (context) {
                                                      final position = Position(
                                                        Types.values.indexOf(
                                                          attack,
                                                        ),
                                                        Types.values.indexOf(
                                                          defence,
                                                        ),
                                                      );

                                                      return EffectivenessBox(
                                                        attack: attack,
                                                        defence: defence,
                                                      );
                                                    },
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            if (selectedRow > 0)
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedRow = 0;
                  });
                },
                child: Container(
                  margin: .only(left: 80),
                  child: Column(
                    children: [
                      if (selectedRow != 0)
                        Expanded(
                          flex: selectedRow,
                          child: Container(color: Colors.black54),
                        ),
                      Row(
                        children: [
                          for (final type in Types.values)
                            Expanded(child: TopRowType(type)),
                        ],
                      ),
                      Spacer(),
                      Expanded(
                        flex: Types.values.length - selectedRow - 1,
                        child: Container(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EffectivenessBox extends StatelessWidget {
  final Types attack;
  final Types defence;
  const EffectivenessBox({
    required this.attack,
    required this.defence,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveness = defence.defend(attack);

    if (effectiveness == 1) {
      return SizedBox.expand();
    }
    Color color = Colors.red;
    if (effectiveness > 1) {
      color = Colors.green;
    } else if (effectiveness == 0) {
      color = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        border: Border(
          left: BorderSide(color: Colors.black26),
          right: BorderSide(color: Colors.black26),
        ),
      ),
      child: Center(child: Text(effectiveness.toString())),
    );
  }
}

class OutlinedText extends StatelessWidget {
  final String text;
  const OutlinedText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = .stroke
              ..strokeWidth = 4
              ..color = Colors.black,
          ),
        ),
        Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

class TopRowType extends StatelessWidget {
  final Types type;
  const TopRowType(this.type, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black26),
          bottom: BorderSide(color: Colors.black26),
          top: BorderSide(color: Colors.black26),
        ),
        color: type.color,
      ),
      height: 80,
      child: RotatedBox(
        quarterTurns: 1,
        child: Padding(
          padding: .only(left: 8.0),
          child: Align(
            alignment: .centerLeft,
            child: OutlinedText(type.name.capitalize),
          ),
        ),
      ),
    );
  }
}

class Fade extends StatelessWidget {
  final Widget child;
  final bool? enabled;
  const Fade({required this.child, this.enabled, super.key});

  @override
  Widget build(BuildContext context) {
    if (enabled == false) {
      return child;
    }
    return Container(color: Colors.black38, child: child);
  }
}

BorderSide _borderSide() {
  return BorderSide(color: Colors.black26);
}
