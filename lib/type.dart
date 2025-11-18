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

  Color get color {
    switch (this) {
      case Types.normal:
        return Color.fromARGB(255, 244, 237, 237);

      case Types.fire:
        return Color.fromARGB(255, 247, 127, 14);

      case Types.water:
        return Color.fromARGB(255, 28, 153, 220);

      case Types.grass:
        return Color.fromARGB(255, 92, 215, 92);

      case Types.electric:
        return Color.fromARGB(255, 236, 233, 85);

      case Types.ice:
        return Color.fromARGB(255, 127, 235, 245);

      case Types.fighting:
        return Color.fromARGB(255, 160, 113, 66);

      case Types.poison:
        return Color.fromARGB(255, 72, 26, 72);

      case Types.ground:
        return Color.fromARGB(255, 156, 144, 121);

      case Types.flying:
        return Color.fromARGB(255, 179, 213, 212);

      case Types.psychic:
        return Color.fromARGB(255, 201, 71, 203);

      case Types.bug:
        return Color.fromARGB(255, 140, 202, 89);

      case Types.rock:
        return Color.fromARGB(255, 77, 64, 40);

      case Types.ghost:
        return Color.fromARGB(255, 152, 159, 168);

      case Types.dark:
        return Color.fromARGB(255, 25, 25, 26);

      case Types.steel:
        return Color.fromARGB(255, 132, 135, 135);

      case Types.dragon:
        return Color.fromARGB(255, 160, 65, 201);

      case Types.fairy:
        return Color.fromARGB(255, 227, 135, 213);
    }
  }
}
