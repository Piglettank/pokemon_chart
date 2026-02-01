import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';

class DefenseOverlay extends StatelessWidget {
  final List<Types> defenseTypes;
  final VoidCallback? onTap;
  final Function(Types) defenseOnTap;
  const DefenseOverlay(
    this.defenseTypes, {
    required this.defenseOnTap,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const double defenseWidth = 96;
    final immuneTypes = <Types>[];
    final hyperEffectiveTypes = <Types>[];
    final superEffectiveTypes = <Types>[];
    final notVeryEffectiveTypes = <Types>[];
    final veryNotEffectiveTypes = <Types>[];
    for (final attack in Types.values) {
      double effectiveness = 1;
      for (final defenseType in defenseTypes) {
        effectiveness *= defenseType.defend(attack);
      }
      if (effectiveness.isHyperEffective) {
        hyperEffectiveTypes.add(attack);
      } else if (effectiveness.isVeryNotEffective) {
        veryNotEffectiveTypes.add(attack);
      } else if (effectiveness.isSuperEffective) {
        superEffectiveTypes.add(attack);
      } else if (effectiveness.isNotVeryEffective) {
        notVeryEffectiveTypes.add(attack);
      } else if (effectiveness.isImmune) {
        immuneTypes.add(attack);
      }
    }

    return Positioned(
      top: Helper.sidebarSize(context),
      left: Helper.isMobile(context) ? 4 : Chart.sidebarSize,
      right: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onTap: onTap,
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
                  height: 204,
                  width: constraints.maxWidth,
                  child: Stack(
                    children: [
                      Column(
                        spacing: 8,
                        mainAxisSize: .min,
                        children: [
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: ListView(
                                scrollDirection: .horizontal,
                                primary: true,
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
                                          _Defense(
                                            type: type,
                                            onTap: defenseOnTap,
                                          ),
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
                                          for (final type
                                              in hyperEffectiveTypes)
                                            _Attack(type, 4),
                                          if (hyperEffectiveTypes.isNotEmpty)
                                            SizedBox(width: 8),
                                          for (final type
                                              in superEffectiveTypes)
                                            _Attack(type, 2),
                                          if (superEffectiveTypes.isNotEmpty)
                                            SizedBox(width: 8),
                                          for (final type
                                              in notVeryEffectiveTypes)
                                            _Attack(type, 0.5),
                                          if (notVeryEffectiveTypes.isNotEmpty)
                                            SizedBox(width: 8),
                                          for (final type
                                              in veryNotEffectiveTypes)
                                            _Attack(type, 0.25),
                                          if (veryNotEffectiveTypes.isNotEmpty)
                                            SizedBox(width: 8),
                                          for (final type in immuneTypes)
                                            _Attack(type, 0),
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
                          onPressed: onTap,
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
  const _Defense({super.key, required this.type, required this.onTap});

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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class _Attack extends StatelessWidget {
  final Types type;
  final double effectiveness;
  const _Attack(this.type, this.effectiveness, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: .topCenter,
      child: Container(
        decoration: BoxDecoration(
          border: Border.fromBorderSide(Style.borderSideBlend(type.color)),
        ),
        child: Column(
          mainAxisSize: .min,
          children: [
            TopRowType(type),
            Container(
              color: type.color.withAlpha(40),
              height: 24,
              width: Helper.isMobile(context) ? 19 : 34,
              child: EffectivenessBox(
                effectiveness: effectiveness,
                border: Border(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
