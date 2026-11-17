import 'package:flutter/material.dart';

class CanvasPoint {
  final double x;
  final double y;
  final double pressure;

  const CanvasPoint({
    required this.x,
    required this.y,
    this.pressure = 1.0,
  });

  Offset toOffset() => Offset(x, y);

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'pressure': pressure,
      };

  factory CanvasPoint.fromJson(Map<String, dynamic> json) => CanvasPoint(
        x: (json['x'] as num).toDouble(),
        y: (json['y'] as num).toDouble(),
        pressure: (json['pressure'] as num?)?.toDouble() ?? 1.0,
      );

  CanvasPoint copyWith({
    double? x,
    double? y,
    double? pressure,
  }) {
    return CanvasPoint(
      x: x ?? this.x,
      y: y ?? this.y,
      pressure: pressure ?? this.pressure,
    );
  }

  CanvasPoint translate(double dx, double dy) {
    return CanvasPoint(
      x: x + dx,
      y: y + dy,
      pressure: pressure,
    );
  }

  CanvasPoint scale(double scaleFactor, Offset origin) {
    return CanvasPoint(
      x: origin.dx + (x - origin.dx) * scaleFactor,
      y: origin.dy + (y - origin.dy) * scaleFactor,
      pressure: pressure,
    );
  }
}
