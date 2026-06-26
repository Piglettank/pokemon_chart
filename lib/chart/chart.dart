import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/defense_overlay.dart';
import 'package:pokemon_chart/chart/defense_selection_screen.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/chart/type_horizontal.dart';
import 'package:pokemon_chart/chart/type_vertical.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';
import 'package:provider/provider.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  static double get sidebarSize => 108;
  static double get sidebarSizeSmall => 38;

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final _gridKey = GlobalKey();
  bool _shouldDeselectOnNextPress = false;

  void selectRow(int row) {
    final state = AppState.of(context, listen: false);
    state.setSelectedRow(row);
  }

  void clearSelection() {
    final state = AppState.of(context, listen: false);
    state.clearDefenseTypes();
    state.clearSelectedRow();
  }

  @override
  Widget build(BuildContext context) {
    bool mobile = Helper.isMobile(context);
    final state = AppState.of(context);
    final defenseTypes = state.defenseTypes;
    final selectedRow = state.selectedRow;
    final fade = state.fade;

    return Listener(
      onPointerDown: (_) {
        if (_shouldDeselectOnNextPress) {
          _shouldDeselectOnNextPress = false;
          clearSelection();
        }
      },
      child: Scaffold(
        backgroundColor: fade ? Colors.black54 : null,
        floatingActionButton: mobile ? MyFAB(visible: selectedRow == null) : null,
        body: GestureDetector(
          behavior: fade ? HitTestBehavior.opaque : HitTestBehavior.translucent,
          onTap: fade ? clearSelection : null,
          child: Center(
            child: Container(
              decoration: BoxDecoration(border: .fromBorderSide(Style.borderSide())),
              margin: mobile ? .zero : .all(24),
              constraints: BoxConstraints(maxWidth: 880),
              child: Material(
                color: Colors.white,
                child: Stack(
                  fit: .expand,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize,
                                  height: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize,
                                  decoration: BoxDecoration(
                                    color: fade ? Colors.black54 : Colors.white,
                                    border: Border(right: Style.borderSide()),
                                  ),
                                ),
                                if (!mobile) ...[
                                  Positioned(
                                    bottom: 4,
                                    left: 4,
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/sword.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(width: 2),
                                        const Text('ATK'),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    right: 4,
                                    top: 8,
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/icons/shield.png',
                                          height: 24,
                                          width: 24,
                                        ),
                                        const SizedBox(height: 2),
                                        const RotatedBox(quarterTurns: 1, child: Text('DEF')),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            for (final type in Types.values)
                              Expanded(
                                child: TypeVertical(
                                  type,
                                  onTap: () =>
                                      AppState.of(context, listen: false).selectDefenseType(type),
                                ),
                              ),
                          ],
                        ),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, constrains) {
                              return Listener(
                                onPointerDown: (event) {
                                  if (!_shouldDeselectOnNextPress && selectedRow == null) {
                                    state.clearDefenseTypes();
                                    final row = _rowFromPointerEvent(event);
                                    if (row != null) selectRow(row);
                                  }
                                },
                                onPointerMove: (event) {
                                  final row = _rowFromPointerEvent(event);
                                  if (row != null && row != selectedRow) {
                                    selectRow(row);
                                  }
                                },
                                onPointerUp: (_) {
                                  if (selectedRow != null) {
                                    _shouldDeselectOnNextPress = true;
                                  }
                                },
                                child: SizedBox(
                                  key: _gridKey,
                                  height: constrains.maxHeight,
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          for (final type in Types.values)
                                            Expanded(child: TypeHorizontal(type: type)),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            for (final attack in Types.values)
                                              Expanded(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: Style.borderSide(),
                                                      right: Style.borderSide(),
                                                    ),
                                                    color: attack.color.withAlpha(40),
                                                  ),

                                                  child: Row(
                                                    children: [
                                                      for (final defense in Types.values)
                                                        Expanded(
                                                          child: EffectivenessBox(
                                                            effectiveness: defense.defend(attack),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if (fade)
                      Container(
                        margin: .only(left: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize),
                        child: Column(
                          children: [
                            if (defenseTypes.isNotEmpty)
                              SizedBox(height: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize),
                            if (selectedRow != null) ...[
                              Expanded(
                                flex: selectedRow,
                                child: Container(color: Colors.black54),
                              ),
                              Row(
                                children: [
                                  for (final type in Types.values)
                                    Expanded(child: TypeVertical(type)),
                                ],
                              ),
                              Spacer(),
                              Expanded(
                                flex: Types.values.length - selectedRow - 1,
                                child: Container(color: Colors.black54),
                              ),
                            ] else
                              Expanded(child: Container(color: Colors.black54)),
                          ],
                        ),
                      ),
                    if (!mobile && defenseTypes.isNotEmpty)
                      DefenseOverlay(
                        defenseTypes,
                        defenseOnTap: AppState.of(context, listen: false).selectDefenseType,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int? _rowFromPointerEvent(PointerEvent event) {
    final renderBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final localY = renderBox.globalToLocal(event.position).dy;
    final rowHeight = renderBox.size.height / Types.values.length;
    final index = (localY / rowHeight).floor().clamp(0, Types.values.length - 1);
    return Types.values[index].index;
  }
}

class Fade extends StatelessWidget {
  final Widget child;
  final bool? enabled;
  const Fade({required this.child, this.enabled, super.key});

  @override
  Widget build(BuildContext context) {
    if (enabled == false) {
      return child;
    }
    return Container(color: Colors.black38, child: child);
  }
}

class MyFAB extends StatelessWidget {
  final bool visible;
  const MyFAB({this.visible = true, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FloatingActionButton(
        onPressed: () {
          final state = AppState.of(context, listen: false);
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  ChangeNotifierProvider.value(value: state, child: const DefenseSelectionScreen()),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: const Icon(Icons.swap_horiz_rounded),
      ),
    );
  }
}
