import 'package:flutter/material.dart';
import 'package:pokemon_chart/components/outlined_text.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';


class TypeHorizontal extends StatelessWidget {
  final Types type;

  const TypeHorizontal({required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Helper.isMobile(context);
    final size = Helper.sidebarSize(context);
    final state = AppState.of(context);
    final defenseTypes = state.defenseTypes;
    final selectedRow = state.selectedRow;
    final fade =
        (selectedRow != null && selectedRow != type.index) ||
        defenseTypes.isNotEmpty;

    return Stack(
      children: [
        Container(
          width: size,
          padding: mobile ? .zero : .only(left: 8),
          decoration: BoxDecoration(
            color: type.color,
            border: Border(top: Style.borderSide(), right: Style.borderSide()),
          ),
          child: mobile
              ? Center(
                  child: OutlinedText(
                    type.abbreviation,
                    fontSize: mobile ? 12 : 14,
                  ),
                )
              : Align(
                  alignment: .centerLeft,
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: .all(width: 1.5, color: Colors.black45),
                          shape: .circle,
                        ),
                        child: Image.asset(
                          type.imagePath(),
                          width: 26,
                          height: 26,
                        ),
                      ),
                      OutlinedText(type.name.capitalize),
                    ],
                  ),
                ),
        ),
        if (fade) Container(width: size, color: Colors.black54),
      ],
    );
  }
}
