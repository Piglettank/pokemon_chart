import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_chart/type.dart';

class AppState with ChangeNotifier {
  static BuildContext? stateContext;

  static AppState get({bool listen = true}) {
    return Provider.of<AppState>(stateContext!, listen: listen);
  }

  List<Types> _defenseTypes = [];
  List<Types> get defenseTypes => _defenseTypes;
  void setDefenseTypes(List<Types> types, {bool notify = true}) {
    _defenseTypes = types;
    _notify(notify);
  }

  int _selectedRow = 0;
  int get selectedRow => _selectedRow;
  void setSelectedRow(int row, {bool notify = true}) {
    _selectedRow = row;
    _notify(notify);
  }

  void _notify(bool notify) {
    if (notify) {
      print('notifyListeners');
      notifyListeners();
    }
  }
}
