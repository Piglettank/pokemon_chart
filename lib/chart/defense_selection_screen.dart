import 'package:flutter/material.dart';
import 'package:pokemon_chart/components/outlined_text.dart';
import 'package:pokemon_chart/chart/defense_overlay.dart';
import 'package:pokemon_chart/chart/effectiveness_box.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state.dart';
import 'package:pokemon_chart/style.dart';
import 'package:pokemon_chart/type.dart';

class DefenseSelectionScreen extends StatelessWidget {
  const DefenseSelectionScreen({super.key});

  static const double _topSectionHeight = 150;

  @override
  Widget build(BuildContext context) {
    final state = AppState.of(context);
    final defenseTypes = state.defenseTypes;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        onPressed: () {
          AppState.of(context, listen: false).clearDefenseTypes();
          Navigator.of(context).pop();
        },
        child: Icon(Icons.swap_horiz_rounded, color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: .all(12),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              SizedBox(height: 8),
              _topSection(context, defenseTypes),
              SizedBox(height: 16),
              Row(
                children: [
                  Image.asset('assets/icons/shield.png', width: 24, height: 24),
                  SizedBox(width: 6),
                  OutlinedText('Defense', fontSize: 18),
                ],
              ),
              SizedBox(height: 4),
              _typeGrid(context, defenseTypes),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: defenseTypes.isEmpty
                      ? null
                      : () => AppState.of(context, listen: false).clearDefenseTypes(),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Opacity(
                    opacity: defenseTypes.isEmpty ? 0.4 : 1,
                    child: OutlinedText('Clear', fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topSection(BuildContext context, List<Types> defenseTypes) {
    final attackGroups = Helper.attackGroups(defenseTypes);

    return SizedBox(
      height: _topSectionHeight,
      child: ScrollConfiguration(
        behavior: DragScrollBehavior(),
        child: ListView(
          scrollDirection: .horizontal,
          children: [
            Column(
              spacing: 6,
              crossAxisAlignment: .start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/sword.png', width: 24, height: 24),
                    SizedBox(width: 4),
                    OutlinedText('Attack', fontSize: 18),
                  ],
                ),
                if (defenseTypes.isEmpty)
                  Text(
                    'Select types to see effectiveness',
                    style: TextStyle(color: Colors.black38, fontSize: 12),
                  )
                else
                  Row(
                    children: [
                      for (final entry in attackGroups.entries)
                        if (entry.value.isNotEmpty) ...[
                          for (final type in entry.value) _Attack(type, entry.key),
                          SizedBox(width: 6),
                        ],
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _typeGrid(BuildContext context, List<Types> defenseTypes) {
    final types = Types.values;
    final rows = (types.length / 2).ceil();
    const columns = 2;

    const radius = Radius.circular(10);
    const sharp = Radius.zero;

    return Expanded(
      child: Column(
        spacing: 2,
        children: [
          for (int i = 0; i < rows; i++)
            Expanded(
              child: Row(
                crossAxisAlignment: .stretch,
                spacing: 2,
                children: [
                  for (int j = 0; j < columns; j++)
                    if (i * columns + j < types.length)
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final index = i * columns + j;
                            final type = types[index];
                            final topLeft = index == 0;
                            final topRight = index == (columns - 1);
                            final bottomLeft = i == (rows - 1) && j == 0;
                            final bottomRight = i == (rows - 1) && j == (columns - 1);

                            return _TypeTile(
                              type: type,
                              selected: defenseTypes.contains(type),
                              borderRadius: BorderRadius.only(
                                topLeft: topLeft ? radius : sharp,
                                topRight: topRight ? radius : sharp,
                                bottomLeft: bottomLeft ? radius : sharp,
                                bottomRight: bottomRight ? radius : sharp,
                              ),
                              onTap: () {
                                AppState.of(context, listen: false).selectDefenseType(type);
                              },
                            );
                          },
                        ),
                      ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Attack extends StatelessWidget {
  final Types type;
  final double effectiveness;
  const _Attack(this.type, this.effectiveness);

  @override
  Widget build(BuildContext context) {
    final Color borderColor = Color.lerp(type.color, Colors.black, 0.5)!;

    return Align(
      alignment: .topCenter,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: type.color,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(border: Border(right: Style.borderSide())),
              height: 90,
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Image.asset(type.imagePath(), width: 16, height: 16),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Padding(
                        padding: .only(left: 6, top: 2, bottom: 2),
                        child: Align(
                          alignment: .centerLeft,
                          child: OutlinedText(type.name.capitalize, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Color.lerp(type.color, Colors.white, 0.80)!,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              height: 26,
              width: 26,
              child: EffectivenessBox(effectiveness: effectiveness),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  final Types type;
  final bool selected;
  final BorderRadius borderRadius;
  final VoidCallback onTap;
  const _TypeTile({
    required this.type,
    required this.selected,
    required this.borderRadius,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? Colors.black : Color.lerp(type.color, Colors.black, 0.5)!;

    return Material(
      borderRadius: borderRadius,
      color: selected ? type.color : Color.lerp(type.color, Colors.white, 0.45),
      child: Opacity(
        opacity: selected ? 1 : 0.9,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: .all(color: borderColor, width: selected ? 3 : 1),
            ),
            padding: .symmetric(horizontal: 8),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: .all(width: 1.5, color: Colors.black45),
                    shape: .circle,
                  ),
                  child: Image.asset(type.imagePath(), width: 20, height: 20),
                ),
                const SizedBox(width: 8),
                OutlinedText(type.name.capitalize, fontSize: 13),
                if (selected) ...[
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(color: Colors.white12, shape: .circle),
                    padding: .all(4),
                    child: CustomPaint(size: const Size(16, 16), painter: _CheckPainter()),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.15, size.height * 0.5)
      ..lineTo(size.width * 0.4, size.height * 0.78)
      ..lineTo(size.width * 0.85, size.height * 0.22);

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color.fromARGB(221, 24, 24, 24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
