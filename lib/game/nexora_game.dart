import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/painting.dart'
    show EdgeInsets, TextStyle, FontWeight;

import 'entities/hero_unit.dart';
import 'entities/minion.dart';
import 'entities/team.dart';
import 'entities/turret.dart';
import 'map/battle_map.dart';
import 'map/map_config.dart';

/// Game utama NEXORA - Tahap 1 (prototipe).
class NexoraGame extends FlameGame {
  late final JoystickComponent joystick;
  late final HeroUnit player;
  late final BotHero bot;

  static const double waveInterval = 15; // detik antar wave
  double _waveTimer = 3;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.zoom = 0.7;

    world.add(BattleMap());

    world.add(Turret(team: Team.blue, position: MapConfig.blueTurretMid));
    world.add(Turret(team: Team.red, position: MapConfig.redTurretMid));

    joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 32, paint: Paint()..color = const Color(0xFFFFD166)),
      background: CircleComponent(
          radius: 80, paint: Paint()..color = const Color(0x552E7BFF)),
      margin: const EdgeInsets.only(left: 48, bottom: 48),
    );
    camera.viewport.add(joystick);

    camera.viewport.add(HudButtonComponent(
      button: _roundButton('ATK', const Color(0xCCE5484D)),
      margin: const EdgeInsets.only(right: 56, bottom: 48),
      onPressed: () => player.manualAttack(),
    ));

    camera.viewport.add(FpsTextComponent(
      position: Vector2(12, 8),
      textRenderer: TextPaint(
          style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14)),
    ));

    player = HeroUnit(
      team: Team.blue,
      position: MapConfig.blueBase + Vector2(60, -60),
      heroName: 'ZHAVEN',
      isPlayer: true,
    );
    world.add(player);

    bot = BotHero(
      team: Team.red,
      position: MapConfig.redBase + Vector2(-60, 60),
      heroName: 'BOT KAEL',
    );
    world.add(bot);

    camera.follow(player);
  }

  PositionComponent _roundButton(String label, Color color) {
    return CircleComponent(
      radius: 45,
      paint: Paint()..color = color,
      children: [
        TextComponent(
          text: label,
          anchor: Anchor.center,
          position: Vector2.all(45),
          textRenderer: TextPaint(
            style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _spawnWave() {
    for (final team in Team.values) {
      for (var i = 0; i < 3; i++) {
        world.add(Minion(
          team: team,
          path: MapConfig.midPathFor(team),
          spawnOffset: i * 28.0,
        ));
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _waveTimer -= dt;
    if (_waveTimer <= 0) {
      _waveTimer = waveInterval;
      _spawnWave();
    }
  }
}
