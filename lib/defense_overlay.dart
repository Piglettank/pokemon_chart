import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart.dart';
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
              padding: .all(12),
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
                  height: 180,
                  width: constraints.maxWidth,
                  child: Row(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        width: 104,
                        child: Column(
                          mainAxisAlignment: .center,
                          crossAxisAlignment: .start,
                          children: [
                            OutlinedText('Defense'),
                            SizedBox(height: 8),

                            Row(
                              spacing: 8,
                              children: [
                                for (final type in types)
                                  Image.asset(
                                    type.imagePath(),
                                    width: 48,
                                    height: 48,
                                  ),
                              ],
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
                      Expanded(
                        child: ListView(
                          scrollDirection: .horizontal,
                          shrinkWrap: true,
                          children: [
                            for (final type in hyperEffectiveTypes)
                              _Attack(type, 4),
                            SizedBox(width: 8),
                            for (final type in superEffectiveTypes)
                              _Attack(type, 2),
                            SizedBox(width: 8),
                            for (final type in notVeryEffectiveTypes)
                              _Attack(type, 0.5),
                            SizedBox(width: 8),
                            for (final type in veryNotEffectiveTypes)
                              _Attack(type, 0.25),
                            SizedBox(width: 8),
                            for (final type in immuneTypes) _Attack(type, 0),
                          ],
                        ),
                      ),

                      IconButton(onPressed: onTap, icon: Icon(Icons.close)),
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

class _Attack extends StatelessWidget {
  final Types type;
  final double effectiveness;
  const _Attack(this.type, this.effectiveness, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopRowType(type),
        SizedBox(height: 4),
        Text(effectiveness.asSymbol),
      ],
    );
  }
}
