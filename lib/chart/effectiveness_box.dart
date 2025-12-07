import 'package:flutter/material.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/style.dart';

class EffectivenessBox extends StatelessWidget {
  final double effectiveness;
  final Border? border;
  const EffectivenessBox({required this.effectiveness, this.border, super.key});

  @override
  Widget build(BuildContext context) {
    Color? color;
    if (effectiveness.isSuperEffective) {
      color = Colors.green[400]!.withAlpha(90);
    } else if (effectiveness.isImmune) {
      color = Colors.grey[400]!.withAlpha(180);
    } else if (effectiveness.isNotVeryEffective) {
      color = Colors.red.withAlpha(80);
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        border: border ?? Border(right: Style.borderSide()),
      ),
      child: Center(child: Text(effectiveness.asSymbol)),
    );
  }
}
