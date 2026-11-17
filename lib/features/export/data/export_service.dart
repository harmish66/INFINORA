import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import '../../canvas/domain/models/camera_state.dart';
import '../../canvas/domain/models/canvas_layer.dart';
import '../../canvas/domain/models/canvas_object.dart';
import '../../canvas/domain/models/canvas_tool.dart';

enum ExportFormat {
  png,
  jpeg,
  pdf,
  transparentPng,
}

enum ExportBoundsType {
  completeArtwork,
  currentViewport,
  selection,
}

class ExportService {
  static Future<Uint8List> renderCanvasToImage({
    required List<CanvasObject> objects,
    required List<CanvasLayer> layers,
    required CameraState camera,
    required Color backgroundColor,
    required ExportFormat format,
    required ExportBoundsType boundsType,
    required List<String> selectedObjectIds,
    required double scaleFactor,
    required Map<String, ui.Image> loadedImages,
    double? canvasWidth,
    double? canvasHeight,
  }) async {
    // 1. Determine bounding box
    Rect bounds;
    if (boundsType == ExportBoundsType.currentViewport) {
      bounds = camera.visibleWorldRect;
    } else if (boundsType == ExportBoundsType.selection && selectedObjectIds.isNotEmpty) {
      final selected = objects.where((o) => selectedObjectIds.contains(o.id)).toList();
      bounds = selected.first.boundingBox;
      for (final s in selected) {
        bounds = bounds.expandToInclude(s.boundingBox);
      }
      bounds = bounds.inflate(20);
    } else {
      // Complete artwork
      if (canvasWidth != null && canvasHeight != null) {
        bounds = Rect.fromLTWH(0, 0, canvasWidth, canvasHeight);
      } else if (objects.isNotEmpty) {
        bounds = objects.first.boundingBox;
        for (final o in objects) {
          bounds = bounds.expandToInclude(o.boundingBox);
        }
        bounds = bounds.inflate(40);
      } else {
        bounds = const Rect.fromLTWH(0, 0, 1080, 1080);
      }
    }

    final int width = (bounds.width * scaleFactor).round().clamp(100, 8192);
    final int height = (bounds.height * scaleFactor).round().clamp(100, 8192);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    // Draw background
    if (format != ExportFormat.transparentPng) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        Paint()..color = backgroundColor,
      );
    }

    // Transform canvas to match world coordinates
    canvas.save();
    canvas.scale(scaleFactor, scaleFactor);
    canvas.translate(-bounds.left, -bounds.top);

    // Group objects by layer
    final sortedLayers = List<CanvasLayer>.from(layers)
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (final layer in sortedLayers) {
      if (!layer.isVisible) continue;

      final layerObjects = objects.where((o) => o.layerId == layer.id).toList()
        ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      if (layer.opacity < 1.0) {
        canvas.saveLayer(null, Paint()..color = Color.fromRGBO(0, 0, 0, layer.opacity));
      }

      for (final obj in layerObjects) {
        if (!bounds.overlaps(obj.boundingBox)) continue;
        _drawObjectForExport(canvas, obj, loadedImages);
      }

      if (layer.opacity < 1.0) {
        canvas.restore();
      }
    }

    canvas.restore();

    final picture = recorder.endRecording();
    final img = await picture.toImage(width, height);
    final byteData = await img.toByteData(
      format: (format == ExportFormat.jpeg)
          ? ui.ImageByteFormat.rawRgba
          : ui.ImageByteFormat.png,
    );

    if (byteData == null) {
      throw StateError('Failed to encode image byte data');
    }

    if (format == ExportFormat.jpeg) {
      // Convert raw RGBA to PNG/JPEG bytes if needed
      final pngData = await img.toByteData(format: ui.ImageByteFormat.png);
      return pngData!.buffer.asUint8List();
    }

    return byteData.buffer.asUint8List();
  }

  static void _drawObjectForExport(
    Canvas canvas,
    CanvasObject obj,
    Map<String, ui.Image> loadedImages,
  ) {
    if (obj is StrokeCanvasObject) {
      if (obj.points.length < 2) return;
      final paint = Paint()
        ..color = obj.color.withValues(alpha: obj.color.a * obj.opacity)
        ..strokeWidth = obj.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      if (obj.tool == CanvasTool.highlighter) {
        paint.color = obj.color.withValues(alpha: obj.color.a * obj.opacity * 0.4);
        paint.strokeWidth = obj.strokeWidth * 2.5;
        paint.blendMode = BlendMode.multiply;
      }

      final path = Path();
      path.moveTo(obj.points.first.x, obj.points.first.y);
      if (obj.isSmoothed && obj.points.length > 2) {
        for (int i = 1; i < obj.points.length - 1; i++) {
          final p0 = obj.points[i];
          final p1 = obj.points[i + 1];
          path.quadraticBezierTo(p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2);
        }
        path.lineTo(obj.points.last.x, obj.points.last.y);
      } else {
        for (int i = 1; i < obj.points.length; i++) {
          path.lineTo(obj.points[i].x, obj.points[i].y);
        }
      }
      canvas.drawPath(path, paint);
    } else if (obj is ShapeCanvasObject) {
      canvas.save();
      if (obj.rotation != 0) {
        canvas.translate(obj.rect.center.dx, obj.rect.center.dy);
        canvas.rotate(obj.rotation);
        canvas.translate(-obj.rect.center.dx, -obj.rect.center.dy);
      }

      final fillPaint = Paint()
        ..color = obj.fillColor.withValues(alpha: obj.fillColor.a * obj.opacity)
        ..style = PaintingStyle.fill;
      final strokePaint = Paint()
        ..color = obj.strokeColor.withValues(alpha: obj.strokeColor.a * obj.opacity)
        ..strokeWidth = obj.strokeWidth
        ..style = PaintingStyle.stroke;

      if (obj.shapeType == CanvasTool.rectangle) {
        final rrect = RRect.fromRectAndRadius(obj.rect, const Radius.circular(8));
        if (obj.isFilled) canvas.drawRRect(rrect, fillPaint);
        if (obj.strokeWidth > 0) canvas.drawRRect(rrect, strokePaint);
      } else if (obj.shapeType == CanvasTool.circle) {
        if (obj.isFilled) canvas.drawOval(obj.rect, fillPaint);
        if (obj.strokeWidth > 0) canvas.drawOval(obj.rect, strokePaint);
      } else if (obj.shapeType == CanvasTool.line) {
        canvas.drawLine(obj.rect.topLeft, obj.rect.bottomRight, strokePaint);
      }
      canvas.restore();
    } else if (obj is TextCanvasObject) {
      final span = TextSpan(
        text: obj.text,
        style: TextStyle(
          fontSize: obj.fontSize,
          fontWeight: obj.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: obj.isItalic ? FontStyle.italic : FontStyle.normal,
          decoration: obj.isUnderline ? TextDecoration.underline : TextDecoration.none,
          color: obj.color.withValues(alpha: obj.color.a * obj.opacity),
        ),
      );
      final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, obj.position);
    } else if (obj is ImageCanvasObject) {
      final img = loadedImages[obj.imagePath];
      if (img != null) {
        final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
        final dst = Rect.fromLTWH(obj.position.dx, obj.position.dy, obj.width, obj.height);
        canvas.drawImageRect(img, src, dst, Paint());
      }
    }
  }

  static Future<File> exportProjectToFile({
    required String projectName,
    required List<CanvasObject> objects,
    required List<CanvasLayer> layers,
    required CameraState camera,
    required Color backgroundColor,
    required ExportFormat format,
    required ExportBoundsType boundsType,
    required List<String> selectedObjectIds,
    required double scaleFactor,
    required Map<String, ui.Image> loadedImages,
    double? canvasWidth,
    double? canvasHeight,
  }) async {
    final imageBytes = await renderCanvasToImage(
      objects: objects,
      layers: layers,
      camera: camera,
      backgroundColor: backgroundColor,
      format: format,
      boundsType: boundsType,
      selectedObjectIds: selectedObjectIds,
      scaleFactor: scaleFactor,
      loadedImages: loadedImages,
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
    );

    final tempDir = await getTemporaryDirectory();
    final cleanName = projectName.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (format == ExportFormat.pdf) {
      final pdfDoc = pw.Document();
      final pdfImage = pw.MemoryImage(imageBytes);

      pdfDoc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pdfImage, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      final pdfFile = File(p.join(tempDir.path, '${cleanName}_$timestamp.pdf'));
      await pdfFile.writeAsBytes(await pdfDoc.save());
      return pdfFile;
    } else {
      final extension = (format == ExportFormat.jpeg) ? 'jpg' : 'png';
      final file = File(p.join(tempDir.path, '${cleanName}_$timestamp.$extension'));
      await file.writeAsBytes(imageBytes);
      return file;
    }
  }

  static Future<void> shareExportedFile(File file, {String? text}) async {
    final xFile = XFile(file.path);
    await SharePlus.instance.share(
      ShareParams(
        files: [xFile],
        text: text ?? 'Shared from Infinora - Infinite Canvas',
      ),
    );
  }
}
