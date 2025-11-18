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
}
