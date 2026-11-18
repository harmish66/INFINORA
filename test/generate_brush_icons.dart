import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Generate Infinora Artistic Paintbrush & Paint Stroke App Icons', () async {
    const colorDeepIndigo = Color(0xFF21145B);
    const colorPrimaryViolet = Color(0xFF6558F5);
    const colorElectricPurple = Color(0xFF9A79F8);
    const colorArtisticPink = Color(0xFFF05BCB);
    const colorSkyBlue = Color(0xFF38BDF8);
    const colorWarmOrange = Color(0xFFFFAD57);
    const colorWhite = Color(0xFFFFFFFF);

    void drawArtisticIcon(Canvas canvas, Size size) {
      final cx = size.width / 2;
      final cy = size.height / 2;
      final scale = size.width / 1024.0;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.scale(scale, scale);

      // Coordinates centered around (0, 0):

      // 1. Subtle Drawing Surface / Canvas Plane in background
      final canvasCard = RRect.fromRectAndRadius(
        const Rect.fromLTWH(-280, -280, 560, 560),
        const Radius.circular(56),
      );
      final canvasCardPaint = Paint()
        ..color = const Color(0xFF2B1A73)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(canvasCard, canvasCardPaint);

      final canvasBorderPaint = Paint()
        ..color = colorPrimaryViolet.withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;
      canvas.drawRRect(canvasCard, canvasBorderPaint);

      // Subtle canvas weave guideline
      final weavePaint = Paint()
        ..color = colorElectricPurple.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawCircle(Offset.zero, 240, weavePaint);
      canvas.drawCircle(Offset.zero, 180, weavePaint);

      // 2. The Flowing Artistic Paint Stroke
      // A bold, dynamic, expressive multi-layered wave curling across the canvas
      
      // Bottom Layer: Sky Blue Flow (#38BDF8)
      final blueStroke = Path()
        ..moveTo(-210, 160)
        ..cubicTo(-170, 240, -40, 250, 40, 180)
        ..cubicTo(120, 110, 140, 0, 70, -70)
        ..cubicTo(10, -130, -80, -90, -110, -20)
        ..cubicTo(-135, 40, -100, 100, -50, 120);

      final bluePaint = Paint()
        ..color = colorSkyBlue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 46
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(blueStroke, bluePaint);

      // Mid Layer: Electric Purple & Primary Violet Flow (#9A79F8 & #6558F5)
      final violetStroke = Path()
        ..moveTo(-200, 130)
        ..cubicTo(-150, 210, -30, 220, 45, 155)
        ..cubicTo(120, 90, 135, -10, 65, -80)
        ..cubicTo(10, -140, -70, -100, -100, -35)
        ..cubicTo(-125, 25, -90, 85, -40, 105);

      final violetPaint = Paint()
        ..color = colorElectricPurple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 36
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(violetStroke, violetPaint);

      // Core Vibrant Layer: Artistic Pink (#F05BCB)
      final pinkStroke = Path()
        ..moveTo(-185, 100)
        ..cubicTo(-130, 175, -20, 185, 50, 125)
        ..cubicTo(115, 65, 125, -20, 60, -85)
        ..cubicTo(10, -145, -60, -110, -85, -50)
        ..cubicTo(-105, 5, -75, 65, -30, 85);

      final pinkPaint = Paint()
        ..color = colorArtisticPink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 26
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(pinkStroke, pinkPaint);

      // Accent Warm Core: Warm Orange (#FFAD57)
      final orangeStroke = Path()
        ..moveTo(-170, 75)
        ..cubicTo(-110, 145, -10, 150, 50, 95)
        ..cubicTo(105, 45, 110, -30, 55, -90);

      final orangePaint = Paint()
        ..color = colorWarmOrange
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(orangeStroke, orangePaint);

      // Impasto High-Gloss Specular Highlights (#FFFFFF)
      final highlight1 = Path()
        ..moveTo(-150, 80)
        ..cubicTo(-95, 135, -5, 140, 45, 90);

      final highlightWhite = Paint()
        ..color = colorWhite
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(highlight1, highlightWhite);

      final highlight2 = Path()
        ..moveTo(65, 60)
        ..cubicTo(95, 20, 95, -30, 50, -75);
      canvas.drawPath(highlight2, highlightWhite);

      // 3. The Professional Artist Paintbrush
      // Positioned diagonally: Handle at top-right (230, -250), pointing down-left to (50, -90)
      
      // Brush Handle (Polished deep violet & titanium wood)
      final handlePath = Path()
        ..moveTo(165, -190)
        ..lineTo(250, -275)
        ..lineTo(275, -250)
        ..lineTo(190, -165)
        ..close();

      final handlePaint = Paint()
        ..color = const Color(0xFF160E3D)
        ..style = PaintingStyle.fill;
      canvas.drawPath(handlePath, handlePaint);

      final handleHighlight = Paint()
        ..color = colorPrimaryViolet.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawLine(const Offset(168, -187), const Offset(253, -272), handleHighlight);

      // Metal Ferrule (Polished Silver / Chrome)
      final ferrulePath = Path()
        ..moveTo(130, -155)
        ..lineTo(170, -195)
        ..lineTo(195, -170)
        ..lineTo(155, -130)
        ..close();

      final ferrulePaint = Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.fill;
      canvas.drawPath(ferrulePath, ferrulePaint);

      // Ferrule Crimp Bands
      final crimpPaint = Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawLine(const Offset(142, -143), const Offset(182, -183), crimpPaint);
      canvas.drawLine(const Offset(148, -137), const Offset(188, -177), crimpPaint);

      // Ferrule Specular Highlight
      final ferruleLight = Paint()
        ..color = colorWhite
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5;
      canvas.drawLine(const Offset(133, -152), const Offset(173, -192), ferruleLight);

      // Brush Bristles Cone (Dark sable bristles loaded with paint)
      final bristlePath = Path()
        ..moveTo(130, -155)
        ..lineTo(155, -130)
        ..cubicTo(125, -100, 95, -80, 50, -85) // Bristle tip dipping into paint
        ..cubicTo(75, -115, 105, -135, 130, -155)
        ..close();

      final bristlePaint = Paint()
        ..color = const Color(0xFF331B68)
        ..style = PaintingStyle.fill;
      canvas.drawPath(bristlePath, bristlePaint);

      // Wet Paint Tip of the Brush (Loaded with Artistic Pink & Orange)
      final wetTipPath = Path()
        ..moveTo(105, -115)
        ..lineTo(125, -95)
        ..cubicTo(105, -80, 80, -75, 50, -85)
        ..cubicTo(68, -100, 88, -110, 105, -115)
        ..close();

      final wetTipPaint = Paint()
        ..color = colorArtisticPink
        ..style = PaintingStyle.fill;
      canvas.drawPath(wetTipPath, wetTipPaint);

      final wetTipAccent = Paint()
        ..color = colorWarmOrange
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(62, -87), 7, wetTipAccent);

      final wetTipWhite = Paint()
        ..color = colorWhite
        ..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(56, -86), 3.5, wetTipWhite);

      // Fine paint droplets / splatters along the fluid arc (delicate and intentional)
      final dropWhite = Paint()..color = colorWhite;
      final dropPink = Paint()..color = colorArtisticPink;
      final dropBlue = Paint()..color = colorSkyBlue;
      final dropOrange = Paint()..color = colorWarmOrange;

      canvas.drawCircle(const Offset(95, -130), 5.5, dropPink);
      canvas.drawCircle(const Offset(115, -145), 3.5, dropWhite);
      canvas.drawCircle(const Offset(-130, -50), 4.5, dropBlue);
      canvas.drawCircle(const Offset(-165, 195), 6, dropOrange);
      canvas.drawCircle(const Offset(70, 210), 5, dropPink);

      canvas.restore();
    }

    Future<List<int>> renderMasterIcon(int size, {bool rounded = true, bool circle = false}) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

      // Solid Deep Indigo Background (#21145B)
      final bgPaint = Paint()..color = colorDeepIndigo;
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

      drawArtisticIcon(canvas, Size(size.toDouble(), size.toDouble()));

      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    Future<List<int>> renderAdaptiveForeground(int size) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()));

      // Draw inside safe zone with transparent background
      drawArtisticIcon(canvas, Size(size.toDouble(), size.toDouble()));

      final picture = recorder.endRecording();
      final img = await picture.toImage(size, size);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    }

    // 1. High Resolution Master Icons (1024x1024 & 512x512)
    final master1024 = await renderMasterIcon(1024, rounded: false);
    await File('assets/branding/infinora_icon_1024.png').writeAsBytes(master1024);

    final store512 = await renderMasterIcon(512, rounded: false);
    await File('assets/branding/infinora_icon_512.png').writeAsBytes(store512);

    // 2. Android Density Mipmaps
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

      final squareBytes = await renderMasterIcon(size, rounded: true);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher.png').writeAsBytes(squareBytes);

      final roundBytes = await renderMasterIcon(size, circle: true);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher_round.png').writeAsBytes(roundBytes);

      final fgSize = adaptiveFgSizes[density]!;
      final fgBytes = await renderAdaptiveForeground(fgSize);
      await File('android/app/src/main/res/mipmap-$density/ic_launcher_foreground.png').writeAsBytes(fgBytes);
    }

    expect(File('assets/branding/infinora_icon_1024.png').existsSync(), isTrue);
  });
}
