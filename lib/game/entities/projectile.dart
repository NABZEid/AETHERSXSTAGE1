import 'dart:ui';

import 'package:flame/components.dart';

import 'unit.dart';

/// Proyektil homing sederhana. Damage diterapkan saat mengenai target.
class Projectile extends PositionComponent {
  Projectile({
    required this.owner,
    required this.target,
    required this.damage,
    required Vector2 from,
    required this.color,
    this.speed = 720,
  }) : super(
          position: from.clone(),
          size: Vector2.all(12),
          anchor: Anchor.center,
          priority: 50,
        );

  final Unit owner;
  final Unit target;
  final double damage;
  final Color color;
  final double speed;

  @override
  void update(double dt) {
    super.update(dt);
    if (target.isDead || !target.isMounted) {
      removeFromParent();
      return;
    }
    final diff = target.position - position;
    final dist = diff.length;
    final step = speed * dt;
    if (dist <= step + target.radius * 0.6) {
      target.takeDamage(damage);
      removeFromParent();
    } else {
      position.add(diff / dist * step);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(const Offset(6, 6), 6, Paint()..color = color);
    canvas.drawCircle(
        const Offset(6, 6), 3, Paint()..color = const Color(0xFFFFFFFF));
  }
}
