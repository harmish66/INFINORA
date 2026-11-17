import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Generate Complete Infinora Production Icon Assets', () async {
    const brandPrimaryViolet = Color(0xFF6558F5);
    const brandSecondaryPurple = Color(0xFF9A79F8);
    const brandDeepPurple = Color(0xFF4835C9);
    const brandAccent = Color(0xFFB6A8FF);
    const brandWhite = Color(0xFFFFFFFF);
    const brandDarkBase = Color(0xFF140E34);

    void drawInfinoraSymbol(Canvas canvas, Size size) {
      final cx = size.width / 2;
      final cy = size.height / 2;
      final scale = size.width / 1024.0;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.scale(scale, scale);

      // 1. Primary Left Lobe (Primary Violet #6558F5)
      final leftStroke = Path()
        ..moveTo(0, 0)
        ..cubicTo(-75, 95, -155, 120, -215, 75)
        ..cubicTo(-265, 38, -265, -38, -215, -75)
        ..cubicTo(-155, -120, -75, -95, 0, 0);

      final bodyPaint1 = Paint()
        ..color = brandPrimaryViolet
        ..style = PaintingStyle.stroke
        ..strokeWidth = 52
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(leftStroke, bodyPaint1);

      // 2. Secondary Right Lobe (Secondary Purple #9A79F8)
      final rightStroke = Path()
        ..moveTo(0, 0)
        ..cubicTo(75, -95, 155, -120, 215, -75)
        ..cubicTo(265, -38, 265, 38, 215, 75)
        ..cubicTo(155, 120, 75, 95, 0, 0);

      final bodyPaint2 = Paint()
        ..color = brandSecondaryPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 52
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(rightStroke, bodyPaint2);

      // 3. Overpass Shadow & Crossing Ribbon (3D interlock)
      final overpass = Path()
        ..moveTo(-55, -70)
        ..cubicTo(-25, -35, 25, 35, 55, 70);

      final overpassShadow = Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 58
        ..strokeCap = StrokeCap.round;

      final overpassPaint = Paint()
        ..color = brandPrimaryViolet
        ..style = PaintingStyle.stroke
        ..strokeWidth = 52
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(overpass, overpassShadow);
      canvas.drawPath(overpass, overpassPaint);

      // 4. Left Nested Zoom Aperture Level 1 (Accent #B6A8FF)
      final nestedLeft1 = Path()
        ..moveTo(-60, 0)
        ..cubicTo(-90, 48, -140, 58, -170, 36)
        ..cubicTo(-195, 18, -195, -18, -170, -36)
        ..cubicTo(-140, -58, -90, -48, -60, 0);

      final nestedPaint1 = Paint()
        ..color = brandAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(nestedLeft1, nestedPaint1);

      // Left Nested Zoom Aperture Level 2 (White #FFFFFF)
      final nestedLeft2 = Path()
        ..moveTo(-90, 0)
        ..cubicTo(-108, 24, -132, 28, -146, 16)
        ..cubicTo(-158, 8, -158, -8, -146, -16)
        ..cubicTo(-132, -28, -108, -24, -90, 0);

      final nestedPaintWhite = Paint()
        ..color = brandWhite
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(nestedLeft2, nestedPaintWhite);

      // 5. Right Nested Zoom Aperture Level 1 (Deep Purple #4835C9)
      final nestedRight1 = Path()
        ..moveTo(60, 0)
        ..cubicTo(90, -48, 140, -58, 170, -36)
        ..cubicTo(195, -18, 195, 18, 170, 36)
        ..cubicTo(140, 58, 90, 48, 60, 0);

      final nestedPaintDeep = Paint()
        ..color = brandDeepPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(nestedRight1, nestedPaintDeep);

      // Right Nested Zoom Aperture Level 2 (White #FFFFFF)
      final nestedRight2 = Path()
        ..moveTo(90, 0)
        ..cubicTo(108, -24, 132, -28, 146, -16)
        ..cubicTo(158, -8, 158, 8, 146, 16)
        ..cubicTo(132, 28, 108, 24, 90, 0);

      canvas.drawPath(nestedRight2, nestedPaintWhite);

      // 6. Central Infinite Canvas Origin Node (Precision Center)
      final centerGlow = Paint()
        ..color = brandAccent.withValues(alpha: 0.6)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(0, 0), 10, centerGlow);

      final centerNode = Paint()
        ..color = brandWhite
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(0, 0), 6.5, centerNode);

      canvas.restore();
    }

    Future<List<int>> renderMasterIcon(int size, {bool rounded = true, bool circle = false}) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

      final bgPaint = Paint()..color = brandDarkBase;
      if (circle) {
        canvas.drawCircle(Offset(size / 2, size / 2), size / 2, bgPaint);
      } else if (rounded) {
        final rrect = RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
          Radius.circular(size * 0.22),
        );
        canvas.drawRRect(rrect, bgPaint);
      } else {
        canvas.drawRect(Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()), bgPaint);
      }

      // Subtle framing ring
      final framePaint = Paint()
        ..color = brandDeepPurple.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.012;
      canvas.drawCircle(Offset(size / 2, size / 2), size * 0.42, framePaint);

      drawInfinoraSymbol(canvas, Size(size.toDouble(), size.toDouble()));

      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    Future<List<int>> renderAdaptiveForeground(int size) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

      // Draw inside safe zone
      drawInfinoraSymbol(canvas, Size(size.toDouble(), size.toDouble()));

      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    // 1. High Resolution Master Icons
    final master1024 = await renderMasterIcon(1024, rounded: false);
    await File('assets/branding/infinora_icon_1024.png').writeAsBytes(master1024);

    final store512 = await renderMasterIcon(512, rounded: false);
    await File('assets/branding/infinora_icon_512.png').writeAsBytes(store512);

    // 2. Android Density Map
    final densitySizes = {
      'mdpi': 48,
      'hdpi': 72,
      'xhdpi': 96,
      'xxhdpi': 144,
      'xxxhdpi': 192,
    };

    final adaptiveFgSizes = {
      'mdpi': 108,
      'hdpi': 162,
      'xhdpi': 216,
      'xxhdpi': 324,
      'xxxhdpi': 432,
    };

    for (final entry in densitySizes.entries) {
      final density = entry.key;
      final size = entry.value;

      // Legacy square/squircle
      final squareBytes = await renderMasterIcon(size, rounded: true);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher.png').writeAsBytes(squareBytes);

      // Round launcher icon
      final roundBytes = await renderMasterIcon(size, circle: true);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher_round.png').writeAsBytes(roundBytes);

      // Adaptive foreground
      final fgSize = adaptiveFgSizes[density]!;
      final fgBytes = await renderAdaptiveForeground(fgSize);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher_foreground.png').writeAsBytes(fgBytes);
    }

    expect(File('assets/branding/infinora_icon_1024.png').existsSync(), isTrue);
    expect(File('android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png').existsSync(), isTrue);
  });
}
