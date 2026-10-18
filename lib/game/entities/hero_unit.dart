import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle, FontWeight;

import '../map/map_config.dart';
import 'team.dart';
import 'unit.dart';

/// Hero yang dikendalikan pemain (joystick). Basis juga untuk bot.
class HeroUnit extends Unit {
  HeroUnit({
    required Team team,
    required Vector2 position,
    required this.heroName,
    this.moveSpeed = 340,
    this.isPlayer = false,
  })  : spawnPoint = position.clone(),
        super(
          team: team,
          maxHp: 2200,
          radius: 28,
          position: position,
          attackRange: 260,
          attackDamage: 120,
          attackInterval: 0.8,
          drawPriority: 5,
        );

  final String heroName;
  final double moveSpeed;
  final bool isPlayer;
  final Vector2 spawnPoint;
  final Vector2 facing = Vector2(1, 0);
  double respawnIn = 0;

  static final TextPaint _namePaint = TextPaint(
    style: const TextStyle(
        color: Color(0xFFFFFFFF), fontSize: 14, fontWeight: FontWeight.bold),
  );

  @override
  void update(double dt) {
    super.update(dt);
    tickCooldown(dt);
    if (isDead) {
      respawnIn -= dt;
      if (respawnIn <= 0) {
        hp = maxHp;
        position.setFrom(spawnPoint);
      }
      return;
    }
    // Regenerasi cepat di dalam base.
    if (position.distanceTo(spawnPoint) < 260) {
      hp = min(maxHp, hp + maxHp * 0.08 * dt);
    }
    think(dt);
    position.clamp(
        Vector2.all(radius), Vector2.all(MapConfig.size - radius));
  }

  /// Perilaku pemain: gerak via joystick, auto-attack saat diam.
  void think(double dt) {
    final j = game.joystick;
    if (!j.delta.isZero()) {
      final dir = j.relativeDelta;
      position.add(dir * moveSpeed * dt);
      facing.setFrom(dir.normalized());
    } else {
      manualAttack();
    }
  }

  /// Dipanggil tombol ATK: serang target terdekat dalam jangkauan.
  bool manualAttack() {
    final t = nearestEnemy(attackRange, prefer: (u) => u is HeroUnit);
    if (t == null) return false;
    facing.setFrom((t.position - position).normalized());
    return tryAttack(t);
  }

  void moveHeroToward(Vector2 target, double dt) {
    final diff = target - position;
    if (diff.length > 4) facing.setFrom(diff.normalized());
    moveToward(target, dt, moveSpeed);
  }

  @override
  void onDeath() {
    respawnIn = 5; // detik, nanti dikonfigurasi per level
  }

  @override
  void renderBody(Canvas canvas) {
    final c = Offset(radius, radius);
    canvas.drawCircle(c, radius, Paint()..color = team.color);
    canvas.drawCircle(
        c,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = isPlayer ? 6 : 4
          ..color =
              isPlayer ? const Color(0xFFFFD166) : const Color(0xFFFFFFFF));
    canvas.drawLine(
        c,
        c + Offset(facing.x, facing.y) * radius,
        Paint()
          ..strokeWidth = 5
          ..color = const Color(0xFFFFFFFF));
    _namePaint.render(canvas, heroName, Vector2(radius, radius * 2 + 4),
        anchor: Anchor.topCenter);
  }
}

/// Bot lawan sederhana: kejar hero terdekat, mundur saat HP rendah.
class BotHero extends HeroUnit {
  BotHero({
    required super.team,
    required super.position,
    required super.heroName,
  }) : _patrol = MapConfig.center + Vector2(300, -300);

  final Vector2 _patrol;

  @override
  void think(double dt) {
    if (hp < maxHp * 0.3) {
      moveHeroToward(spawnPoint, dt);
      return;
    }
    final target = nearestEnemy(650, prefer: (u) => u is HeroUnit);
    if (target != null) {
      final d = distanceToEdge(target);
      if (d > attackRange * 0.9) {
        moveHeroToward(target.position, dt);
      }
      if (d <= attackRange) {
        facing.setFrom((target.position - position).normalized());
        tryAttack(target);
      }
    } else {
      moveHeroToward(_patrol, dt);
    }
  }
}
