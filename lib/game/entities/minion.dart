import 'dart:ui';

import 'package:flame/components.dart';

import 'team.dart';
import 'unit.dart';

/// Minion ringan yang berjalan mengikuti lane.
class Minion extends Unit {
  Minion({
    required Team team,
    required List<Vector2> path,
    double spawnOffset = 0,
  })  : _path = path,
        super(
          team: team,
          maxHp: 450,
          radius: 16,
          position: path.first + Vector2(spawnOffset, -spawnOffset),
          attackRange: 140,
          attackDamage: 28,
          attackInterval: 1.0,
          drawPriority: 2,
        );

  final List<Vector2> _path;
  int _next = 1;
  static const double speed = 150;

  @override
  void update(double dt) {
    super.update(dt);
    tickCooldown(dt);
    final target = nearestEnemy(220, prefer: (u) => u is Minion);
    if (target != null) {
      if (distanceToEdge(target) <= attackRange) {
        tryAttack(target);
      } else {
        moveToward(target.position, dt, speed);
      }
      return;
    }
    if (_next >= _path.length) {
      removeFromParent(); // sampai ujung lane (core menyusul di Tahap 2)
      return;
    }
    final wp = _path[_next];
    moveToward(wp, dt, speed);
    if (position.distanceTo(wp) < 12) _next++;
  }

  @override
  void renderBody(Canvas canvas) {
    final c = Offset(radius, radius);
    canvas.drawCircle(c, radius, Paint()..color = team.color.withAlpha(220));
    canvas.drawCircle(
        c,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0xFFFFFFFF));
  }
}
