import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokemon_chart/defense_overlay.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/type.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  static double get sidebarSize => 108;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Position> highlights = [];
  List<Types> defenseTypes = [Types.normal];
  int selectedRow = 0;

  bool get fade => selectedRow != 0 || defenseTypes.isNotEmpty;

  void selectRow(int row) {
    if (defenseTypes.isNotEmpty) {
      defenseTypes.clear();
    }
    if (selectedRow == row) {
      selectedRow = 0;
    } else {
      selectedRow = row;
    }
    setState(() {});
  }

  void selectDefenseType(Types type) {
    if (defenseTypes.contains(type)) {
      defenseTypes.remove(type);
      setState(() {});
      return;
    }

    if (defenseTypes.length == 2) {
      defenseTypes.clear();
    }

    defenseTypes.add(type);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fade ? Colors.black54 : null,
      body: Container(
        decoration: BoxDecoration(border: .fromBorderSide(_borderSide())),
        margin: .all(24),
        child: Material(
          color: Colors.white,
          child: Stack(
            fit: .expand,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: Chart.sidebarSize,
                        height: Chart.sidebarSize,
                        decoration: BoxDecoration(
                          color: fade ? Colors.black54 : Colors.white,
                          border: Border(right: _borderSide()),
                        ),
                      ),
                      for (final type in Types.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => selectDefenseType(type),
                            child: TopRowType(type),
                          ),
                        ),
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
                                      child: GestureDetector(
                                        onTap: () => selectRow(type.index),
                                        child: _leftSideItem(type),
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
                                              selectRow(attack.index);
                                            },
                                            child: Row(
                                              children: [
                                                for (final defense
                                                    in Types.values)
                                                  Expanded(
                                                    child: Builder(
                                                      builder: (context) {
                                                        final position =
                                                            Position(
                                                              Types.values
                                                                  .indexOf(
                                                                    attack,
                                                                  ),
                                                              Types.values
                                                                  .indexOf(
                                                                    defense,
                                                                  ),
                                                            );

                                                        return EffectivenessBox(
                                                          attack: attack,
                                                          defense: defense,
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
              if (fade)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedRow = 0;
                      defenseTypes.clear();
                    });
                  },
                  child: Container(
                    margin: .only(left: Chart.sidebarSize),
                    child: Column(
                      children: [
                        if (defenseTypes.isNotEmpty)
                          SizedBox(height: Chart.sidebarSize),
                        Expanded(
                          flex: selectedRow,
                          child: Container(color: Colors.black54),
                        ),
                        if (selectedRow > 0) ...[
                          Row(
                            children: [
                              for (final type in Types.values)
                                Expanded(child: TopRowType(type)),
                            ],
                          ),
                          Spacer(),
                        ],
                        Expanded(
                          flex: Types.values.length - selectedRow - 1,
                          child: Container(color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              if (defenseTypes.isNotEmpty)
                DefenseOverlay(
                  defenseTypes,
                  onTap: () {
                    defenseTypes.clear();
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leftSideItem(Types type) {
    return Stack(
      children: [
        Container(
          width: Chart.sidebarSize,
          padding: .only(left: 8),
          decoration: BoxDecoration(
            color: type.color,
            border: Border(top: _borderSide(), right: _borderSide()),
          ),
          child: Align(
            alignment: .centerLeft,
            child: Row(
              spacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: .all(width: 1.5, color: Colors.black45),
                    shape: .circle,
                  ),
                  child: Image.asset(type.imagePath(), width: 26, height: 26),
                ),
                OutlinedText(type.name.capitalize),
              ],
            ),
          ),
        ),
        if ((fade && selectedRow != type.index) || defenseTypes.isNotEmpty)
          Container(width: Chart.sidebarSize, color: Colors.black54),
      ],
    );
  }
}

class EffectivenessBox extends StatelessWidget {
  final Types attack;
  final Types defense;
  const EffectivenessBox({
    required this.attack,
    required this.defense,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveness = defense.defend(attack);

    if (effectiveness == 1) {
      return SizedBox.expand();
    }
    Color color = Colors.red;
    if (effectiveness.isSuperEffective) {
      color = Colors.green;
    } else if (effectiveness.isImmune) {
      color = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        border: Border(
          left: defense.isFirst ? BorderSide.none : _borderSide(),
          right: defense.isLast ? BorderSide.none : _borderSide(),
        ),
      ),
      child: Center(child: Text(effectiveness.asSymbol)),
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
              ..strokeWidth = 3
              ..color = const Color.fromARGB(221, 24, 24, 24),
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
        border: Border(right: type.isLast ? BorderSide.none : _borderSide()),
        color: type.color,
      ),
      height: Chart.sidebarSize,
      child: RotatedBox(
        quarterTurns: 1,
        child: Padding(
          padding: .only(left: 8, top: 2, bottom: 2),
          child: Align(
            alignment: .centerLeft,
            child: Row(
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: .all(width: 1.5, color: Colors.black45),
                      shape: .circle,
                    ),
                    child: Image.asset(type.imagePath(), width: 26, height: 26),
                  ),
                ),
                SizedBox(width: 8),

                OutlinedText(type.name.capitalize),
              ],
            ),
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

class Position {
  int x, y;
  Position(this.x, this.y);
}
