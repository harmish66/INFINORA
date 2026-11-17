import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../domain/models/camera_state.dart';
import '../../domain/models/canvas_layer.dart';
import '../../domain/models/canvas_object.dart';
import '../../domain/models/canvas_tool.dart';

class InfiniteCanvasPainter extends CustomPainter {
  final CameraState camera;
  final Color backgroundColor;
  final double? canvasWidth;
  final double? canvasHeight;
  final bool showGrid;
  final String gridStyle;
  final List<CanvasLayer> layers;
  final List<CanvasObject> objects;
  final List<String> selectedObjectIds;
  final StrokeCanvasObject? activeStroke;
  final ShapeCanvasObject? activeShapePreview;
  final Rect? activeSelectionRect;
  final Map<String, ui.Image> loadedImages;

  InfiniteCanvasPainter({
    required this.camera,
    required this.backgroundColor,
    this.canvasWidth,
    this.canvasHeight,
    required this.showGrid,
    required this.gridStyle,
    required this.layers,
    required this.objects,
    required this.selectedObjectIds,
    this.activeStroke,
    this.activeShapePreview,
    this.activeSelectionRect,
    required this.loadedImages,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final visibleRect = camera.visibleWorldRect;

    // 1. Fill screen background
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = backgroundColor,
    );

    // Apply Camera Transform
    canvas.save();
    canvas.translate(camera.offset.dx, camera.offset.dy);
    canvas.scale(camera.zoom, camera.zoom);

    // 2. If bounded canvas, draw page outline and drop shadow
    if (canvasWidth != null && canvasHeight != null) {
      final pageRect = Rect.fromLTWH(0, 0, canvasWidth!, canvasHeight!);
      // Shadow
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawRect(pageRect.shift(const Offset(0, 8)), shadowPaint);

      // Page surface
      canvas.drawRect(pageRect, Paint()..color = backgroundColor);
      canvas.drawRect(
        pageRect,
        Paint()
          ..color = const Color(0xFFE5E7F0)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0 / camera.zoom,
      );
    }

    // 3. Draw Grid
    if (showGrid) {
      _drawGrid(canvas, visibleRect);
    }

    // 4. Group objects by layer
    final sortedLayers = List<CanvasLayer>.from(layers)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (final layer in sortedLayers) {
      if (!layer.isVisible) continue;

      final layerObjects = objects.where((o) => o.layerId == layer.id).toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      if (layer.opacity < 1.0) {
        canvas.saveLayer(
          null,
          Paint()..color = Color.fromRGBO(0, 0, 0, layer.opacity),
        );
      }

      for (final obj in layerObjects) {
        // Viewport culling
        if (!visibleRect.overlaps(obj.boundingBox)) {
          continue;
        }
        _drawCanvasObject(canvas, obj);
      }

      if (layer.opacity < 1.0) {
        canvas.restore();
      }
    }

    // 5. Draw active stroke (while drawing)
    if (activeStroke != null) {
      _drawStroke(canvas, activeStroke!);
    }

    // 6. Draw active shape preview
    if (activeShapePreview != null) {
      _drawShape(canvas, activeShapePreview!);
    }

    // 7. Draw selection bounds and handles
    _drawSelection(canvas);

    // 8. Draw active marquee selection box
    if (activeSelectionRect != null) {
      final marqueePaint = Paint()
        ..color = const Color(0xFF6558F5).withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      canvas.drawRect(activeSelectionRect!, marqueePaint);

      final borderPaint = Paint()
        ..color = const Color(0xFF6558F5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 / camera.zoom;
      canvas.drawRect(activeSelectionRect!, borderPaint);
    }

    canvas.restore();
  }

  void _drawGrid(Canvas canvas, Rect visibleRect) {
    final double baseStep = 40.0;
    // Adaptive step based on zoom
    double step = baseStep;
    if (camera.zoom < 0.2) {
      step = baseStep * 8;
    } else if (camera.zoom < 0.5) {
      step = baseStep * 4;
    } else if (camera.zoom < 1.0) {
      step = baseStep * 2;
    } else if (camera.zoom > 5.0) {
      step = baseStep / 2;
    }

    final double startX = (visibleRect.left / step).floor() * step;
    final double endX = (visibleRect.right / step).ceil() * step;
    final double startY = (visibleRect.top / step).floor() * step;
    final double endY = (visibleRect.bottom / step).ceil() * step;

    final gridColor = (backgroundColor.computeLuminance() > 0.5)
        ? const Color(0xFF191A2E).withValues(alpha: 0.08)
        : const Color(0xFFF5F5FA).withValues(alpha: 0.08);

    final linePaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0 / camera.zoom
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = gridColor.withValues(alpha: gridColor.a * 1.8)
      ..style = PaintingStyle.fill;

    if (gridStyle == 'dots') {
      final radius = math.max(1.0, 1.5 / camera.zoom);
      for (double x = startX; x <= endX; x += step) {
        for (double y = startY; y <= endY; y += step) {
          canvas.drawCircle(Offset(x, y), radius, dotPaint);
        }
      }
    } else if (gridStyle == 'lines') {
      for (double x = startX; x <= endX; x += step) {
        canvas.drawLine(Offset(x, startY), Offset(x, endY), linePaint);
      }
      for (double y = startY; y <= endY; y += step) {
        canvas.drawLine(Offset(startX, y), Offset(endX, y), linePaint);
      }
    } else if (gridStyle == 'cross') {
      final crossSize = 4.0 / camera.zoom;
      for (double x = startX; x <= endX; x += step) {
        for (double y = startY; y <= endY; y += step) {
          canvas.drawLine(Offset(x - crossSize, y), Offset(x + crossSize, y), linePaint);
          canvas.drawLine(Offset(x, y - crossSize), Offset(x, y + crossSize), linePaint);
        }
      }
    } else if (gridStyle == 'isometric') {
      // 30-degree isometric grid lines
      final isoStep = step * 1.5;
      for (double x = startX - (endY - startY); x <= endX + (endY - startY); x += isoStep) {
        canvas.drawLine(Offset(x, startY), Offset(x + (endY - startY) * 0.577, endY), linePaint);
        canvas.drawLine(Offset(x, startY), Offset(x - (endY - startY) * 0.577, endY), linePaint);
      }
      for (double y = startY; y <= endY; y += step) {
        canvas.drawLine(Offset(startX, y), Offset(endX, y), linePaint);
      }
    }
  }

  void _drawCanvasObject(Canvas canvas, CanvasObject obj) {
    if (obj is StrokeCanvasObject) {
      _drawStroke(canvas, obj);
    } else if (obj is ShapeCanvasObject) {
      _drawShape(canvas, obj);
    } else if (obj is TextCanvasObject) {
      _drawText(canvas, obj);
    } else if (obj is ImageCanvasObject) {
      _drawImage(canvas, obj);
    } else if (obj is StickerCanvasObject) {
      _drawSticker(canvas, obj);
    }
  }

  void _drawStroke(Canvas canvas, StrokeCanvasObject stroke) {
    if (stroke.points.length < 2) {
      if (stroke.points.isNotEmpty) {
        final p = stroke.points.first;
        final dotPaint = Paint()
          ..color = stroke.color.withValues(alpha: stroke.color.a * stroke.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(p.toOffset(), stroke.strokeWidth / 2, dotPaint);
      }
      return;
    }

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (stroke.tool) {
      case CanvasTool.highlighter:
        paint.color = stroke.color.withValues(alpha: stroke.color.a * stroke.opacity * 0.4);
        paint.strokeWidth = stroke.strokeWidth * 2.5;
        paint.strokeCap = StrokeCap.square;
        paint.blendMode = BlendMode.multiply;
        break;
      case CanvasTool.marker:
        paint.color = stroke.color.withValues(alpha: stroke.color.a * stroke.opacity * 0.85);
        paint.strokeWidth = stroke.strokeWidth * 1.5;
        paint.strokeCap = StrokeCap.round;
        break;
      case CanvasTool.pencil:
        paint.color = stroke.color.withValues(alpha: stroke.color.a * stroke.opacity * 0.7);
        paint.strokeWidth = stroke.strokeWidth * 0.8;
        break;
      case CanvasTool.laser:
        // Glow effect
        final glowPaint = Paint()
          ..color = stroke.color.withValues(alpha: 0.4)
          ..strokeWidth = stroke.strokeWidth * 3.0
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        final glowPath = Path();
        glowPath.moveTo(stroke.points.first.x, stroke.points.first.y);
        for (int i = 1; i < stroke.points.length; i++) {
          glowPath.lineTo(stroke.points[i].x, stroke.points[i].y);
        }
        canvas.drawPath(glowPath, glowPaint);
        paint.color = Colors.white;
        paint.strokeWidth = stroke.strokeWidth;
        break;
      default:
        paint.color = stroke.color.withValues(alpha: stroke.color.a * stroke.opacity);
        paint.strokeWidth = stroke.strokeWidth;
        break;
    }

    final path = Path();
    path.moveTo(stroke.points.first.x, stroke.points.first.y);

    if (stroke.isSmoothed && stroke.points.length > 2) {
      for (int i = 1; i < stroke.points.length - 1; i++) {
        final p0 = stroke.points[i];
        final p1 = stroke.points[i + 1];
        final midX = (p0.x + p1.x) / 2;
        final midY = (p0.y + p1.y) / 2;
        path.quadraticBezierTo(p0.x, p0.y, midX, midY);
      }
      path.lineTo(stroke.points.last.x, stroke.points.last.y);
    } else {
      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].x, stroke.points[i].y);
      }
    }

