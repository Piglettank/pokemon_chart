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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .only(top: 20, left: 20, right: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 80),
                for (final type in Types.values)
                  Expanded(
                    child: Transform.rotate(
                      angle: 90 * pi / 180,
                      child: Text(type.name.capitalize),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return Row(
                    children: [
                      Container(
                        height: constrains.maxHeight,
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Spacer(),
                            for (final type in Types.values)
                              Expanded(
                                child: Container(
                                  width: 80,
                                  padding: .only(left: 8),
                                  decoration: BoxDecoration(
                                    color: type.color,
                                    borderRadius: .circular(4),
                                  ),
                                  child: Align(
                                    alignment: .centerLeft,
                                    child: Stack(
                                      children: [
                                        Text(
                                          type.name.capitalize,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            foreground: Paint()
                                              ..style = .stroke
                                              ..strokeWidth = 4
                                              ..color = Colors.black,
                                          ),
                                        ),
                                        Text(
                                          type.name.capitalize,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
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
                      Expanded(
                        child: SizedBox(
                          height: constrains.maxHeight,
                          child: Column(
                            children: [
                              Spacer(),
                              for (final attack in Types.values)
                                Expanded(
                                  child: Container(
                                    color: attack.color.withAlpha(20),
                                    child: Row(
                                      children: [
                                        for (final defence in Types.values)
                                          Expanded(
                                            child: Builder(
                                              builder: (context) {
                                                final position = Position(
                                                  Types.values.indexOf(attack),
                                                  Types.values.indexOf(defence),
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
      return SizedBox();
    }
    Color color = Colors.red;
    if (effectiveness > 1) {
      color = Colors.green;
    } else if (effectiveness == 0) {
      color = Colors.grey;
    }

    return Center(
      child: Container(
        color: color.withAlpha(50),
        child: Text(effectiveness.toString()),
      ),
    );
  }
}
