import 'package:flutter/material.dart';

// Precision Infinora Brand Logo Widget
class InfinoraLogoGlyph extends StatelessWidget {
  final double size;
  final double? borderRadius;

  const InfinoraLogoGlyph({
    super.key,
    this.size = 72,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? (size * 0.22);
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        'assets/branding/infinora_icon_512.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Language Selection Illustration: Cartographic Precision Globe
class LanguageWorldIllustration extends StatelessWidget {
  final double size;

  const LanguageWorldIllustration({super.key, this.size = 140});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LanguageWorldPainter(),
      ),
    );
  }
}

class _LanguageWorldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.38;

    final basePaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r, basePaint);

    final gridLine = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = const Color(0xFF94A3B8);

    // Outer circle
    canvas.drawCircle(center, r, gridLine..strokeWidth = 1.5);

    // Latitudes
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 2, height: r * 0.7), gridLine);
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 2, height: r * 1.4), gridLine);

    // Longitudes
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 0.6, height: r * 2), gridLine);
    canvas.drawOval(Rect.fromCenter(center: center, width: r * 1.3, height: r * 2), gridLine);

    // Equator and Meridian
    canvas.drawLine(Offset(center.dx - r, center.dy), Offset(center.dx + r, center.dy), gridLine);
    canvas.drawLine(Offset(center.dx, center.dy - r), Offset(center.dx, center.dy + r), gridLine);

    // Geographic coordinate nodes
    final nodes = [
      Offset(center.dx - r * 0.55, center.dy - r * 0.3),
      Offset(center.dx + r * 0.45, center.dy - r * 0.45),
      Offset(center.dx + r * 0.65, center.dy + r * 0.25),
      Offset(center.dx - r * 0.35, center.dy + r * 0.5),
      Offset(center.dx + r * 0.2, center.dy + r * 0.6),
    ];

    final nodePaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.fill;

    for (final pt in nodes) {
      canvas.drawCircle(pt, 3.5, nodePaint);
      canvas.drawCircle(pt, 6.0, Paint()..color = const Color(0xFF2563EB).withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 1.2);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Onboarding 1: Architectural Perspective Canvas (Human-Crafted Drafting)
class InfiniteCreativityIllustration extends StatelessWidget {
  final double width;
  final double height;

  const InfiniteCreativityIllustration({
    super.key,
    this.width = 280,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _InfiniteCreativityPainter(),
      ),
    );
  }
}

