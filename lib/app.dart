import 'package:flutter/material.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/helper.dart';
import 'package:pokemon_chart/state/state.dart';
import 'package:pokemon_chart/style.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);
    final fade = state.fade;
    bool mobile = Helper.isMobile(context);
    final selectedRow = state.selectedRow;
    final nextTapClears = state.nextTapClears;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 4, 7, 1),
          child: Opacity(
            opacity: 0.35,
            child: Image.asset(
              'assets/images/background-light-sides.png',
              fit: BoxFit.cover,
              alignment: AlignmentGeometry.centerLeft,
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (nextTapClears) {
              AppState.of(context, listen: false).reset();
            }
          },
          child: Scaffold(
            backgroundColor: fade ? Style.chartBackgroundColorDark(context) : Colors.transparent,
            floatingActionButton: mobile ? MyFAB(visible: selectedRow == null) : null,
            body: Chart(),
          ),
        ),
      ],
    );
  }
}
