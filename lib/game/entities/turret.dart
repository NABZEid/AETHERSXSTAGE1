import 'dart:ui';

import 'package:flame/components.dart';

import 'minion.dart';
import 'team.dart';
import 'unit.dart';

/// Turret: menyerang minion lebih dulu, lalu hero.
class Turret extends Unit {
  Turret({required Team team, required Vector2 position})
      : super(
          team: team,
          maxHp: 3000,
          radius: 38,
          position: position,
          attackRange: 420,
          attackDamage: 150,
          attackInterval: 1.2,
          drawPriority: 1,
        );

  @override
  void update(double dt) {
    super.update(dt);
    tickCooldown(dt);
    final t = nearestEnemy(attackRange, prefer: (u) => u is Minion);
    if (t != null) tryAttack(t);
  }

  @override
  void renderBody(Canvas canvas) {
    final c = Offset(radius, radius);
    canvas.drawCircle(
        c,
        attackRange,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = team.color.withAlpha(70));
    final body =
        Rect.fromCenter(center: c, width: radius * 1.6, height: radius * 1.6);
    canvas.drawRRect(RRect.fromRectAndRadius(body, const Radius.circular(8)),
        Paint()..color = const Color(0xFF3B3F4A));
    canvas.drawCircle(c, radius * 0.45, Paint()..color = team.color);
    canvas.drawRRect(
        RRect.fromRectAndRadius(body, const Radius.circular(8)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..color = const Color(0xFFFFD166));
  }
}
