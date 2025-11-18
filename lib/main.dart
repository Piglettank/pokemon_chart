import 'package:flutter/material.dart';
import 'package:pokemon_chart/extensions.dart';
import 'package:pokemon_chart/type.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class Position {
  int x, y;
  Position(this.x, this.y);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Position> highlights = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: .only(top: 20, left: 20, right: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Container()),
                for (final type in Types.values)
                  Expanded(
                    child: Transform.rotate(
                      angle: 70,
                      child: Text(type.name.capitalize),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  return Row(
                    children: [
                      Container(
                        height: constrains.maxHeight,
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Spacer(),
                            for (final type in Types.values)
                              Expanded(
                                child: Align(
                                  alignment: .centerLeft,
                                  child: Text(type.name.capitalize),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: constrains.maxHeight,
                          child: Column(
                            children: [
                              Spacer(),
                              for (final attack in Types.values)
                                Expanded(
                                  child: Row(
                                    children: [
                                      for (final defence in Types.values)
                                        Expanded(
                                          child: Builder(
                                            builder: (context) {
                                              final position = Position(
                                                Types.values.indexOf(attack),
                                                Types.values.indexOf(defence),
                                              );

                                              return EffectivenessBox(
                                                attack: attack,
                                                defence: defence,
                                              );
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EffectivenessBox extends StatelessWidget {
  final Types attack;
  final Types defence;
  const EffectivenessBox({
    required this.attack,
    required this.defence,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveness = defence.defend(attack);

    if (effectiveness == 1) {
      return SizedBox();
    }

    return Center(child: Text(effectiveness.toString()));
  }
}
