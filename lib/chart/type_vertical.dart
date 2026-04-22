import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/components/outlined_text.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';

class TypeVertical extends StatelessWidget {
  final Types type;
  final VoidCallback? onTap;
  const TypeVertical(this.type, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Helper.isMobile(context);

    return Material(
      color: type.color,
      child: InkWell(
        splashColor: Colors.black38,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: type.isLast ? BorderSide.none : Style.borderSide(),
            ),
          ),
          height: mobile ? Chart.sidebarSizeSmall : Chart.sidebarSize,
          child: RotatedBox(
            quarterTurns: 1,
            child: Padding(
              padding: .only(left: 8, top: 2, bottom: 2),
              child: Align(
                alignment: .centerLeft,
                child: Row(
                  children: [
                    if (!mobile) ...[
                      RotatedBox(
                        quarterTurns: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            border: .all(width: 1.5, color: Colors.black45),
                            shape: .circle,
                          ),
                          child: Ink.image(
                            image: AssetImage(type.imagePath()),
                            width: 26,
                            height: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    OutlinedText(
                      mobile ? type.abbreviation : type.name.capitalize,
                      fontSize: mobile ? 10 : 14,
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
}
