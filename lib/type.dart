import 'package:flutter/material.dart';
import 'package:pokemon_chart/helper.dart';

enum Types {
  normal,
  fire,
  water,
  grass,
  electric,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dark,
  steel,
  dragon,
  fairy;

  bool get isFirst => index == 0;
  bool get isLast => index == Types.values.length - 1;

  double attack(Types defend) {
    return Helper.effectiveness(defend, this);
  }

  double defend(Types attack) {
    return Helper.effectiveness(attack, this);
  }

  String imagePath() {
    return 'assets/types/${name}_48.png';
  }

  Color get color {
    return Helper.typeColor(this);
  }

  String get abbreviation {
    return Helper.abbreviation(this);
  }
}
