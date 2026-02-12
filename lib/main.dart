import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_chart/chart/chart.dart';
import 'package:pokemon_chart/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon type chart',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ChangeNotifierProvider<AppState>(
        create: (context) => AppState(),
        builder: (context, child) {
          AppState.stateContext = context;
          return child!;
        },
        child: const Chart(),
      ),
    );
  }
}
