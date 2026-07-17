import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/components/outlined_text.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/chart/type_vertical.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state/state.dart';
import 'package:pokemon_chart/type.dart';

class DefenseOverlay extends StatelessWidget {
  final List<Types> defenseTypes;
  final Function(Types) defenseOnTap;
  const DefenseOverlay(this.defenseTypes, {required this.defenseOnTap, super.key});

  static double height = 224;

  @override
  Widget build(BuildContext context) {
    const double defenseWidth = 96;
    final mobile = Helper.isMobile(context);
    final groups = Helper.attackGroups(defenseTypes);

    return Positioned(
      top: Helper.sidebarSize(context),
      left: mobile ? 12 : Chart.sidebarSize,
      right: mobile ? 12 : 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {},
            child: Padding(
              padding: .symmetric(vertical: 12),
              child: Material(
                borderRadius: .circular(6),
                color: Colors.white,
                elevation: 4,
                child: Container(
                  padding: .all(20),
                  decoration: BoxDecoration(
                    borderRadius: .circular(6),
                    border: .all(color: Colors.black26),
                  ),
                  height: mobile ? 400 : height,
                  width: constraints.maxWidth,
                  child: Stack(
                    children: [
                      Column(
                        spacing: 8,
                        mainAxisSize: .min,
                        children: [
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: DragScrollBehavior(),
                              child: ListView(
                                scrollDirection: .horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    width: defenseWidth,
                                    child: Column(
                                      spacing: 8,
                                      crossAxisAlignment: .start,
                                      children: [
                                        OutlinedText('Defense'),
                                        for (final type in defenseTypes)
                                          _Defense(type: type, onTap: defenseOnTap),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    spacing: 8,
                                    crossAxisAlignment: .start,
                                    children: [
                                      OutlinedText('Attack'),
                                      Row(
                                        children: [
                                          for (final entry in groups.entries)
                                            if (entry.value.isNotEmpty) ...[
                                              for (final type in entry.value)
                                                _Attack(type, entry.key),
                                              SizedBox(width: 8),
                                            ],
                                        ],
                                      ),
                                    ],
                                  ),

                                  SizedBox(width: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          visualDensity: .compact,
                          padding: .zero,
                          onPressed: () => AppState.of(context, listen: false).clearDefenseTypes(),
                          icon: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Defense extends StatelessWidget {
  final Types type;
  final Function(Types) onTap;
  const _Defense({required this.type, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Color.lerp(type.color, Colors.black, 0.5)!;

    return Material(
      borderRadius: .circular(8),
      color: type.color,
      child: InkWell(
        onTap: () => onTap(type),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: .circular(8),
            border: .all(color: borderColor),
          ),
          padding: .all(8),
          child: Row(
            mainAxisSize: .min,
            children: [
              Image.asset(type.imagePath(), width: 24, height: 24),
              SizedBox(width: 6),
              OutlinedText(type.abbreviation, fontSize: 12),
              Spacer(),
              Icon(Icons.close_rounded, size: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class DragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}

class _Attack extends StatelessWidget {
  final Types type;
  final double effectiveness;
  const _Attack(this.type, this.effectiveness);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Color.lerp(type.color, Colors.black, 0.5)!;
    final bool mobile = Helper.isMobile(context);

    return Align(
      alignment: .topCenter,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: borderColor)),
        child: Column(
          mainAxisSize: .min,
          children: [
            TypeVertical(type),
            Container(
              decoration: BoxDecoration(
                color: type.color.withAlpha(40),
                border: Border(top: BorderSide(color: borderColor)),
              ),
              height: mobile ? 26 : 40,
              width: mobile ? 18 : 34,
              child: EffectivenessBox(effectiveness: effectiveness),
            ),
          ],
        ),
      ),
    );
  }
}
