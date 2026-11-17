import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Render test image', () async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 100, 100));
    final paint = Paint()..color = const Color(0xFF6558F5);
    canvas.drawRect(const Rect.fromLTWH(0, 0, 100, 100), paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(100, 100);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    expect(byteData, isNotNull);
    await File('test_out.png').writeAsBytes(byteData!.buffer.asUint8List());
    expect(File('test_out.png').existsSync(), isTrue);
    await File('test_out.png').delete();
  });
}
