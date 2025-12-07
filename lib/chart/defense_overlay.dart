import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/type.dart';

class DefenseOverlay extends StatelessWidget {
  final List<Types> types;
  final VoidCallback? onTap;
  const DefenseOverlay(this.types, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final immuneTypes = <Types>[];
    final hyperEffectiveTypes = <Types>[];
    final superEffectiveTypes = <Types>[];
    final notVeryEffectiveTypes = <Types>[];
    final veryNotEffectiveTypes = <Types>[];
    for (final attack in Types.values) {
      double effectiveness = 1;
      for (final defenseType in types) {
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
      top: Chart.sidebarSize,
      left: Chart.sidebarSize,
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
                          Row(
                            children: [
                              SizedBox(
                                width: 114,
                                child: OutlinedText('Defense'),
                              ),
                              SizedBox(width: 24),
                              OutlinedText('Attack'),
                            ],
                          ),
                          Expanded(
                            child: ScrollConfiguration(
                              behavior: MyCustomScrollBehavior(),
                              child: ListView(
                                scrollDirection: .horizontal,
                                primary: true,
                                physics: AlwaysScrollableScrollPhysics(),
                                children: [
                                  SizedBox(
                                    width: 114,
                                    child: Column(
                                      mainAxisAlignment: .center,
                                      crossAxisAlignment: .start,
                                      children: [
                                        SizedBox(height: 8),
                                        Row(
                                          spacing: 8,
                                          children: [
                                            for (final type in types)
                                              Column(
                                                children: [
                                                  Image.asset(
                                                    type.imagePath(),
                                                    width: 48,
                                                    height: 48,
                                                  ),
                                                  SizedBox(height: 4),
                                                  OutlinedText(
                                                    type.abbreviation,
                                                    fontSize: 12,
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                        SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 24),
                                  for (final type in hyperEffectiveTypes)
                                    _Attack(type, 4),
                                  if (hyperEffectiveTypes.isNotEmpty)
                                    SizedBox(width: 8),
                                  for (final type in superEffectiveTypes)
                                    _Attack(type, 2),
                                  if (superEffectiveTypes.isNotEmpty)
                                    SizedBox(width: 8),
                                  for (final type in notVeryEffectiveTypes)
                                    _Attack(type, 0.5),
                                  if (notVeryEffectiveTypes.isNotEmpty)
                                    SizedBox(width: 8),
                                  for (final type in veryNotEffectiveTypes)
                                    _Attack(type, 0.25),
                                  if (veryNotEffectiveTypes.isNotEmpty)
                                    SizedBox(width: 8),
                                  for (final type in immuneTypes)
                                    _Attack(type, 0),
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

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}

class _Attack extends StatelessWidget {
  final Types type;
  final double effectiveness;
  const _Attack(this.type, this.effectiveness, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopRowType(type),
        SizedBox(
          height: 24,
          width: 34,
          child: EffectivenessBox(
            effectiveness: effectiveness,
            border: Border(),
          ),
        ),
      ],
    );
  }
}
