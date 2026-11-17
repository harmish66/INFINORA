import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'canvas_point.dart';
import 'canvas_tool.dart';

abstract class CanvasObject {
  final String id;
  final String layerId;
  final int orderIndex;
  final double opacity;
  final double rotation; // in radians

  const CanvasObject({
    required this.id,
    required this.layerId,
    required this.orderIndex,
    this.opacity = 1.0,
    this.rotation = 0.0,
  });

  Rect get boundingBox;

  bool hitTest(Offset point, {double padding = 8.0});

  CanvasObject copyWith();

  CanvasObject translate(Offset delta);

  CanvasObject scale(double scaleFactor, Offset origin);

  CanvasObject rotate(double angleDelta, Offset origin);

  CanvasObject withOrderIndex(int newOrderIndex);

  Map<String, dynamic> toJson();

  static CanvasObject fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'stroke':
        return StrokeCanvasObject.fromJson(json);
      case 'shape':
        return ShapeCanvasObject.fromJson(json);
      case 'text':
        return TextCanvasObject.fromJson(json);
      case 'image':
        return ImageCanvasObject.fromJson(json);
      case 'sticker':
        return StickerCanvasObject.fromJson(json);
      default:
        throw UnsupportedError('Unknown CanvasObject type: $type');
    }
  }
}

class StrokeCanvasObject extends CanvasObject {
  final CanvasTool tool;
  final List<CanvasPoint> points;
  final Color color;
  final double strokeWidth;
  final bool isSmoothed;

  const StrokeCanvasObject({
    required super.id,
    required super.layerId,
    required super.orderIndex,
    super.opacity = 1.0,
    super.rotation = 0.0,
    required this.tool,
    required this.points,
    required this.color,
    required this.strokeWidth,
    this.isSmoothed = true,
  });

  @override
  Rect get boundingBox {
    if (points.isEmpty) return Rect.zero;
    double minX = points.first.x;
    double maxX = points.first.x;
    double minY = points.first.y;
    double maxY = points.first.y;

    for (final p in points) {
      if (p.x < minX) minX = p.x;
      if (p.x > maxX) maxX = p.x;
      if (p.y < minY) minY = p.y;
      if (p.y > maxY) maxY = p.y;
    }

    final pad = strokeWidth / 2;
    return Rect.fromLTRB(minX - pad, minY - pad, maxX + pad, maxY + pad);
  }

