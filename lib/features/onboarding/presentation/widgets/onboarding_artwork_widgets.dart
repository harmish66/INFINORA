import 'package:flutter/material.dart';

// Slide 1: Unbounded Infinite Canvas Artwork
class InfiniteCanvasArtwork extends StatelessWidget {
  final double width;
  final double height;

  const InfiniteCanvasArtwork({
    super.key,
    this.width = 320,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size(width, height),
          painter: _InfiniteCanvasPainter(),
        ),
      ),
    );
  }
}

class _InfiniteCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Technical dot grid background
    final dotPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    for (double x = 16; x < w; x += 18) {
      for (double y = 16; y < h; y += 18) {
        canvas.drawCircle(Offset(x, y), 0.9, dotPaint);
      }
    }

    // Sky backdrop gradient for artwork zone
    final artRect = Rect.fromLTWH(w * 0.12, h * 0.14, w * 0.76, h * 0.72);
    final artRRect = RRect.fromRectAndRadius(artRect, const Radius.circular(10));

    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFE0F2FE), Color(0xFFFEF3C7)],
      ).createShader(artRect);
    canvas.drawRRect(artRRect, skyPaint);

    // Sun / Moon disk
    final sunPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(artRect.right - 35, artRect.top + 32), 18, sunPaint);

    // Distant mountain layer (Coral / Slate)
    final mtBack = Path()
      ..moveTo(artRect.left, artRect.bottom)
      ..lineTo(artRect.left + 40, artRect.top + 50)
      ..lineTo(artRect.left + 110, artRect.top + 90)
      ..lineTo(artRect.left + 170, artRect.top + 35)
      ..lineTo(artRect.right, artRect.bottom)
      ..close();

    final mtBackPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawPath(mtBack, mtBackPaint);

    // Foreground mountain layer
    final mtFront = Path()
      ..moveTo(artRect.left, artRect.bottom)
      ..lineTo(artRect.left + 80, artRect.top + 70)
      ..lineTo(artRect.left + 150, artRect.bottom)
      ..close();

    final mtFrontPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;
    canvas.drawPath(mtFront, mtFrontPaint);

    // Mountain 2 Foreground
    final mtFront2 = Path()
      ..moveTo(artRect.left + 110, artRect.bottom)
      ..lineTo(artRect.left + 180, artRect.top + 55)
      ..lineTo(artRect.right, artRect.bottom)
      ..close();
    canvas.drawPath(mtFront2, Paint()..color = const Color(0xFF334155));

    // Vector selection bounds on canvas
    final selPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final selRect = Rect.fromLTWH(artRect.left + 25, artRect.top + 30, 95, 75);
    canvas.drawRect(selRect, selPaint);

    // Corner handle squares
    final handlePaint = Paint()..color = Colors.white;
    final handleStroke = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (final p in [
      selRect.topLeft,
      selRect.topRight,
      selRect.bottomLeft,
      selRect.bottomRight,
    ]) {
      final hr = Rect.fromCenter(center: p, width: 7, height: 7);
      canvas.drawRect(hr, handlePaint);
      canvas.drawRect(hr, handleStroke);
    }

    // Ruler ticks on top edge
    final rulerPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.0;
    for (double rx = artRect.left; rx <= artRect.right; rx += 14) {
      canvas.drawLine(Offset(rx, artRect.top), Offset(rx, artRect.top - 6), rulerPaint);
    }

    // Border around artwork canvas
    canvas.drawRRect(
      artRRect,
      Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Slide 2: Studio Drawing Instruments Artwork
class StudioToolsArtwork extends StatelessWidget {
  final double width;
  final double height;

  const StudioToolsArtwork({
    super.key,
    this.width = 320,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size(width, height),
          painter: _StudioToolsPainter(),
        ),
      ),
    );
  }
}

