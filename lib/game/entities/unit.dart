import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../nexora_game.dart';
import 'projectile.dart';
import 'team.dart';

/// Basis semua entitas bertarung: hero, minion, turret.
abstract class Unit extends PositionComponent with HasGameReference<NexoraGame> {
  Unit({
    required this.team,
    required this.maxHp,
    required this.radius,
    required Vector2 position,
    this.attackRange = 0,
    this.attackDamage = 0,
    this.attackInterval = 1,
    int drawPriority = 0,
  })  : hp = maxHp,
        super(
          position: position,
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
          priority: drawPriority,
        );

  final Team team;
  final double maxHp;
  final double radius;
  final double attackRange;
  final double attackDamage;
  final double attackInterval;
  double hp;
  double cooldown = 0;

  bool get isDead => hp <= 0;

  Iterable<Unit> get enemies => game.world.children
      .whereType<Unit>()
      .where((u) => u.team != team && !u.isDead);

  /// Musuh terdekat dalam [range]. [prefer] memberi prioritas target.
  Unit? nearestEnemy(double range, {bool Function(Unit)? prefer}) {
    Unit? best;
    var bestDist = double.infinity;
    var bestPreferred = false;
    for (final u in enemies) {
      final d = position.distanceTo(u.position) - u.radius;
      if (d > range) continue;
      final preferred = prefer?.call(u) ?? false;
      if (best == null ||
          (preferred && !bestPreferred) ||
          (preferred == bestPreferred && d < bestDist)) {
        best = u;
        bestDist = d;
        bestPreferred = preferred;
      }
    }
    return best;
  }

  double distanceToEdge(Unit other) =>
      position.distanceTo(other.position) - other.radius;

  void tickCooldown(double dt) {
    if (cooldown > 0) cooldown -= dt;
  }

  /// Menembak [target] jika cooldown siap. Mengembalikan true bila menembak.
  bool tryAttack(Unit target) {
    if (cooldown > 0 || isDead) return false;
    cooldown = attackInterval;
    game.world.add(Projectile(
      owner: this,
      target: target,
      damage: attackDamage,
      from: position,
      color: team.color,
    ));
    return true;
  }

  void moveToward(Vector2 target, double dt, double speed, {double stop = 4}) {
    final diff = target - position;
    final dist = diff.length;
    if (dist <= stop) return;
    final step = min(speed * dt, dist);
    position.add(diff / dist * step);
  }

  void takeDamage(double amount) {
    if (isDead) return;
    hp -= amount;
    if (hp <= 0) {
      hp = 0;
      onDeath();
    }
  }

  void onDeath() => removeFromParent();

  void renderBody(Canvas canvas);

  @override
  void render(Canvas canvas) {
    if (isDead) return;
    renderBody(canvas);
    final w = max(radius * 2, 50.0);
    final left = radius - w / 2;
    const top = -16.0;
    canvas.drawRect(Rect.fromLTWH(left, top, w, 8),
        Paint()..color = const Color(0xAA000000));
    canvas.drawRect(
        Rect.fromLTWH(left, top, w * (hp / maxHp).clamp(0.0, 1.0), 8),
        Paint()
          ..color = team == Team.blue
              ? const Color(0xFF3DDC84)
              : const Color(0xFFFF5C5C));
  }
}