class _InfiniteCreativityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Technical drafting background board
    final boardRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.88, height: h * 0.82);
    final boardRRect = RRect.fromRectAndRadius(boardRect, const Radius.circular(8));

    final boardFill = Paint()
      ..color = const Color(0xFFF8FAFC)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(boardRRect, boardFill);

    final boardBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawRRect(boardRRect, boardBorder);

    // Architectural drafting grid
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (double x = boardRect.left + 16; x < boardRect.right; x += 16) {
      canvas.drawLine(Offset(x, boardRect.top), Offset(x, boardRect.bottom), gridPaint);
    }
    for (double y = boardRect.top + 16; y < boardRect.bottom; y += 16) {
      canvas.drawLine(Offset(boardRect.left, y), Offset(boardRect.right, y), gridPaint);
    }

    // Perspective infinite planes receding toward focal vanishing point
    final vp = Offset(boardRect.center.dx + 40, boardRect.top + 35);

    final axisPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(Offset(boardRect.left + 20, boardRect.bottom - 15), vp, axisPaint);
    canvas.drawLine(Offset(boardRect.right - 20, boardRect.bottom - 15), vp, axisPaint);
    canvas.drawLine(Offset(boardRect.left + 20, boardRect.top + 45), vp, axisPaint);
    canvas.drawLine(Offset(boardRect.right - 20, boardRect.top + 45), vp, axisPaint);

    // Drafted structural geometry on canvas
    final housePath = Path()
      ..moveTo(boardRect.left + 35, boardRect.bottom - 25)
      ..lineTo(boardRect.left + 35, boardRect.bottom - 85)
      ..lineTo(boardRect.left + 95, boardRect.bottom - 120)
      ..lineTo(boardRect.left + 155, boardRect.bottom - 85)
      ..lineTo(boardRect.left + 155, boardRect.bottom - 25)
      ..close();

    final linePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(housePath, linePaint);

    // Perspective projection line extending beyond right boundary
    final projPath = Path()
      ..moveTo(boardRect.left + 95, boardRect.bottom - 120)
      ..lineTo(boardRect.right + 15, boardRect.top + 60);

    final dashPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(projPath, dashPaint);

    // Framing crop corner marks
    _drawCropMark(canvas, Offset(boardRect.left + 8, boardRect.top + 8), 10);
    _drawCropMark(canvas, Offset(boardRect.right - 8, boardRect.top + 8), 10);
    _drawCropMark(canvas, Offset(boardRect.left + 8, boardRect.bottom - 8), 10);
    _drawCropMark(canvas, Offset(boardRect.right - 8, boardRect.bottom - 8), 10);
  }

  void _drawCropMark(Canvas canvas, Offset p, double len) {
    final paint = Paint()
      ..color = const Color(0xFF64748B)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(p.dx - len, p.dy), Offset(p.dx + len, p.dy), paint);
    canvas.drawLine(Offset(p.dx, p.dy - len), Offset(p.dx, p.dy + len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Onboarding 2: Precision Stylus & Natural Media
class DrawWithoutLimitsIllustration extends StatelessWidget {
  final double width;
  final double height;

  const DrawWithoutLimitsIllustration({
    super.key,
    this.width = 280,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DrawWithoutLimitsPainter(),
      ),
    );
  }
}

class _DrawWithoutLimitsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final sheetRect = Rect.fromCenter(center: Offset(w * 0.5, h * 0.5), width: w * 0.88, height: h * 0.82);
    canvas.drawRRect(
      RRect.fromRectAndRadius(sheetRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFFF8FAFC),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(sheetRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.2,
    );

    // Authentic technical hatching lines (cross-hatching sketch sample)
    final hatchPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.2;

    for (int i = 0; i < 7; i++) {
      final y = sheetRect.top + 30 + i * 8.0;
      canvas.drawLine(Offset(sheetRect.left + 24, y), Offset(sheetRect.left + 90, y - 16), hatchPaint);
    }
    for (int i = 0; i < 7; i++) {
      final x = sheetRect.left + 35 + i * 8.0;
      canvas.drawLine(Offset(x, sheetRect.top + 16), Offset(x + 16, sheetRect.top + 76), hatchPaint);
    }

    // Calligraphic precision bezier wave
    final curvePath = Path();
    curvePath.moveTo(sheetRect.left + 24, sheetRect.bottom - 40);
    curvePath.cubicTo(
      sheetRect.left + 80,
      sheetRect.bottom - 90,
      sheetRect.left + 140,
      sheetRect.bottom - 20,
      sheetRect.left + 200,
      sheetRect.bottom - 60,
    );

    final inkPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(curvePath, inkPaint);

    // Realistic Technical Stylus (45-degree angle)
    final tip = Offset(sheetRect.left + 200, sheetRect.bottom - 60);
    final tail = Offset(sheetRect.right - 10, sheetRect.top + 20);

    // Stylus Barrel
    final barrelPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(tip + const Offset(12, -12), tail, barrelPaint);

    // Metallic grip ring
    final gripPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(tip + const Offset(5, -5), tip + const Offset(14, -14), gripPaint);

    // Fine tip point
    final tipPoint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(tip, tip + const Offset(5, -5), tipPoint);

    // Precision touch crosshair at tip
    final markPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 1.2;
    canvas.drawLine(Offset(tip.dx - 6, tip.dy), Offset(tip.dx + 6, tip.dy), markPaint);
    canvas.drawLine(Offset(tip.dx, tip.dy - 6), Offset(tip.dx, tip.dy + 6), markPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Onboarding 3: Infinite Zoom Technical Scale Schematic
class ExploreInfiniteZoomIllustration extends StatelessWidget {
  final double width;
  final double height;

  const ExploreInfiniteZoomIllustration({
    super.key,
    this.width = 280,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _ExploreInfiniteZoomPainter(),
      ),
    );
  }
}

class _ExploreInfiniteZoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);

    final frames = [
      {'w': w * 0.88, 'h': h * 0.82, 'label': '1x (Overview)'},
      {'w': w * 0.52, 'h': h * 0.48, 'label': '10x'},
      {'w': w * 0.22, 'h': h * 0.20, 'label': '100x'},
    ];

    for (int i = 0; i < frames.length; i++) {
      final f = frames[i];
      final fw = f['w'] as double;
      final fh = f['h'] as double;
      final r = Rect.fromCenter(center: center, width: fw, height: fh);
      final rrect = RRect.fromRectAndRadius(r, const Radius.circular(6));

      final fill = Paint()
        ..color = i == 0
            ? const Color(0xFFF8FAFC)
            : (i == 1 ? const Color(0xFFEFF6FF) : const Color(0xFFDBEAFE))
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, fill);

      final border = Paint()
        ..color = i == 2 ? const Color(0xFF2563EB) : const Color(0xFF94A3B8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == 2 ? 1.8 : 1.0;
      canvas.drawRRect(rrect, border);

      final tp = TextPainter(
        text: TextSpan(
          text: f['label'] as String,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: i == 2 ? const Color(0xFF2563EB) : const Color(0xFF64748B),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(r.left + 6, r.top + 4));
    }

    final outerRect = Rect.fromCenter(center: center, width: w * 0.88, height: h * 0.82);
    final midRect = Rect.fromCenter(center: center, width: w * 0.52, height: h * 0.48);
    final projPaint = Paint()
      ..color = const Color(0xFF2563EB).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawLine(outerRect.topLeft, midRect.topLeft, projPaint);
    canvas.drawLine(outerRect.topRight, midRect.topRight, projPaint);
    canvas.drawLine(outerRect.bottomLeft, midRect.bottomLeft, projPaint);
    canvas.drawLine(outerRect.bottomRight, midRect.bottomRight, projPaint);

    final crosshair = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(center.dx - 8, center.dy), Offset(center.dx + 8, center.dy), crosshair);
    canvas.drawLine(Offset(center.dx, center.dy - 8), Offset(center.dx, center.dy + 8), crosshair);
    canvas.drawCircle(center, 2.5, Paint()..color = const Color(0xFF2563EB));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Onboarding 4: Studio Export & Lossless Storage
class SaveAndShareIllustration extends StatelessWidget {
  final double width;
  final double height;

  const SaveAndShareIllustration({
    super.key,
    this.width = 280,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SaveAndSharePainter(),
      ),
    );
  }
}