class _StudioToolsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Drawing paper surface
    final paperRect = Rect.fromLTWH(w * 0.10, h * 0.12, w * 0.80, h * 0.76);
    final paperRRect = RRect.fromRectAndRadius(paperRect, const Radius.circular(10));

    canvas.drawRRect(paperRRect, Paint()..color = const Color(0xFFFBFBFB));
    canvas.drawRRect(
      paperRRect,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Dynamic sweeping calligraphic ink ribbon (Azure Blue)
    final blueRibbon = Path()
      ..moveTo(paperRect.left + 25, paperRect.bottom - 45)
      ..cubicTo(
        paperRect.left + 70,
        paperRect.bottom - 110,
        paperRect.left + 120,
        paperRect.bottom - 20,
        paperRect.left + 175,
        paperRect.bottom - 75,
      );

    canvas.drawPath(
      blueRibbon,
      Paint()
        ..color = const Color(0xFF0284C7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round,
    );

    // Coral secondary wave
    final coralRibbon = Path()
      ..moveTo(paperRect.left + 35, paperRect.bottom - 30)
      ..cubicTo(
        paperRect.left + 80,
        paperRect.bottom - 90,
        paperRect.left + 130,
        paperRect.bottom - 10,
        paperRect.left + 165,
        paperRect.bottom - 60,
      );

    canvas.drawPath(
      coralRibbon,
      Paint()
        ..color = const Color(0xFFE11D48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );

    // Color swatch pills on the left
    final swatches = [
      const Color(0xFF0284C7),
      const Color(0xFF059669),
      const Color(0xFFD97706),
      const Color(0xFFE11D48),
      const Color(0xFF0F172A),
    ];

    for (int i = 0; i < swatches.length; i++) {
      final y = paperRect.top + 20 + i * 20.0;
      canvas.drawCircle(
        Offset(paperRect.left + 22, y),
        6.5,
        Paint()..color = swatches[i],
      );
      canvas.drawCircle(
        Offset(paperRect.left + 22, y),
        6.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    // Professional Artist Stylus (45-degree angle in action)
    final tip = Offset(paperRect.left + 175, paperRect.bottom - 75);
    final tail = Offset(paperRect.right - 15, paperRect.top + 25);

    // Stylus shadow
    canvas.drawLine(
      tip + const Offset(6, 12),
      tail + const Offset(6, 12),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.10)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round,
    );

    // Stylus body (Matte Slate)
    canvas.drawLine(
      tip + const Offset(14, -14),
      tail,
      Paint()
        ..color = const Color(0xFF1E293B)
        ..strokeWidth = 8.0
        ..strokeCap = StrokeCap.round,
    );

    // Metallic barrel accent ring
    canvas.drawLine(
      tip + const Offset(10, -10),
      tip + const Offset(18, -18),
      Paint()
        ..color = const Color(0xFF94A3B8)
        ..strokeWidth = 7.5
        ..strokeCap = StrokeCap.round,
    );

    // Fine pen tip nib
    canvas.drawLine(
      tip,
      tip + const Offset(10, -10),
      Paint()
        ..color = const Color(0xFF0F172A)
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round,
    );

    // Touch pressure wave ring
    canvas.drawCircle(
      tip,
      9.0,
      Paint()
        ..color = const Color(0xFF0284C7).withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Slide 3: Deep Focal Infinite Zoom Artwork
class InfiniteZoomArtwork extends StatelessWidget {
  final double width;
  final double height;

  const InfiniteZoomArtwork({
    super.key,
    this.width = 320,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size(width, height),
          painter: _InfiniteZoomPainter(),
        ),
      ),
    );
  }
}

class _InfiniteZoomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w * 0.5, h * 0.5);

    // Level 0: Outer Universe Frame (1x)
    final r0 = Rect.fromCenter(center: center, width: w * 0.82, height: h * 0.78);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r0, const Radius.circular(10)),
      Paint()..color = const Color(0xFF0F172A),
    );

    // Stars in Level 0
    final starPaint = Paint()..color = Colors.white.withValues(alpha: 0.7);
    final starPts = [
      Offset(r0.left + 25, r0.top + 25),
      Offset(r0.right - 30, r0.top + 30),
      Offset(r0.left + 40, r0.bottom - 25),
      Offset(r0.right - 35, r0.bottom - 30),
    ];
    for (final p in starPts) {
      canvas.drawCircle(p, 1.8, starPaint);
    }

    // Level 1: Planetary Frame (10x)
    final r1 = Rect.fromCenter(center: center, width: w * 0.52, height: h * 0.50);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r1, const Radius.circular(8)),
      Paint()..color = const Color(0xFF065F46),
    );

    // Sun & island inside Level 1
    canvas.drawCircle(
      Offset(r1.right - 25, r1.top + 22),
      12,
      Paint()..color = const Color(0xFFFDE68A),
    );
    canvas.drawCircle(
      Offset(center.dx, center.dy + 12),
      28,
      Paint()..color = const Color(0xFF10B981),
    );

    // Level 2: Microscopic Bloom Frame (100x)
    final r2 = Rect.fromCenter(center: center, width: w * 0.24, height: h * 0.24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(r2, const Radius.circular(6)),
      Paint()..color = const Color(0xFFFFFBEB),
    );

    // Tiny Flower blossom in Level 2
    canvas.drawCircle(center, 9.0, Paint()..color = const Color(0xFFE11D48));
    canvas.drawCircle(center, 4.0, Paint()..color = const Color(0xFFF59E0B));

    // Perspective focal ray vectors
    final rayPaint = Paint()
      ..color = const Color(0xFF38BDF8).withValues(alpha: 0.5)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(r0.topLeft, r1.topLeft, rayPaint);
    canvas.drawLine(r0.topRight, r1.topRight, rayPaint);
    canvas.drawLine(r0.bottomLeft, r1.bottomLeft, rayPaint);
    canvas.drawLine(r0.bottomRight, r1.bottomRight, rayPaint);

    canvas.drawLine(r1.topLeft, r2.topLeft, rayPaint);
    canvas.drawLine(r1.topRight, r2.topRight, rayPaint);
    canvas.drawLine(r1.bottomLeft, r2.bottomLeft, rayPaint);
    canvas.drawLine(r1.bottomRight, r2.bottomRight, rayPaint);

    // Precision Crosshairs at Center
    final crossPaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..strokeWidth = 1.5;
    canvas.drawLine(Offset(center.dx - 12, center.dy), Offset(center.dx + 12, center.dy), crossPaint);
    canvas.drawLine(Offset(center.dx, center.dy - 12), Offset(center.dx, center.dy + 12), crossPaint);

    // Zoom badge indicator
    final badgeRect = Rect.fromLTWH(r0.left + 10, r0.top + 10, 60, 20);
    canvas.drawRRect(
      RRect.fromRectAndRadius(badgeRect, const Radius.circular(5)),
      Paint()..color = const Color(0xFF0284C7),
    );

    final tp = TextPainter(
      text: const TextSpan(
        text: '10,000X',
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(badgeRect.left + 7, badgeRect.top + 4));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Slide 4: Lossless Studio Export & Offline Vault Artwork
class LosslessExportArtwork extends StatelessWidget {
  final double width;
  final double height;

  const LosslessExportArtwork({
    super.key,
    this.width = 320,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          size: Size(width, height),
          painter: _LosslessExportPainter(),
        ),
      ),
    );
  }
}

