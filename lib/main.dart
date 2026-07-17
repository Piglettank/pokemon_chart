import 'package:flutter/material.dart';
import 'package:pokemon_chart/app.dart';
import 'package:provider/provider.dart';
import 'package:pokemon_chart/state/state.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 68, 140, 1)),
      ),
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<AppState>(
        create: (context) => AppState(),
        builder: (context, child) {
          AppState.stateContext = context;
          return child!;
        },
        child: const App(),
      ),
    );
  }
}