class _SaveAndSharePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final docRect = Rect.fromCenter(center: Offset(w * 0.46, h * 0.5), width: w * 0.65, height: h * 0.8);
    final docRRect = RRect.fromRectAndRadius(docRect, const Radius.circular(8));

    canvas.drawRRect(
      docRRect.shift(const Offset(2, 4)),
      Paint()..color = Colors.black.withValues(alpha: 0.08),
    );

    canvas.drawRRect(docRRect, Paint()..color = Colors.white);
    canvas.drawRRect(docRRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    final linePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(docRect.left + 16, docRect.bottom - 24)
      ..lineTo(docRect.left + 50, docRect.top + 35)
      ..lineTo(docRect.left + 80, docRect.bottom - 35)
      ..lineTo(docRect.right - 20, docRect.top + 50);
    canvas.drawPath(path, linePaint);

    final blockRect = Rect.fromLTWH(docRect.left + 12, docRect.bottom - 28, docRect.width - 24, 18);
    canvas.drawRect(blockRect, Paint()..color = const Color(0xFFF1F5F9));
    canvas.drawRect(blockRect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    _drawBadge(canvas, Offset(w * 0.86, h * 0.28), 'PNG');
    _drawBadge(canvas, Offset(w * 0.86, h * 0.50), 'PDF');
    _drawBadge(canvas, Offset(w * 0.86, h * 0.72), 'SVG');
  }

  void _drawBadge(Canvas canvas, Offset center, String text) {
    final rect = Rect.fromCenter(center: center, width: 42, height: 24);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(6));

    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF0F172A));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 1.0);

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Clean Studio Empty Projects Drawing
class EmptyProjectsIllustration extends StatelessWidget {
  final double size;

  const EmptyProjectsIllustration({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _EmptyProjectsPainter(),
      ),
    );
  }
}

class _EmptyProjectsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final w = size.width;
    final h = size.height;

    final boardRect = Rect.fromCenter(center: center, width: w * 0.75, height: h * 0.65);
    final rrect = RRect.fromRectAndRadius(boardRect, const Radius.circular(6));

    canvas.drawRRect(rrect, Paint()..color = const Color(0xFFF1F5F9));
    canvas.drawRRect(rrect, Paint()..color = const Color(0xFFCBD5E1)..style = PaintingStyle.stroke..strokeWidth = 1.2);

    final grid = Paint()..color = const Color(0xFFE2E8F0)..strokeWidth = 0.8;
    canvas.drawLine(Offset(boardRect.left, center.dy), Offset(boardRect.right, center.dy), grid);
    canvas.drawLine(Offset(center.dx, boardRect.top), Offset(center.dx, boardRect.bottom), grid);

    final plusPaint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(center.dx - 10, center.dy), Offset(center.dx + 10, center.dy), plusPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 10), Offset(center.dx, center.dy + 10), plusPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Studio Pro Craftsmanship Emblem (Technical drafting compass & precision geometry)
class PremiumHeroIllustration extends StatelessWidget {
  final double size;

  const PremiumHeroIllustration({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PremiumHeroPainter(),
      ),
    );
  }
}

class _PremiumHeroPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.4;

    canvas.drawCircle(
      center,
      r,
      Paint()..color = const Color(0xFFF1F5F9),
    );
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final path = Path()
      ..moveTo(center.dx, center.dy - r * 0.65)
      ..lineTo(center.dx + r * 0.5, center.dy + r * 0.5)
      ..lineTo(center.dx - r * 0.5, center.dy + r * 0.5)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF2563EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawLine(
      Offset(center.dx - r * 0.3, center.dy + r * 0.15),
      Offset(center.dx + r * 0.3, center.dy + r * 0.15),
      Paint()
        ..color = const Color(0xFF2563EB)
        ..strokeWidth = 1.8,
    );

    canvas.drawCircle(
      Offset(center.dx, center.dy - r * 0.65),
      3.5,
      Paint()..color = const Color(0xFF0F172A),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
