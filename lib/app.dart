import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/nexora_game.dart';

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key});

  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  late final NexoraGame _game = NexoraGame();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEXORA: Battle Arena',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: Scaffold(
        body: GameWidget<NexoraGame>(game: _game),
      ),
    );
  }
}
