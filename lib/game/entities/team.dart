import 'dart:ui';

enum Team { blue, red }

extension TeamX on Team {
  Team get opponent => this == Team.blue ? Team.red : Team.blue;
  Color get color =>
      this == Team.blue ? const Color(0xFF2E7BFF) : const Color(0xFFE5484D);
}