class _LosslessExportPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background sheet (Back document layer)
    final docBack = Rect.fromLTWH(w * 0.16, h * 0.14, w * 0.45, h * 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(docBack, const Radius.circular(8)),
      Paint()..color = const Color(0xFFE2E8F0),
    );

    // Middle sheet
    final docMid = Rect.fromLTWH(w * 0.22, h * 0.18, w * 0.45, h * 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(docMid, const Radius.circular(8)),
      Paint()..color = const Color(0xFFF1F5F9),
    );

    // Front Hero Document Sheet
    final docFront = Rect.fromLTWH(w * 0.28, h * 0.22, w * 0.48, h * 0.65);
    canvas.drawRRect(
      RRect.fromRectAndRadius(docFront, const Radius.circular(8)),
      Paint()..color = Colors.white,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(docFront, const Radius.circular(8)),
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Artwork miniature inside front document
    final thumbRect = Rect.fromLTWH(docFront.left + 12, docFront.top + 12, docFront.width - 24, 60);
    canvas.drawRRect(
      RRect.fromRectAndRadius(thumbRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFFE0F2FE),
    );

    // Little mountains inside thumb
    final thumbMt = Path()
      ..moveTo(thumbRect.left, thumbRect.bottom)
      ..lineTo(thumbRect.left + 28, thumbRect.top + 22)
      ..lineTo(thumbRect.left + 55, thumbRect.bottom)
      ..close();
    canvas.drawPath(thumbMt, Paint()..color = const Color(0xFF0284C7));

    // Document mock text lines
    final linePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(docFront.left + 14, docFront.top + 85),
      Offset(docFront.right - 25, docFront.top + 85),
      linePaint,
    );
    canvas.drawLine(
      Offset(docFront.left + 14, docFront.top + 96),
      Offset(docFront.right - 45, docFront.top + 96),
      linePaint,
    );

    // Floating Export Format Badges (PNG, PDF, SVG)
    final formats = [
      {'label': 'PNG', 'color': const Color(0xFF0284C7), 'pos': Offset(w * 0.72, h * 0.22)},
      {'label': 'PDF', 'color': const Color(0xFFDC2626), 'pos': Offset(w * 0.74, h * 0.44)},
      {'label': 'SVG', 'color': const Color(0xFF059669), 'pos': Offset(w * 0.70, h * 0.66)},
    ];

    for (final fmt in formats) {
      final p = fmt['pos'] as Offset;
      final col = fmt['color'] as Color;
      final label = fmt['label'] as String;

      final badgeRect = Rect.fromCenter(center: p, width: 44, height: 26);
      canvas.drawRRect(
        RRect.fromRectAndRadius(badgeRect, const Radius.circular(6)),
        Paint()..color = col,
      );

      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(p.dx - tp.width / 2, p.dy - tp.height / 2));
    }

    // Offline Shield Badge on top left
    final shieldCenter = Offset(w * 0.16, h * 0.24);
    canvas.drawCircle(
      shieldCenter,
      16,
      Paint()..color = const Color(0xFF059669),
    );
    canvas.drawCircle(
      shieldCenter,
      16,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    );

    // White Checkmark in shield
    final checkPath = Path()
      ..moveTo(shieldCenter.dx - 6, shieldCenter.dy)
      ..lineTo(shieldCenter.dx - 2, shieldCenter.dy + 4)
      ..lineTo(shieldCenter.dx + 6, shieldCenter.dy - 4);

    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
