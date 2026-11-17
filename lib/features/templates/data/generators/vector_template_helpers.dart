import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../canvas/domain/models/canvas_object.dart';
import '../../../canvas/domain/models/canvas_point.dart';
import '../../../canvas/domain/models/canvas_tool.dart';

class VectorArtHelper {
  static ShapeCanvasObject rect({
    required String id,
    required String layerId,
    required int order,
    required Rect rect,
    required Color strokeColor,
    Color fillColor = Colors.transparent,
    double strokeWidth = 2.0,
    bool isFilled = false,
    double opacity = 1.0,
    double rotation = 0.0,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.rectangle,
      rect: rect,
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      isFilled: isFilled,
      opacity: opacity,
      rotation: rotation,
    );
  }

  static ShapeCanvasObject circle({
    required String id,
    required String layerId,
    required int order,
    required Offset center,
    required double radius,
    required Color strokeColor,
    Color fillColor = Colors.transparent,
    double strokeWidth = 2.0,
    bool isFilled = false,
    double opacity = 1.0,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.circle,
      rect: Rect.fromCircle(center: center, radius: radius),
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      isFilled: isFilled,
      opacity: opacity,
    );
  }

  static ShapeCanvasObject polygon({
    required String id,
    required String layerId,
    required int order,
    required Offset center,
    required double radius,
    required int sides,
    required Color strokeColor,
    Color fillColor = Colors.transparent,
    double strokeWidth = 2.0,
    bool isFilled = false,
    double rotation = 0.0,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.polygon,
      rect: Rect.fromCircle(center: center, radius: radius),
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      isFilled: isFilled,
      sides: sides,
      rotation: rotation,
    );
  }

  static ShapeCanvasObject star({
    required String id,
    required String layerId,
    required int order,
    required Offset center,
    required double radius,
    required Color strokeColor,
    Color fillColor = Colors.transparent,
    double strokeWidth = 2.0,
    bool isFilled = false,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.star,
      rect: Rect.fromCircle(center: center, radius: radius),
      strokeColor: strokeColor,
      fillColor: fillColor,
      strokeWidth: strokeWidth,
      isFilled: isFilled,
    );
  }

  static ShapeCanvasObject line({
    required String id,
    required String layerId,
    required int order,
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 2.0,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.line,
      rect: Rect.fromPoints(start, end),
      strokeColor: color,
      fillColor: Colors.transparent,
      strokeWidth: strokeWidth,
    );
  }

  static ShapeCanvasObject arrow({
    required String id,
    required String layerId,
    required int order,
    required Offset start,
    required Offset end,
    required Color color,
    double strokeWidth = 2.0,
  }) {
    return ShapeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      shapeType: CanvasTool.arrow,
      rect: Rect.fromPoints(start, end),
      strokeColor: color,
      fillColor: color,
      strokeWidth: strokeWidth,
    );
  }

  static TextCanvasObject text({
    required String id,
    required String layerId,
    required int order,
    required String text,
    required Offset position,
    double fontSize = 16.0,
    Color color = const Color(0xFF1E293B),
    bool isBold = false,
    bool isItalic = false,
  }) {
    return TextCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      text: text,
      position: position,
      fontSize: fontSize,
      color: color,
      isBold: isBold,
      isItalic: isItalic,
    );
  }

  static StrokeCanvasObject stroke({
    required String id,
    required String layerId,
    required int order,
    required List<Offset> points,
    required Color color,
    double strokeWidth = 2.0,
    CanvasTool tool = CanvasTool.pen,
    double opacity = 1.0,
  }) {
    return StrokeCanvasObject(
      id: id,
      layerId: layerId,
      orderIndex: order,
      tool: tool,
      points: points.map((p) => CanvasPoint(x: p.dx, y: p.dy)).toList(),
      color: color,
      strokeWidth: strokeWidth,
      opacity: opacity,
    );
  }

  static List<Offset> generateArcPoints({
    required Offset center,
    required double radius,
    required double startAngle,
    required double sweepAngle,
    int steps = 24,
  }) {
    final pts = <Offset>[];
    for (int i = 0; i <= steps; i++) {
      final a = startAngle + sweepAngle * (i / steps);
      pts.add(Offset(center.dx + radius * math.cos(a), center.dy + radius * math.sin(a)));
    }
    return pts;
  }

  static List<Offset> generatePetalPoints({
    required Offset center,
    required double angle,
    required double length,
    required double width,
  }) {
    final cosA = math.cos(angle);
    final sinA = math.sin(angle);
    final perpX = -sinA;
    final perpY = cosA;

    final tip = Offset(center.dx + length * cosA, center.dy + length * sinA);
    final midLeft = Offset(
      center.dx + length * 0.5 * cosA + width * perpX,
      center.dy + length * 0.5 * sinA + width * perpY,
    );
    final midRight = Offset(
      center.dx + length * 0.5 * cosA - width * perpX,
      center.dy + length * 0.5 * sinA - width * perpY,
    );

    return [center, midLeft, tip, midRight, center];
  }
}
