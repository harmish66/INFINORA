import 'package:flutter/material.dart';
import '../../domain/models/camera_state.dart';
import '../../domain/models/canvas_object.dart';

class MinimapPainter extends CustomPainter {
  final List<CanvasObject> objects;
  final CameraState camera;
  final Color backgroundColor;

  MinimapPainter({
    required this.objects,
    required this.camera,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = backgroundColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(8)),
      bgPaint,
    );

    // Calculate total artwork bounds
    Rect totalBounds = Rect.fromLTWH(-500, -500, 1000, 1000);
    if (objects.isNotEmpty) {
      totalBounds = objects.first.boundingBox;
      for (final obj in objects) {
        totalBounds = totalBounds.expandToInclude(obj.boundingBox);
      }
      totalBounds = totalBounds.inflate(100.0);
    }

    final visibleWorldRect = camera.visibleWorldRect;
    final combinedBounds = totalBounds.expandToInclude(visibleWorldRect);

    // Compute scale and translation to fit combinedBounds into minimap Size
    final scaleX = size.width / combinedBounds.width;
    final scaleY = size.height / combinedBounds.height;
    final scale = (scaleX < scaleY ? scaleX : scaleY) * 0.9;

    final offsetX = (size.width - combinedBounds.width * scale) / 2 - combinedBounds.left * scale;
    final offsetY = (size.height - combinedBounds.height * scale) / 2 - combinedBounds.top * scale;

    Offset worldToMinimap(Offset world) {
      return Offset(world.dx * scale + offsetX, world.dy * scale + offsetY);
    }

    Rect worldRectToMinimap(Rect r) {
      final tl = worldToMinimap(r.topLeft);
      final br = worldToMinimap(r.bottomRight);
      return Rect.fromPoints(tl, br);
    }

    // Draw objects simplified
    final objectPaint = Paint()
      ..color = const Color(0xFF6558F5).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    for (final obj in objects) {
      final r = worldRectToMinimap(obj.boundingBox);
      canvas.drawRect(r, objectPaint);
    }

    // Draw current viewport rectangle
    final viewportOnMinimap = worldRectToMinimap(visibleWorldRect);
    final vpFillPaint = Paint()
      ..color = const Color(0xFF26C6DA).withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    final vpBorderPaint = Paint()
      ..color = const Color(0xFF26C6DA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawRRect(
      RRect.fromRectAndRadius(viewportOnMinimap, const Radius.circular(3)),
      vpFillPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(viewportOnMinimap, const Radius.circular(3)),
      vpBorderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MinimapPainter oldDelegate) => true;
}
