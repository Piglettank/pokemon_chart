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

  double attack(Types defend) {
    return Helper.effectiveness(defend, this);
  }

  double defend(Types attack) {
    return Helper.effectiveness(attack, this);
  }

  String imagePath() {
    return 'assets/types/${name}_48.png';
  }

  bool get isFirst => index == 0;
  bool get isLast => index == Types.values.length - 1;

  Color get color {
    switch (this) {
      case Types.normal:
        return Color.fromARGB(255, 244, 237, 237);

      case Types.fire:
        return Color.fromARGB(255, 247, 100, 14);

      case Types.water:
        return Color.fromARGB(255, 28, 153, 220);

      case Types.grass:
        return Color.fromARGB(255, 92, 215, 92);

      case Types.electric:
        return Color.fromARGB(255, 236, 233, 85);

      case Types.ice:
        return Color.fromARGB(255, 127, 235, 245);

      case Types.fighting:
        return Color.fromARGB(255, 203, 141, 79);

      case Types.poison:
        return Color.fromARGB(255, 111, 38, 111);

      case Types.ground:
        return Color.fromARGB(255, 122, 91, 79);

      case Types.flying:
        return Color.fromARGB(255, 156, 197, 207);

      case Types.psychic:
        return Color.fromARGB(255, 208, 93, 175);

      case Types.bug:
        return Color.fromARGB(255, 128, 158, 65);

      case Types.rock:
        return Color.fromARGB(255, 106, 100, 70);

      case Types.ghost:
        return Color.fromARGB(255, 139, 113, 151);

      case Types.dark:
        return Color.fromARGB(255, 59, 54, 54);

      case Types.steel:
        return Color.fromARGB(255, 135, 147, 147);

      case Types.dragon:
        return Color.fromARGB(255, 68, 64, 144);

      case Types.fairy:
        return Color.fromARGB(255, 227, 135, 213);
    }
  }
}