  @override
  bool hitTest(Offset point, {double padding = 8.0}) {
    final threshold = (strokeWidth / 2 + padding);
    final thresholdSq = threshold * threshold;

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i].toOffset();
      final p2 = points[i + 1].toOffset();
      final distSq = _distanceToSegmentSquared(point, p1, p2);
      if (distSq <= thresholdSq) {
        return true;
      }
    }
    return false;
  }

  double _distanceToSegmentSquared(Offset p, Offset v, Offset w) {
    final l2 = (v - w).distanceSquared;
    if (l2 == 0) return (p - v).distanceSquared;
    final t = ((p.dx - v.dx) * (w.dx - v.dx) + (p.dy - v.dy) * (w.dy - v.dy)) / l2;
    final clampedT = t.clamp(0.0, 1.0);
    final projection = Offset(v.dx + clampedT * (w.dx - v.dx), v.dy + clampedT * (w.dy - v.dy));
    return (p - projection).distanceSquared;
  }

  @override
  StrokeCanvasObject copyWith({
    String? id,
    String? layerId,
    int? orderIndex,
    double? opacity,
    double? rotation,
    CanvasTool? tool,
    List<CanvasPoint>? points,
    Color? color,
    double? strokeWidth,
    bool? isSmoothed,
  }) {
    return StrokeCanvasObject(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      orderIndex: orderIndex ?? this.orderIndex,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      tool: tool ?? this.tool,
      points: points ?? List.from(this.points),
      color: color ?? this.color,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isSmoothed: isSmoothed ?? this.isSmoothed,
    );
  }

  @override
  StrokeCanvasObject withOrderIndex(int newOrderIndex) {
    return copyWith(orderIndex: newOrderIndex);
  }

  @override
  StrokeCanvasObject translate(Offset delta) {
    final newPoints = points.map((p) => p.translate(delta.dx, delta.dy)).toList();
    return copyWith(points: newPoints);
  }

  @override
  StrokeCanvasObject scale(double scaleFactor, Offset origin) {
    final newPoints = points.map((p) => p.scale(scaleFactor, origin)).toList();
    return copyWith(
      points: newPoints,
      strokeWidth: strokeWidth * scaleFactor,
    );
  }

  @override
  StrokeCanvasObject rotate(double angleDelta, Offset origin) {
    final cosA = math.cos(angleDelta);
    final sinA = math.sin(angleDelta);
    final newPoints = points.map((p) {
      final dx = p.x - origin.dx;
      final dy = p.y - origin.dy;
      return CanvasPoint(
        x: origin.dx + dx * cosA - dy * sinA,
        y: origin.dy + dx * sinA + dy * cosA,
        pressure: p.pressure,
      );
    }).toList();
    return copyWith(
      points: newPoints,
      rotation: rotation + angleDelta,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'stroke',
        'id': id,
        'layerId': layerId,
        'orderIndex': orderIndex,
        'opacity': opacity,
        'rotation': rotation,
        'tool': tool.name,
        'color': color.toARGB32(),
        'strokeWidth': strokeWidth,
        'isSmoothed': isSmoothed,
        'points': points.map((p) => p.toJson()).toList(),
      };

  factory StrokeCanvasObject.fromJson(Map<String, dynamic> json) {
    return StrokeCanvasObject(
      id: json['id'] as String,
      layerId: json['layerId'] as String,
      orderIndex: json['orderIndex'] as int,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      tool: CanvasTool.values.firstWhere(
        (e) => e.name == json['tool'],
        orElse: () => CanvasTool.pen,
      ),
      color: Color(json['color'] as int),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      isSmoothed: json['isSmoothed'] as bool? ?? true,
      points: (json['points'] as List)
          .map((p) => CanvasPoint.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ShapeCanvasObject extends CanvasObject {
  final CanvasTool shapeType;
  final Rect rect;
  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;
  final bool isFilled;
  final int sides; // for polygon

  const ShapeCanvasObject({
    required super.id,
    required super.layerId,
    required super.orderIndex,
    super.opacity = 1.0,
    super.rotation = 0.0,
    required this.shapeType,
    required this.rect,
    required this.strokeColor,
    required this.fillColor,
    required this.strokeWidth,
    this.isFilled = false,
    this.sides = 5,
  });

  @override
  Rect get boundingBox {
    final pad = strokeWidth / 2;
    return rect.inflate(pad);
  }

  @override
  bool hitTest(Offset point, {double padding = 8.0}) {
    final expanded = boundingBox.inflate(padding);
    return expanded.contains(point);
  }

  @override
  ShapeCanvasObject copyWith({
    String? id,
    String? layerId,
    int? orderIndex,
    double? opacity,
    double? rotation,
    CanvasTool? shapeType,
    Rect? rect,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    bool? isFilled,
    int? sides,
  }) {
    return ShapeCanvasObject(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      orderIndex: orderIndex ?? this.orderIndex,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      shapeType: shapeType ?? this.shapeType,
      rect: rect ?? this.rect,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isFilled: isFilled ?? this.isFilled,
      sides: sides ?? this.sides,
    );
  }

  @override
  ShapeCanvasObject withOrderIndex(int newOrderIndex) {
    return copyWith(orderIndex: newOrderIndex);
  }

  @override
  ShapeCanvasObject translate(Offset delta) {
    return copyWith(rect: rect.shift(delta));
  }

  @override
  ShapeCanvasObject scale(double scaleFactor, Offset origin) {
    final newLeft = origin.dx + (rect.left - origin.dx) * scaleFactor;
    final newTop = origin.dy + (rect.top - origin.dy) * scaleFactor;
    final newWidth = rect.width * scaleFactor;
    final newHeight = rect.height * scaleFactor;
    return copyWith(
      rect: Rect.fromLTWH(newLeft, newTop, newWidth, newHeight),
      strokeWidth: strokeWidth * scaleFactor,
    );
  }

  @override
  ShapeCanvasObject rotate(double angleDelta, Offset origin) {
    return copyWith(rotation: rotation + angleDelta);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'shape',
        'id': id,
        'layerId': layerId,
        'orderIndex': orderIndex,
        'opacity': opacity,
        'rotation': rotation,
        'shapeType': shapeType.name,
        'left': rect.left,
        'top': rect.top,
        'width': rect.width,
        'height': rect.height,
        'strokeColor': strokeColor.toARGB32(),
        'fillColor': fillColor.toARGB32(),
        'strokeWidth': strokeWidth,
        'isFilled': isFilled,
        'sides': sides,
      };

  factory ShapeCanvasObject.fromJson(Map<String, dynamic> json) {
    return ShapeCanvasObject(
      id: json['id'] as String,
      layerId: json['layerId'] as String,
      orderIndex: json['orderIndex'] as int,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      shapeType: CanvasTool.values.firstWhere(
        (e) => e.name == json['shapeType'],
        orElse: () => CanvasTool.rectangle,
      ),
      rect: Rect.fromLTWH(
        (json['left'] as num).toDouble(),
        (json['top'] as num).toDouble(),
        (json['width'] as num).toDouble(),
        (json['height'] as num).toDouble(),
      ),
      strokeColor: Color(json['strokeColor'] as int),
      fillColor: Color(json['fillColor'] as int),
      strokeWidth: (json['strokeWidth'] as num).toDouble(),
      isFilled: json['isFilled'] as bool? ?? false,
      sides: json['sides'] as int? ?? 5,
    );
  }
}

class TextCanvasObject extends CanvasObject {
  final String text;
  final Offset position;
  final double fontSize;
  final String fontFamily;
  final Color color;
  final Color? backgroundColor;
  final bool isBold;
  final bool isItalic;
  final bool isUnderline;
  final TextAlign alignment;

  const TextCanvasObject({
    required super.id,
    required super.layerId,
    required super.orderIndex,
    super.opacity = 1.0,
    super.rotation = 0.0,
    required this.text,
    required this.position,
    this.fontSize = 20.0,
    this.fontFamily = 'Inter',
    required this.color,
    this.backgroundColor,
    this.isBold = false,
    this.isItalic = false,
    this.isUnderline = false,
    this.alignment = TextAlign.left,
  });

  @override
  Rect get boundingBox {
    // Estimate bounds based on characters and font size
    final lines = text.split('\n');
    int maxLen = 1;
    for (final line in lines) {
      if (line.length > maxLen) maxLen = line.length;
    }
    final width = math.max(60.0, maxLen * fontSize * 0.65);
    final height = math.max(30.0, lines.length * fontSize * 1.3);
    return Rect.fromLTWH(position.dx, position.dy, width, height);
  }

  @override
  bool hitTest(Offset point, {double padding = 8.0}) {
    return boundingBox.inflate(padding).contains(point);
  }

  @override
  TextCanvasObject copyWith({
    String? id,
    String? layerId,
    int? orderIndex,
    double? opacity,
    double? rotation,
    String? text,
    Offset? position,
    double? fontSize,
    String? fontFamily,
    Color? color,
    Color? backgroundColor,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlign? alignment,
  }) {
    return TextCanvasObject(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      orderIndex: orderIndex ?? this.orderIndex,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      text: text ?? this.text,
      position: position ?? this.position,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      isUnderline: isUnderline ?? this.isUnderline,
      alignment: alignment ?? this.alignment,
    );
  }

  @override
  TextCanvasObject withOrderIndex(int newOrderIndex) {
    return copyWith(orderIndex: newOrderIndex);
  }

  @override
  TextCanvasObject translate(Offset delta) {
    return copyWith(position: position + delta);
  }

  @override
  TextCanvasObject scale(double scaleFactor, Offset origin) {
    final newX = origin.dx + (position.dx - origin.dx) * scaleFactor;
    final newY = origin.dy + (position.dy - origin.dy) * scaleFactor;
    return copyWith(
      position: Offset(newX, newY),
      fontSize: fontSize * scaleFactor,
    );
  }

  @override
  TextCanvasObject rotate(double angleDelta, Offset origin) {
    return copyWith(rotation: rotation + angleDelta);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'text',
        'id': id,
        'layerId': layerId,
        'orderIndex': orderIndex,
        'opacity': opacity,
        'rotation': rotation,
        'text': text,
        'x': position.dx,
        'y': position.dy,
        'fontSize': fontSize,
        'fontFamily': fontFamily,
        'color': color.toARGB32(),
        'backgroundColor': backgroundColor?.toARGB32(),
        'isBold': isBold,
        'isItalic': isItalic,
        'isUnderline': isUnderline,
        'alignment': alignment.index,
      };

  factory TextCanvasObject.fromJson(Map<String, dynamic> json) {
    return TextCanvasObject(
      id: json['id'] as String,
      layerId: json['layerId'] as String,
      orderIndex: json['orderIndex'] as int,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      text: json['text'] as String,
      position: Offset(
        (json['x'] as num).toDouble(),
        (json['y'] as num).toDouble(),
      ),
      fontSize: (json['fontSize'] as num).toDouble(),
      fontFamily: json['fontFamily'] as String? ?? 'Inter',
      color: Color(json['color'] as int),
      backgroundColor: json['backgroundColor'] != null
          ? Color(json['backgroundColor'] as int)
          : null,
      isBold: json['isBold'] as bool? ?? false,
      isItalic: json['isItalic'] as bool? ?? false,
      isUnderline: json['isUnderline'] as bool? ?? false,
      alignment: TextAlign.values[json['alignment'] as int? ?? 0],
    );
  }
}

class ImageCanvasObject extends CanvasObject {
  final String imagePath;
  final Offset position;
  final double width;
  final double height;

  const ImageCanvasObject({
    required super.id,
    required super.layerId,
    required super.orderIndex,
    super.opacity = 1.0,
    super.rotation = 0.0,
    required this.imagePath,
    required this.position,
    required this.width,
    required this.height,
  });

  @override
  Rect get boundingBox => Rect.fromLTWH(position.dx, position.dy, width, height);

  @override
  bool hitTest(Offset point, {double padding = 8.0}) {
    return boundingBox.inflate(padding).contains(point);
  }

  @override
  ImageCanvasObject copyWith({
    String? id,
    String? layerId,
    int? orderIndex,
    double? opacity,
    double? rotation,
    String? imagePath,
    Offset? position,
    double? width,
    double? height,
  }) {
    return ImageCanvasObject(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      orderIndex: orderIndex ?? this.orderIndex,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      imagePath: imagePath ?? this.imagePath,
      position: position ?? this.position,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  ImageCanvasObject withOrderIndex(int newOrderIndex) {
    return copyWith(orderIndex: newOrderIndex);
  }

  @override
  ImageCanvasObject translate(Offset delta) {
    return copyWith(position: position + delta);
  }

  @override
  ImageCanvasObject scale(double scaleFactor, Offset origin) {
    final newX = origin.dx + (position.dx - origin.dx) * scaleFactor;
    final newY = origin.dy + (position.dy - origin.dy) * scaleFactor;
    return copyWith(
      position: Offset(newX, newY),
      width: width * scaleFactor,
      height: height * scaleFactor,
    );
  }

  @override
  ImageCanvasObject rotate(double angleDelta, Offset origin) {
    return copyWith(rotation: rotation + angleDelta);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'image',
        'id': id,
        'layerId': layerId,
        'orderIndex': orderIndex,
        'opacity': opacity,
        'rotation': rotation,
        'imagePath': imagePath,
        'x': position.dx,
        'y': position.dy,
        'width': width,
        'height': height,
      };

  factory ImageCanvasObject.fromJson(Map<String, dynamic> json) {
    return ImageCanvasObject(
      id: json['id'] as String,
      layerId: json['layerId'] as String,
      orderIndex: json['orderIndex'] as int,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['imagePath'] as String,
      position: Offset(
        (json['x'] as num).toDouble(),
        (json['y'] as num).toDouble(),
      ),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
    );
  }
}

class StickerCanvasObject extends CanvasObject {
  final String stickerKey; // vector shape name, e.g. 'star', 'heart', 'badge', 'check', etc.
  final Offset position;
  final double size;
  final Color color;

  const StickerCanvasObject({
    required super.id,
    required super.layerId,
    required super.orderIndex,
    super.opacity = 1.0,
    super.rotation = 0.0,
    required this.stickerKey,
    required this.position,
    required this.size,
    required this.color,
  });

  @override
  Rect get boundingBox => Rect.fromLTWH(position.dx, position.dy, size, size);

  @override
  bool hitTest(Offset point, {double padding = 8.0}) {
    return boundingBox.inflate(padding).contains(point);
  }

  @override
  StickerCanvasObject copyWith({
    String? id,
    String? layerId,
    int? orderIndex,
    double? opacity,
    double? rotation,
    String? stickerKey,
    Offset? position,
    double? size,
    Color? color,
  }) {
    return StickerCanvasObject(
      id: id ?? this.id,
      layerId: layerId ?? this.layerId,
      orderIndex: orderIndex ?? this.orderIndex,
      opacity: opacity ?? this.opacity,
      rotation: rotation ?? this.rotation,
      stickerKey: stickerKey ?? this.stickerKey,
      position: position ?? this.position,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  @override
  StickerCanvasObject withOrderIndex(int newOrderIndex) {
    return copyWith(orderIndex: newOrderIndex);
  }

  @override
  StickerCanvasObject translate(Offset delta) {
    return copyWith(position: position + delta);
  }

  @override
  StickerCanvasObject scale(double scaleFactor, Offset origin) {
    final newX = origin.dx + (position.dx - origin.dx) * scaleFactor;
    final newY = origin.dy + (position.dy - origin.dy) * scaleFactor;
    return copyWith(
      position: Offset(newX, newY),
      size: size * scaleFactor,
    );
  }

  @override
  StickerCanvasObject rotate(double angleDelta, Offset origin) {
    return copyWith(rotation: rotation + angleDelta);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': 'sticker',
        'id': id,
        'layerId': layerId,
        'orderIndex': orderIndex,
        'opacity': opacity,
        'rotation': rotation,
        'stickerKey': stickerKey,
        'x': position.dx,
        'y': position.dy,
        'size': size,
        'color': color.toARGB32(),
      };

  factory StickerCanvasObject.fromJson(Map<String, dynamic> json) {
    return StickerCanvasObject(
      id: json['id'] as String,
      layerId: json['layerId'] as String,
      orderIndex: json['orderIndex'] as int,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      stickerKey: json['stickerKey'] as String,
      position: Offset(
        (json['x'] as num).toDouble(),
        (json['y'] as num).toDouble(),
      ),
      size: (json['size'] as num).toDouble(),
      color: Color(json['color'] as int),
    );
  }
}
