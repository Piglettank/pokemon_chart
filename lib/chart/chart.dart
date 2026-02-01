import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/defense_overlay.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  static double get sidebarSize => 108;
  static double get sidebarSizeSmall => 38;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Position> highlights = [];
  List<Types> defenseTypes = [];
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

  void clearSelection() {
    defenseTypes.clear();
    selectedRow = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool mobile = Helper.isMobile(context);

    return GestureDetector(
      onTap: () {
        clearSelection();
      },
      child: Scaffold(
        backgroundColor: fade ? Colors.black54 : null,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              border: .fromBorderSide(Style.borderSide()),
            ),
            margin: mobile ? .zero : .all(24),
            constraints: BoxConstraints(maxWidth: 880),
            child: Material(
              color: Colors.white,
              child: Stack(
                fit: .expand,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: mobile
                                    ? Chart.sidebarSizeSmall
                                    : Chart.sidebarSize,
                                height: mobile
                                    ? Chart.sidebarSizeSmall
                                    : Chart.sidebarSize,
                                decoration: BoxDecoration(
                                  color: fade ? Colors.black54 : Colors.white,
                                  border: Border(right: Style.borderSide()),
                                ),
                              ),
                              if (!Helper.isMobile(context)) ...[
                                Positioned(
                                  bottom: 4,
                                  left: 8,
                                  child: Text('Attack'),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 8,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Text('Defense'),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          for (final type in Types.values)
                            Expanded(
                              child: TopRowType(
                                type,
                                onTap: () => selectDefenseType(type),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constrains) {
                            return SizedBox(
                              height: constrains.maxHeight,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      for (final type in Types.values)
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => selectRow(type.index),
                                            child: LeftSideItem(
                                              type: type,
                                              fade: fade,
                                              selectedRow: selectedRow,
                                              defenseTypes: defenseTypes,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        for (final attack in Types.values)
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  top: Style.borderSide(),
                                                  right: Style.borderSide(),
                                                ),
                                                color: attack.color.withAlpha(
                                                  40,
                                                ),
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
                                                        child: EffectivenessBox(
                                                          effectiveness: defense
                                                              .defend(attack),
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
                                ],
                              ),
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
                        margin: .only(
                          left: mobile
                              ? Chart.sidebarSizeSmall
                              : Chart.sidebarSize,
                        ),
                        child: Column(
                          children: [
                            if (defenseTypes.isNotEmpty)
                              SizedBox(
                                height: mobile
                                    ? Chart.sidebarSizeSmall
                                    : Chart.sidebarSize,
                              ),
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
                      defenseOnTap: selectDefenseType,
                      onTap: clearSelection,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeftSideItem extends StatelessWidget {
  final Types type;
  final bool fade;
  final int selectedRow;
  final List<Types> defenseTypes;
  const LeftSideItem({
    required this.type,
    required this.fade,
    required this.selectedRow,
    required this.defenseTypes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = Helper.isMobile(context);
    final size = Helper.sidebarSize(context);

    return Stack(
      children: [
        Container(
          width: size,
          padding: mobile ? .zero : .only(left: 8),
          decoration: BoxDecoration(
            color: type.color,
            border: Border(top: Style.borderSide(), right: Style.borderSide()),
          ),
          child: mobile
              ? Center(
                  child: OutlinedText(
                    type.abbreviation,
                    fontSize: mobile ? 12 : 14,
                  ),
                )
              : Align(
                  alignment: .centerLeft,
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: .all(width: 1.5, color: Colors.black45),
                          shape: .circle,
                        ),
                        child: Image.asset(
                          type.imagePath(),
                          width: 26,
                          height: 26,
                        ),
                      ),
                      OutlinedText(type.name.capitalize),
                    ],
                  ),
                ),
        ),
        if ((fade && selectedRow != type.index) || defenseTypes.isNotEmpty)
          Container(width: size, color: Colors.black54),
      ],
    );
  }
}

class OutlinedText extends StatelessWidget {
  final String text;
  final double? fontSize;
  const OutlinedText(this.text, {this.fontSize, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = .stroke
              ..strokeWidth = 3
              ..color = const Color.fromARGB(221, 24, 24, 24),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class TopRowType extends StatelessWidget {
  final Types type;
  final VoidCallback? onTap;
  const TopRowType(this.type, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Helper.isMobile(context);

    return Material(
      color: type.color,
      child: InkWell(
        splashColor: Colors.black38,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: type.isLast ? BorderSide.none : Style.borderSide(),
            ),
          ),
          height: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize,
          child: RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: .only(left: 8, top: 2, bottom: 2),
              child: Align(
                alignment: .centerLeft,
                child: Row(
                  children: [
                    if (!mobile) ...[
                      RotatedBox(
                        quarterTurns: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: .all(width: 1.5, color: Colors.black45),
                            shape: .circle,
                          ),
                          child: Ink.image(
                            image: AssetImage(type.imagePath()),
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                    ],

                    OutlinedText(
                      mobile ? type.abbreviation : type.name.capitalize,
                      fontSize: mobile ? 10 : 14,
                    ),
                  ],
                ),
              ),
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

class Position {
  int x, y;
  Position(this.x, this.y);
}
