import 'dart:math' as math;
import 'package:flutter/material.dart';

class CountryFlagWidget extends StatelessWidget {
  final String code;
  final double width;
  final double height;
  final double borderRadius;

  const CountryFlagWidget({
    super.key,
    required this.code,
    this.width = 32,
    this.height = 22,
    this.borderRadius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.12),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 0.5),
        child: CustomPaint(
          size: Size(width, height),
          painter: _FlagPainter(code.toLowerCase()),
        ),
      ),
    );
  }
}

class _FlagPainter extends CustomPainter {
  final String code;

  const _FlagPainter(this.code);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..isAntiAlias = true;

    switch (code) {
      case 'en':
        _paintUkFlag(canvas, size, paint);
        break;
      case 'hi':
      case 'gu':
        _paintIndiaFlag(canvas, size, paint);
        break;
      case 'es':
        _paintSpainFlag(canvas, size, paint);
        break;
      case 'fr':
        _paintFranceFlag(canvas, size, paint);
        break;
      case 'ar':
        _paintArabicFlag(canvas, size, paint);
        break;
      default:
        // Generic fallback flag
        paint.color = const Color(0xFF0284C7);
        canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);
        paint.color = Colors.white;
        canvas.drawCircle(Offset(w / 2, h / 2), h / 3.5, paint);
    }
  }

  void _paintUkFlag(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;

    // Navy base
    paint.color = const Color(0xFF012169);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paint);

    // Diagonal White Cross
    paint.color = Colors.white;
    paint.strokeWidth = h * 0.28;
    canvas.drawLine(const Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), paint);

    // Diagonal Red Cross
    paint.color = const Color(0xFFC8102E);
    paint.strokeWidth = h * 0.12;
    canvas.drawLine(const Offset(0, 0), Offset(w, h), paint);
    canvas.drawLine(Offset(0, h), Offset(w, 0), paint);

    // St George White Cross
    paint.color = Colors.white;
    final whiteW = w * 0.30;
    final whiteH = h * 0.36;
    canvas.drawRect(Rect.fromLTWH((w - whiteW) / 2, 0, whiteW, h), paint);
    canvas.drawRect(Rect.fromLTWH(0, (h - whiteH) / 2, w, whiteH), paint);

    // St George Red Cross
    paint.color = const Color(0xFFC8102E);
    final redW = w * 0.18;
    final redH = h * 0.22;
    canvas.drawRect(Rect.fromLTWH((w - redW) / 2, 0, redW, h), paint);
    canvas.drawRect(Rect.fromLTWH(0, (h - redH) / 2, w, redH), paint);
  }

  void _paintIndiaFlag(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final thirdH = h / 3;

    // Saffron Top
    paint.color = const Color(0xFFFF9933);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, thirdH), paint);

    // White Middle
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, thirdH, w, thirdH), paint);

    // Green Bottom
    paint.color = const Color(0xFF138808);
    canvas.drawRect(Rect.fromLTWH(0, 2 * thirdH, w, thirdH), paint);

    // Ashoka Chakra Navy Wheel
    final center = Offset(w / 2, h / 2);
    final radius = thirdH * 0.42;

    paint.color = const Color(0xFF000080);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.8;
    canvas.drawCircle(center, radius, paint);

    // Center hub dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.22, paint);

    // 8 visible miniature spokes
    paint.strokeWidth = 0.6;
    for (int i = 0; i < 8; i++) {
      final angle = i * (math.pi / 4);
      final p2 = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas.drawLine(center, p2, paint);
    }
  }

  void _paintSpainFlag(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;

    // Red Top 25%
    paint.color = const Color(0xFFAA151B);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.25), paint);

    // Gold/Yellow Middle 50%
    paint.color = const Color(0xFFF1BF00);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.25, w, h * 0.50), paint);

    // Red Bottom 25%
    paint.color = const Color(0xFFAA151B);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.75, w, h * 0.25), paint);

    // Spanish Coat of Arms Emblem Stamp
    paint.color = const Color(0xFFAA151B);
    final emblemCenter = Offset(w * 0.32, h * 0.5);
    canvas.drawCircle(emblemCenter, h * 0.16, paint);
    paint.color = const Color(0xFFF1BF00);
    canvas.drawCircle(emblemCenter, h * 0.08, paint);
  }

  void _paintFranceFlag(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final thirdW = w / 3;

    // Blue Left
    paint.color = const Color(0xFF0055A4);
    canvas.drawRect(Rect.fromLTWH(0, 0, thirdW, h), paint);

    // White Center
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(thirdW, 0, thirdW, h), paint);

    // Red Right
    paint.color = const Color(0xFFEF4135);
    canvas.drawRect(Rect.fromLTWH(2 * thirdW, 0, thirdW, h), paint);
  }

  void _paintArabicFlag(Canvas canvas, Size size, Paint paint) {
    final w = size.width;
    final h = size.height;
    final thirdH = h / 3;
    final hoistW = w * 0.28;

    // Green Top Stripe
    paint.color = const Color(0xFF007A3D);
    canvas.drawRect(Rect.fromLTWH(hoistW, 0, w - hoistW, thirdH), paint);

    // White Middle Stripe
    paint.color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(hoistW, thirdH, w - hoistW, thirdH), paint);

    // Black Bottom Stripe
    paint.color = const Color(0xFF000000);
    canvas.drawRect(Rect.fromLTWH(hoistW, 2 * thirdH, w - hoistW, thirdH), paint);

    // Red Hoist Vertical Stripe
    paint.color = const Color(0xFFEF3340);
    canvas.drawRect(Rect.fromLTWH(0, 0, hoistW, h), paint);
  }

  @override
  bool shouldRepaint(covariant _FlagPainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