    canvas.drawPath(path, paint);
  }

  void _drawShape(Canvas canvas, ShapeCanvasObject shape) {
    canvas.save();
    if (shape.rotation != 0) {
      canvas.translate(shape.rect.center.dx, shape.rect.center.dy);
      canvas.rotate(shape.rotation);
      canvas.translate(-shape.rect.center.dx, -shape.rect.center.dy);
    }

    final fillPaint = Paint()
      ..color = shape.fillColor.withValues(alpha: shape.fillColor.a * shape.opacity)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = shape.strokeColor.withValues(alpha: shape.strokeColor.a * shape.opacity)
      ..strokeWidth = shape.strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final r = shape.rect;

    switch (shape.shapeType) {
      case CanvasTool.rectangle:
        final rrect = RRect.fromRectAndRadius(r, const Radius.circular(8));
        if (shape.isFilled && shape.fillColor.a > 0) {
          canvas.drawRRect(rrect, fillPaint);
        }
        if (shape.strokeWidth > 0 && shape.strokeColor.a > 0) {
          canvas.drawRRect(rrect, strokePaint);
        }
        break;

      case CanvasTool.circle:
        if (shape.isFilled && shape.fillColor.a > 0) {
          canvas.drawOval(r, fillPaint);
        }
        if (shape.strokeWidth > 0 && shape.strokeColor.a > 0) {
          canvas.drawOval(r, strokePaint);
        }
        break;

      case CanvasTool.line:
        canvas.drawLine(r.topLeft, r.bottomRight, strokePaint);
        break;

      case CanvasTool.arrow:
        canvas.drawLine(r.topLeft, r.bottomRight, strokePaint);
        // Draw arrowhead
        final angle = math.atan2(r.bottomRight.dy - r.topLeft.dy, r.bottomRight.dx - r.topLeft.dx);
        final arrowLength = math.max(12.0, shape.strokeWidth * 3.5);
        final arrowAngle = math.pi / 6;

        final p1 = Offset(
          r.bottomRight.dx - arrowLength * math.cos(angle - arrowAngle),
          r.bottomRight.dy - arrowLength * math.sin(angle - arrowAngle),
        );
        final p2 = Offset(
          r.bottomRight.dx - arrowLength * math.cos(angle + arrowAngle),
          r.bottomRight.dy - arrowLength * math.sin(angle + arrowAngle),
        );

        final arrowHeadPath = Path()
          ..moveTo(r.bottomRight.dx, r.bottomRight.dy)
          ..lineTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..close();

        canvas.drawPath(arrowHeadPath, Paint()..color = shape.strokeColor..style = PaintingStyle.fill);
        break;

      case CanvasTool.triangle:
        final path = Path()
          ..moveTo(r.center.dx, r.top)
          ..lineTo(r.right, r.bottom)
          ..lineTo(r.left, r.bottom)
          ..close();
        if (shape.isFilled && shape.fillColor.a > 0) {
          canvas.drawPath(path, fillPaint);
        }
        if (shape.strokeWidth > 0 && shape.strokeColor.a > 0) {
          canvas.drawPath(path, strokePaint);
        }
        break;

      case CanvasTool.star:
        final path = _createStarPath(r, 5);
        if (shape.isFilled && shape.fillColor.a > 0) {
          canvas.drawPath(path, fillPaint);
        }
        if (shape.strokeWidth > 0 && shape.strokeColor.a > 0) {
          canvas.drawPath(path, strokePaint);
        }
        break;

      case CanvasTool.polygon:
        final path = _createPolygonPath(r, shape.sides);
        if (shape.isFilled && shape.fillColor.a > 0) {
          canvas.drawPath(path, fillPaint);
        }
        if (shape.strokeWidth > 0 && shape.strokeColor.a > 0) {
          canvas.drawPath(path, strokePaint);
        }
        break;

      default:
        break;
    }

    canvas.restore();
  }

  Path _createStarPath(Rect rect, int points) {
    final path = Path();
    final center = rect.center;
    final outerRadius = math.min(rect.width, rect.height) / 2;
    final innerRadius = outerRadius * 0.45;
    final step = math.pi / points;
    double angle = -math.pi / 2;

    for (int i = 0; i < points * 2; i++) {
      final r = (i.isEven) ? outerRadius : innerRadius;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    return path;
  }

  Path _createPolygonPath(Rect rect, int sides) {
    final path = Path();
    final center = rect.center;
    final radius = math.min(rect.width, rect.height) / 2;
    final step = (math.pi * 2) / sides;
    double angle = -math.pi / 2;

    for (int i = 0; i < sides; i++) {
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      angle += step;
    }
    path.close();
    return path;
  }

  void _drawText(Canvas canvas, TextCanvasObject textObj) {
    canvas.save();
    if (textObj.rotation != 0) {
      final center = textObj.boundingBox.center;
      canvas.translate(center.dx, center.dy);
      canvas.rotate(textObj.rotation);
      canvas.translate(-center.dx, -center.dy);
    }

    final textSpan = TextSpan(
      text: textObj.text,
      style: TextStyle(
        fontFamily: textObj.fontFamily,
        fontSize: textObj.fontSize,
        fontWeight: textObj.isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: textObj.isItalic ? FontStyle.italic : FontStyle.normal,
        decoration: textObj.isUnderline ? TextDecoration.underline : TextDecoration.none,
        color: textObj.color.withValues(alpha: textObj.color.a * textObj.opacity),
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: textObj.alignment,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    if (textObj.backgroundColor != null && textObj.backgroundColor!.a > 0) {
      final bgRect = Rect.fromLTWH(
        textObj.position.dx - 4,
        textObj.position.dy - 2,
        textPainter.width + 8,
        textPainter.height + 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(bgRect, const Radius.circular(6)),
        Paint()..color = textObj.backgroundColor!,
      );
    }

    textPainter.paint(canvas, textObj.position);
    canvas.restore();
  }

  void _drawImage(Canvas canvas, ImageCanvasObject imageObj) {
    final image = loadedImages[imageObj.imagePath];
    final rect = Rect.fromLTWH(
      imageObj.position.dx,
      imageObj.position.dy,
      imageObj.width,
      imageObj.height,
    );

    canvas.save();
    if (imageObj.rotation != 0) {
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(imageObj.rotation);
      canvas.translate(-rect.center.dx, -rect.center.dy);
    }

    if (image != null) {
      final src = Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
      final paint = Paint()
        ..filterQuality = FilterQuality.medium
        ..color = Colors.white.withValues(alpha: imageObj.opacity);
      canvas.drawImageRect(image, src, rect, paint);
    } else {
      // Placeholder while image is loading or if missing
      final bgPaint = Paint()
        ..color = const Color(0xFFEEF1F8)
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = const Color(0xFFE5E7F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), bgPaint);
      canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(8)), borderPaint);

      final iconPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(Icons.image_outlined.codePoint),
          style: TextStyle(
            fontSize: 32,
            fontFamily: Icons.image_outlined.fontFamily,
            package: Icons.image_outlined.fontPackage,
            color: const Color(0xFF777B91),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      iconPainter.paint(
        canvas,
        rect.center - Offset(iconPainter.width / 2, iconPainter.height / 2),
      );
    }

    canvas.restore();
  }

  void _drawSticker(Canvas canvas, StickerCanvasObject stickerObj) {
    final rect = Rect.fromLTWH(
      stickerObj.position.dx,
      stickerObj.position.dy,
      stickerObj.size,
      stickerObj.size,
    );

    canvas.save();
    if (stickerObj.rotation != 0) {
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(stickerObj.rotation);
      canvas.translate(-rect.center.dx, -rect.center.dy);
    }

    IconData icon;
    switch (stickerObj.stickerKey) {
      case 'heart':
        icon = Icons.favorite_rounded;
        break;
      case 'star':
        icon = Icons.star_rounded;
        break;
      case 'badge':
        icon = Icons.verified_rounded;
        break;
      case 'check':
        icon = Icons.check_circle_rounded;
        break;
      case 'flash':
        icon = Icons.bolt_rounded;
        break;
      case 'fire':
        icon = Icons.local_fire_department_rounded;
        break;
      case 'bookmark':
        icon = Icons.bookmark_rounded;
        break;
      default:
        icon = Icons.emoji_emotions_rounded;
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: stickerObj.size,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: stickerObj.color.withValues(alpha: stickerObj.color.a * stickerObj.opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, rect.topLeft);
    canvas.restore();
  }

  void _drawSelection(Canvas canvas) {
    if (selectedObjectIds.isEmpty) return;

    final selectedObjects = objects.where((o) => selectedObjectIds.contains(o.id)).toList();
    if (selectedObjects.isEmpty) return;

    // Calculate union bounding box
    Rect unionBounds = selectedObjects.first.boundingBox;
    for (int i = 1; i < selectedObjects.length; i++) {
      unionBounds = unionBounds.expandToInclude(selectedObjects[i].boundingBox);
    }

    final paddedBounds = unionBounds.inflate(8.0);

    // Bounding border
    final borderPaint = Paint()
      ..color = const Color(0xFF6558F5)
      ..strokeWidth = 1.5 / camera.zoom
      ..style = PaintingStyle.stroke;
    canvas.drawRect(paddedBounds, borderPaint);

    // Transform corner handles
    final handleRadius = 5.0 / camera.zoom;
    final handleFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final handleBorder = Paint()
      ..color = const Color(0xFF6558F5)
      ..strokeWidth = 1.5 / camera.zoom
      ..style = PaintingStyle.stroke;

    final corners = [
      paddedBounds.topLeft,
      paddedBounds.topRight,
      paddedBounds.bottomLeft,
      paddedBounds.bottomRight,
      paddedBounds.topCenter,
      paddedBounds.bottomCenter,
      paddedBounds.centerLeft,
      paddedBounds.centerRight,
    ];

    for (final c in corners) {
      canvas.drawCircle(c, handleRadius, handleFill);
      canvas.drawCircle(c, handleRadius, handleBorder);
    }

    // Rotation handle
    final rotHandle = Offset(paddedBounds.topCenter.dx, paddedBounds.topCenter.dy - 24 / camera.zoom);
    canvas.drawLine(paddedBounds.topCenter, rotHandle, borderPaint);
    canvas.drawCircle(rotHandle, handleRadius * 1.2, handleFill);
    canvas.drawCircle(rotHandle, handleRadius * 1.2, handleBorder);
  }

  @override
  bool shouldRepaint(covariant InfiniteCanvasPainter oldDelegate) {
    return true; // Canvas interactive repainting
  }
}
