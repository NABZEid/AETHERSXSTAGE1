import 'dart:ui';

import 'package:flame/components.dart';

import 'map_config.dart';

/// Menggambar peta 3 lane (EXP, Mid, Gold), sungai, jungle, semak, dan base.
class BattleMap extends PositionComponent {
  BattleMap() : super(size: Vector2.all(MapConfig.size), priority: -100);

  final Paint _grass = Paint()..color = const Color(0xFF1F4D2B);
  final Paint _jungle = Paint()..color = const Color(0xFF173B21);
  final Paint _river = Paint()
    ..color = const Color(0xFF2A6F9E)
    ..strokeWidth = 280
    ..strokeCap = StrokeCap.round;
  final Paint _lane = Paint()
    ..color = const Color(0xFF8C7A55)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 220
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round;
  final Paint _grid = Paint()
    ..color = const Color(0x14FFFFFF)
    ..strokeWidth = 2;
  final Paint _bush = Paint()..color = const Color(0xFF0E6B2C);
  final Paint _camp = Paint()..color = const Color(0xFFB07A2A);
  final Paint _border = Paint()
    ..color = const Color(0xFFFFD166)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 12;

  Path _path(List<Vector2> pts) {
    final p = Path()..moveTo(pts.first.x, pts.first.y);
    for (final v in pts.skip(1)) {
      p.lineTo(v.x, v.y);
    }
    return p;
  }

  @override
  void render(Canvas canvas) {
    const s = MapConfig.size;
    canvas.drawRect(const Rect.fromLTWH(0, 0, s, s), _grass);

    // Area jungle (di antara lane).
    canvas.drawPath(
        Path()
          ..moveTo(700, 3300)
          ..lineTo(700, 700)
          ..lineTo(1900, 1900)
          ..close(),
        _jungle);
    canvas.drawPath(
        Path()
          ..moveTo(3300, 700)
          ..lineTo(3300, 3300)
          ..lineTo(2100, 2100)
          ..close(),
        _jungle);

    for (double i = 0; i <= s; i += 200) {
      canvas.drawLine(Offset(i, 0), Offset(i, s), _grid);
      canvas.drawLine(Offset(0, i), Offset(s, i), _grid);
    }

    // Sungai diagonal (memotong mid lane di tengah).
    canvas.drawLine(
        const Offset(150, 150), const Offset(s - 150, s - 150), _river);

    canvas.drawPath(_path(MapConfig.expLane), _lane);
    canvas.drawPath(_path(MapConfig.goldLane), _lane);
    canvas.drawPath(_path(MapConfig.midLane), _lane);

    canvas.drawCircle(MapConfig.blueBase.toOffset(), 260,
        Paint()..color = const Color(0x552E7BFF));
    canvas.drawCircle(MapConfig.redBase.toOffset(), 260,
        Paint()..color = const Color(0x55E5484D));

    for (final b in MapConfig.bushes) {
      canvas.drawOval(
          Rect.fromCenter(center: b.toOffset(), width: 220, height: 130),
          _bush);
    }
    for (final c in MapConfig.jungleCamps) {
      canvas.drawCircle(c.toOffset(), 45, _camp);
    }

    canvas.drawRect(const Rect.fromLTWH(0, 0, s, s), _border);
  }
}
