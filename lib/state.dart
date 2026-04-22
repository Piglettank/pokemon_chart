import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_chart/type.dart';

class AppState with ChangeNotifier {
  static BuildContext? stateContext;

  static AppState of(BuildContext context, {bool listen = true}) {
    return Provider.of<AppState>(context, listen: listen);
  }

  final List<Types> _defenseTypes = [];
  List<Types> get defenseTypes => _defenseTypes;
  void selectDefenseType(Types type, {bool notify = true}) {
    if (_defenseTypes.contains(type)) {
      _defenseTypes.remove(type);
      _notify(notify);
      return;
    }

    if (_defenseTypes.length == 2) {
      _defenseTypes.clear();
    }

    _defenseTypes.add(type);

    _notify(notify);
  }

  void clearDefenseTypes({bool notify = true}) {
    _defenseTypes.clear();
    _notify(notify);
  }

  int? _selectedRow;
  int? get selectedRow => _selectedRow;
  void setSelectedRow(int row, {bool notify = true}) {
    _selectedRow = row;
    _notify(notify);
  }

  void clearSelectedRow() {
    _selectedRow = null;
    _notify(true);
  }

  void _notify(bool notify) {
    if (notify) {
      notifyListeners();
    }
  }

  bool get fade => selectedRow != null || defenseTypes.isNotEmpty;
}
