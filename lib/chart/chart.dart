import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/defense_overlay.dart';
import 'package:pokemon_chart/chart/defense_overlay_small.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/chart/type_horizontal.dart';
import 'package:pokemon_chart/chart/type_vertical.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state.dart';
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
  void selectRow(int row) {
    final state = AppState.of(context, listen: false);
    state.setSelectedRow(row);
  }

  void clearSelection() {
    final state = AppState.of(context, listen: false);
    state.clearDefenseTypes();
    state.clearSelectedRow();
  }

  @override
  Widget build(BuildContext context) {
    bool mobile = Helper.isMobile(context);
    final state = AppState.of(context);
    final defenseTypes = state.defenseTypes;
    final selectedRow = state.selectedRow;
    final fade = state.fade;

    return GestureDetector(
      onTap: () {
        clearSelection();
      },
      child: Scaffold(
        backgroundColor: fade ? Colors.black54 : null,
        floatingActionButton: mobile ? MyFAB() : null,
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
                                  left: 4,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/sword.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(width: 2),
                                      Text('ATK'),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  top: 8,
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/icons/shield.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      SizedBox(height: 2),
                                      RotatedBox(
                                        quarterTurns: 1,
                                        child: Text('DEF'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          for (final type in Types.values)
                            Expanded(
                              child: TypeVertical(
                                type,
                                onTap: () => AppState.of(
                                  context,
                                  listen: false,
                                ).selectDefenseType(type),
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
                                            child: TypeHorizontal(type: type),
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
                        selectRow(0);
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
                                    Expanded(child: TypeVertical(type)),
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
                    if (mobile)
                      DefenseOverlaySmall()
                    else
                      DefenseOverlay(
                        defenseTypes,
                        defenseOnTap: AppState.of(
                          context,
                          listen: false,
                        ).selectDefenseType,
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

class MyFAB extends StatelessWidget {
  const MyFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        AppState.of(context, listen: false).selectDefenseType(Types.bug);
      },
      child: Icon(Icons.swap_horiz_rounded),
    );
  }
}
