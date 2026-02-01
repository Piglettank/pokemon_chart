import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/type.dart';

class Helper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static double sidebarSize(BuildContext context) {
    return isMobile(context) ? Chart.sidebarSizeSmall : Chart.sidebarSize;
  }

  static String abbreviation(Types type) {
    switch (type) {
      case Types.normal:
        return "NRM";
      case Types.fire:
        return "FIR";
      case Types.water:
        return "WTR";
      case Types.electric:
        return "ELC";
      case Types.grass:
        return "GRS";
      case Types.ice:
        return "ICE";
      case Types.fighting:
        return "FGT";
      case Types.poison:
        return "PSN";
      case Types.ground:
        return "GRD";
      case Types.flying:
        return "FLY";
      case Types.psychic:
        return "PSY";
      case Types.bug:
        return "BUG";
      case Types.rock:
        return "RCK";
      case Types.ghost:
        return "GHO";
      case Types.dragon:
        return "DRG";
      case Types.dark:
        return "DRK";
      case Types.steel:
        return "STL";
      case Types.fairy:
        return "FRY";
    }
  }

  static Color typeColor(Types type) {
    switch (type) {
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
