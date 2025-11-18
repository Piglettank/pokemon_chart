import 'package:pokemon_chart/type.dart';

class Helper {
  static double effectiveness(Types attack, Types defense) {
    switch (attack) {
      case Types.normal:
        switch (defense) {
          case Types.rock:
          case Types.steel:
            return 0.5;
          case Types.ghost:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.fire:
        switch (defense) {
          case Types.grass:
          case Types.ice:
          case Types.bug:
          case Types.steel:
            return 2.0;
          case Types.fire:
          case Types.water:
          case Types.rock:
          case Types.dragon:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.water:
        switch (defense) {
          case Types.fire:
          case Types.ground:
          case Types.rock:
            return 2.0;
          case Types.water:
          case Types.grass:
          case Types.dragon:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.electric:
        switch (defense) {
          case Types.water:
          case Types.flying:
            return 2.0;
          case Types.electric:
          case Types.grass:
          case Types.dragon:
            return 0.5;
          case Types.ground:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.grass:
        switch (defense) {
          case Types.water:
          case Types.ground:
          case Types.rock:
            return 2.0;
          case Types.fire:
          case Types.grass:
          case Types.poison:
          case Types.flying:
          case Types.bug:
          case Types.dragon:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.ice:
        switch (defense) {
          case Types.grass:
          case Types.ground:
          case Types.flying:
          case Types.dragon:
            return 2.0;
          case Types.fire:
          case Types.water:
          case Types.ice:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.fighting:
        switch (defense) {
          case Types.normal:
          case Types.ice:
          case Types.rock:
          case Types.dark:
          case Types.steel:
            return 2.0;
          case Types.poison:
          case Types.flying:
          case Types.psychic:
          case Types.bug:
          case Types.fairy:
            return 0.5;
          case Types.ghost:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.poison:
        switch (defense) {
          case Types.grass:
          case Types.fairy:
            return 2.0;
          case Types.poison:
          case Types.ground:
          case Types.rock:
          case Types.ghost:
            return 0.5;
          case Types.steel:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.ground:
        switch (defense) {
          case Types.fire:
          case Types.electric:
          case Types.poison:
          case Types.rock:
          case Types.steel:
            return 2.0;
          case Types.grass:
          case Types.bug:
            return 0.5;
          case Types.flying:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.flying:
        switch (defense) {
          case Types.grass:
          case Types.fighting:
          case Types.bug:
            return 2.0;
          case Types.electric:
          case Types.rock:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.psychic:
        switch (defense) {
          case Types.fighting:
          case Types.poison:
            return 2.0;
          case Types.psychic:
          case Types.steel:
            return 0.5;
          case Types.dark:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.bug:
        switch (defense) {
          case Types.grass:
          case Types.psychic:
          case Types.dark:
            return 2.0;
          case Types.fire:
          case Types.fighting:
          case Types.poison:
          case Types.flying:
          case Types.ghost:
          case Types.steel:
          case Types.fairy:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.rock:
        switch (defense) {
          case Types.fire:
          case Types.ice:
          case Types.flying:
          case Types.bug:
            return 2.0;
          case Types.fighting:
          case Types.ground:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.ghost:
        switch (defense) {
          case Types.psychic:
          case Types.ghost:
            return 2.0;
          case Types.dark:
            return 0.5;
          case Types.normal:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.dragon:
        switch (defense) {
          case Types.dragon:
            return 2.0;
          case Types.steel:
            return 0.5;
          case Types.fairy:
            return 0.0;
          default:
            return 1.0;
        }

      case Types.dark:
        switch (defense) {
          case Types.psychic:
          case Types.ghost:
            return 2.0;
          case Types.fighting:
          case Types.dark:
          case Types.fairy:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.steel:
        switch (defense) {
          case Types.ice:
          case Types.rock:
          case Types.fairy:
            return 2.0;
          case Types.fire:
          case Types.water:
          case Types.electric:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }

      case Types.fairy:
        switch (defense) {
          case Types.fighting:
          case Types.dragon:
          case Types.dark:
            return 2.0;
          case Types.fire:
          case Types.poison:
          case Types.steel:
            return 0.5;
          default:
            return 1.0;
        }
    }
  }
}
