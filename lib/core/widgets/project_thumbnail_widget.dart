import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../features/canvas/domain/models/canvas_object.dart';
import '../../features/canvas/domain/models/canvas_tool.dart';
import '../../features/projects/domain/models/project_model.dart';

class ProjectThumbnailWidget extends StatelessWidget {
  final ProjectModel project;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const ProjectThumbnailWidget({
    super.key,
    required this.project,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Check cached thumbnail file
    if (project.thumbnailPath != null && File(project.thumbnailPath!).existsSync()) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.file(
          File(project.thumbnailPath!),
          width: width,
          height: height,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stack) => _buildFallbackThumbnail(isDark),
        ),
      );
    }

    // Render actual artwork objects from project
    if (project.objects.isNotEmpty) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: width,
          height: height,
          color: project.backgroundColor,
          child: CustomPaint(
            painter: _MiniCanvasThumbnailPainter(
              objects: project.objects,
              backgroundColor: project.backgroundColor,
            ),
          ),
        ),
      );
    }

    return _buildFallbackThumbnail(isDark);
  }

  Widget _buildFallbackThumbnail(bool isDark) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        ),
        child: CustomPaint(
          painter: _GridBackgroundPainter(isDark: isDark),
        ),
      ),
    );
  }
}

class _MiniCanvasThumbnailPainter extends CustomPainter {
  final List<CanvasObject> objects;
  final Color backgroundColor;

  _MiniCanvasThumbnailPainter({
    required this.objects,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (objects.isEmpty) return;

    // Calculate union bounds of objects
    Rect bounds = objects.first.boundingBox;
    for (int i = 1; i < objects.length; i++) {
      bounds = bounds.expandToInclude(objects[i].boundingBox);
    }

    // Protect against zero area
    if (bounds.width < 1) bounds = Rect.fromCenter(center: bounds.center, width: 100, height: bounds.height);
    if (bounds.height < 1) bounds = Rect.fromCenter(center: bounds.center, width: bounds.width, height: 100);

    final padded = bounds.inflate(math.max(bounds.width, bounds.height) * 0.15);
    final scaleX = size.width / padded.width;
    final scaleY = size.height / padded.height;
    final scale = math.min(scaleX, scaleY);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);
    canvas.translate(-padded.center.dx, -padded.center.dy);

    for (final obj in objects) {
      if (obj is StrokeCanvasObject) {
        if (obj.points.length < 2) continue;
        final paint = Paint()
          ..color = obj.color.withValues(alpha: obj.color.a * obj.opacity)
          ..strokeWidth = math.max(1.5, obj.strokeWidth)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        final path = Path();
        path.moveTo(obj.points.first.x, obj.points.first.y);
        for (int i = 1; i < obj.points.length; i++) {
          path.lineTo(obj.points[i].x, obj.points[i].y);
        }
        canvas.drawPath(path, paint);
      } else if (obj is ShapeCanvasObject) {
        final strokePaint = Paint()
          ..color = obj.strokeColor.withValues(alpha: obj.strokeColor.a * obj.opacity)
          ..strokeWidth = math.max(1.0, obj.strokeWidth)
          ..style = PaintingStyle.stroke;

        final fillPaint = Paint()
          ..color = obj.fillColor.withValues(alpha: obj.fillColor.a * obj.opacity)
          ..style = PaintingStyle.fill;

        if (obj.isFilled && obj.fillColor.a > 0) {
          if (obj.shapeType == CanvasTool.circle) {
            canvas.drawOval(obj.rect, fillPaint);
          } else {
            canvas.drawRect(obj.rect, fillPaint);
          }
        }
        if (obj.shapeType == CanvasTool.circle) {
          canvas.drawOval(obj.rect, strokePaint);
        } else {
          canvas.drawRect(obj.rect, strokePaint);
        }
      } else if (obj is TextCanvasObject) {
        final tp = TextPainter(
          text: TextSpan(
            text: obj.text,
            style: TextStyle(
              fontSize: math.max(10.0, obj.fontSize),
              color: obj.color,
              fontWeight: obj.isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
          maxLines: 1,
        )..layout();
        tp.paint(canvas, obj.position);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MiniCanvasThumbnailPainter oldDelegate) => false;
}

class _GridBackgroundPainter extends CustomPainter {
  final bool isDark;

  _GridBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle grid pattern
    final dotPaint = Paint()
      ..color = (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    for (double x = 12; x < size.width; x += 18) {
      for (double y = 12; y < size.height; y += 18) {
        canvas.drawCircle(Offset(x, y), 1.0, dotPaint);
      }
    }

    // Stylized artist icon badge
    final center = Offset(size.width / 2, size.height / 2);
    final aura = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 24, aura);

    final iconPaint = Paint()
      ..color = const Color(0xFF0284C7).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(center.dx - 12, center.dy + 8);
    path.quadraticBezierTo(center.dx, center.dy - 12, center.dx + 12, center.dy + 8);
    canvas.drawPath(path, iconPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
