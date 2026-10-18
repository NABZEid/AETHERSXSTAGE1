import 'package:flame/components.dart';

import '../entities/team.dart';

/// Sistem koordinat dunia: 0..size pada sumbu X dan Y (Y ke bawah).
/// Peta simetris rotasi 180 derajat terhadap titik tengah.
class MapConfig {
  static const double size = 4000;

  static Vector2 mirror(Vector2 p) => Vector2(size - p.x, size - p.y);

  static final Vector2 blueBase = Vector2(350, 3650); // kiri bawah
  static final Vector2 redBase = Vector2(3650, 350); // kanan atas
  static final Vector2 center = Vector2(size / 2, size / 2);

  /// Waypoint tiap lane dari base biru ke base merah.
  static final List<Vector2> expLane = [
    Vector2(350, 3650), Vector2(350, 350), Vector2(3650, 350),
  ];
  static final List<Vector2> midLane = [
    Vector2(350, 3650), Vector2(2000, 2000), Vector2(3650, 350),
  ];
  static final List<Vector2> goldLane = [
    Vector2(350, 3650), Vector2(3650, 3650), Vector2(3650, 350),
  ];

  /// Jalur minion untuk tim tertentu (mid lane pada Tahap 1).
  static List<Vector2> midPathFor(Team team) => team == Team.blue
      ? midLane.map((e) => e.clone()).toList()
      : midLane.reversed.map((e) => e.clone()).toList();

  static final Vector2 blueTurretMid = Vector2(1100, 2900);
  static final Vector2 redTurretMid = mirror(blueTurretMid);

  static final List<Vector2> bushes = [
    Vector2(1200, 2300), Vector2(1700, 2650), Vector2(900, 1500),
    Vector2(2300, 3300), Vector2(1500, 1000),
    Vector2(2800, 1700), Vector2(2300, 1350), Vector2(3100, 2500),
    Vector2(1700, 700), Vector2(2500, 3000),
  ];

  static final List<Vector2> jungleCamps = [
    Vector2(1000, 2300), Vector2(1400, 3000), Vector2(1000, 1000),
    Vector2(3000, 1700), Vector2(2600, 1000), Vector2(3000, 3000),
  ];
}
