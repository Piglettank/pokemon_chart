import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_chart/type.dart';

class AppState with ChangeNotifier {
  static BuildContext? stateContext;
  List<Types> _defenseTypes = [];

  static AppState get({bool listen = true}) {
    return Provider.of<AppState>(stateContext!, listen: listen);
  }

  List<Types> get defenseTypes => _defenseTypes;
  set defenseTypes(List<Types> types) {
    _defenseTypes = types;
    print(types);
    notifyListeners();
  }
}
