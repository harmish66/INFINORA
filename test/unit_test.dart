import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinora/features/canvas/domain/models/camera_state.dart';
import 'package:infinora/features/canvas/domain/models/canvas_layer.dart';
import 'package:infinora/features/canvas/domain/models/canvas_object.dart';
import 'package:infinora/features/canvas/domain/models/canvas_point.dart';
import 'package:infinora/features/canvas/domain/models/canvas_tool.dart';
import 'package:infinora/features/canvas/domain/models/undo_redo_history.dart';
import 'package:infinora/features/templates/data/template_presets.dart';

class MockCommandContext implements CanvasCommandContext {
  @override
  List<CanvasObject> objects = [];
  @override
  List<CanvasLayer> layers = [];

  @override
  void addObject(CanvasObject object) => objects.add(object);
  @override
  void removeObject(String id) => objects.removeWhere((o) => o.id == id);
  @override
  void updateObject(CanvasObject object) {
    final idx = objects.indexWhere((o) => o.id == object.id);
    if (idx != -1) objects[idx] = object;
  }
  @override
  void setObjects(List<CanvasObject> newObjects) => objects = List.from(newObjects);
  @override
  void addLayer(CanvasLayer layer) => layers.add(layer);
  @override
  void removeLayer(String id) => layers.removeWhere((l) => l.id == id);
  @override
  void updateLayer(CanvasLayer layer) {
    final idx = layers.indexWhere((l) => l.id == layer.id);
    if (idx != -1) layers[idx] = layer;
  }
  @override
  void setLayers(List<CanvasLayer> newLayers) => layers = List.from(newLayers);
}

void main() {
  group('CameraState Tests', () {
    test('Coordinate transformations between screen and world', () {
      const camera = CameraState(
        offset: Offset(100, 200),
        zoom: 2.0,
        viewportSize: Size(800, 600),
      );

      final screenPoint = const Offset(300, 400);
      final worldPoint = camera.screenToWorld(screenPoint);

      // world = (screen - offset) / zoom = (300-100)/2 = 100, (400-200)/2 = 100
      expect(worldPoint.dx, 100.0);
      expect(worldPoint.dy, 100.0);

      final backToScreen = camera.worldToScreen(worldPoint);
      expect(backToScreen.dx, screenPoint.dx);
      expect(backToScreen.dy, screenPoint.dy);
    });

    test('Zoom at focal point keeps world point invariant', () {
      const camera = CameraState(
        offset: Offset(50, 50),
        zoom: 1.0,
        viewportSize: Size(1000, 1000),
      );

      final focalPoint = const Offset(500, 500);
      final worldBefore = camera.screenToWorld(focalPoint);

      final zoomedCamera = camera.zoomAt(focalPoint, 2.0);
      final worldAfter = zoomedCamera.screenToWorld(focalPoint);

      expect(zoomedCamera.zoom, 2.0);
      expect((worldBefore.dx - worldAfter.dx).abs() < 0.001, true);
      expect((worldBefore.dy - worldAfter.dy).abs() < 0.001, true);
    });

    test('Pan delta updates offset accurately', () {
      const camera = CameraState(offset: Offset(10, 20), zoom: 1.0);
      final panned = camera.pan(const Offset(30, 40));
      expect(panned.offset.dx, 40.0);
      expect(panned.offset.dy, 60.0);
    });
  });

  group('CanvasObject Tests', () {
    test('StrokeCanvasObject hit test and serialization', () {
      final stroke = StrokeCanvasObject(
        id: 'stroke-1',
        layerId: 'layer-1',
        orderIndex: 0,
        tool: CanvasTool.pen,
        points: const [
          CanvasPoint(x: 10, y: 10),
          CanvasPoint(x: 50, y: 50),
        ],
        color: Colors.black,
        strokeWidth: 4.0,
      );

      expect(stroke.hitTest(const Offset(30, 30)), true);
      expect(stroke.hitTest(const Offset(200, 200)), false);

      final json = stroke.toJson();
      final revived = CanvasObject.fromJson(json);

      expect(revived is StrokeCanvasObject, true);
      expect((revived as StrokeCanvasObject).id, 'stroke-1');
      expect(revived.points.length, 2);
    });

    test('ShapeCanvasObject boundingBox and translation', () {
      final shape = ShapeCanvasObject(
        id: 'shape-1',
        layerId: 'layer-1',
        orderIndex: 0,
        shapeType: CanvasTool.rectangle,
        rect: const Rect.fromLTWH(20, 20, 100, 80),
        strokeColor: Colors.blue,
        fillColor: Colors.transparent,
        strokeWidth: 2.0,
      );

      expect(shape.boundingBox.left, 19.0); // 20 - 2/2
      expect(shape.hitTest(const Offset(50, 50)), true);

      final moved = shape.translate(const Offset(10, 15));
      expect(moved.rect.left, 30.0);
      expect(moved.rect.top, 35.0);
    });

    test('ImageCanvasObject scaling and resizing', () {
      const img = ImageCanvasObject(
        id: 'img-1',
        layerId: 'layer-1',
        orderIndex: 0,
        imagePath: '/path/to/img.png',
        position: Offset(100, 100),
        width: 200,
        height: 100,
      );

      // Scale 1.5x from center (200, 150)
      final scaled = img.scale(1.5, const Offset(200, 150));
      expect(scaled.width, 300.0);
      expect(scaled.height, 150.0);
      expect(scaled.position.dx, 50.0);
      expect(scaled.position.dy, 75.0);
    });

    test('TextCanvasObject JSON serialization', () {
      final textObj = TextCanvasObject(
        id: 'text-1',
        layerId: 'layer-1',
        orderIndex: 1,
        text: 'Hello Infinora',
        position: const Offset(100, 150),
        fontSize: 24,
        color: Colors.black,
      );

      final json = textObj.toJson();
      final revived = CanvasObject.fromJson(json) as TextCanvasObject;
      expect(revived.text, 'Hello Infinora');
      expect(revived.position.dx, 100.0);
      expect(revived.position.dy, 150.0);
    });
  });

  group('Undo/Redo History Tests', () {
    test('AddObjectCommand execute and undo', () {
      final context = MockCommandContext();
      final history = HistoryManager();

      final obj = TextCanvasObject(
        id: 'obj-1',
        layerId: 'l1',
        orderIndex: 0,
        text: 'Test',
        position: Offset.zero,
        color: Colors.black,
      );

      history.record(AddObjectCommand(obj), context);
      expect(context.objects.length, 1);
      expect(history.canUndo, true);
      expect(history.canRedo, false);

      history.undo(context);
      expect(context.objects.isEmpty, true);
      expect(history.canUndo, false);
      expect(history.canRedo, true);

      history.redo(context);
      expect(context.objects.length, 1);
    });

    test('MoveObjectsCommand moves and reverts', () {
      final context = MockCommandContext();
      final history = HistoryManager();

      final obj = TextCanvasObject(
        id: 'obj-1',
        layerId: 'l1',
        orderIndex: 0,
        text: 'Moving',
        position: const Offset(10, 10),
        color: Colors.black,
      );
      context.addObject(obj);

      history.record(MoveObjectsCommand(objectIds: ['obj-1'], dx: 25, dy: 35), context);
      expect((context.objects.first as TextCanvasObject).position.dx, 35.0);
      expect((context.objects.first as TextCanvasObject).position.dy, 45.0);

      history.undo(context);
      expect((context.objects.first as TextCanvasObject).position.dx, 10.0);
      expect((context.objects.first as TextCanvasObject).position.dy, 10.0);
    });

    test('ReorderObjectsCommand changes z-index and undoes cleanly', () {
      final context = MockCommandContext();
      final history = HistoryManager();

      final obj1 = TextCanvasObject(
        id: 'o1',
        layerId: 'l1',
        orderIndex: 0,
        text: 'Bottom',
        position: Offset.zero,
        color: Colors.black,
      );
      final obj2 = TextCanvasObject(
        id: 'o2',
        layerId: 'l1',
        orderIndex: 1,
        text: 'Top',
        position: Offset.zero,
        color: Colors.black,
      );
      context.setObjects([obj1, obj2]);

      final reordered = [
        obj2.withOrderIndex(0),
        obj1.withOrderIndex(1),
      ];
      history.record(
        ReorderObjectsCommand(oldObjects: [obj1, obj2], newObjects: reordered),
        context,
      );

      expect(context.objects.first.id, 'o2');
      expect(context.objects.first.orderIndex, 0);
      expect(context.objects.last.id, 'o1');
      expect(context.objects.last.orderIndex, 1);

      history.undo(context);
      expect(context.objects.first.id, 'o1');
      expect(context.objects.last.id, 'o2');
    });
  });

  group('Template Presets Tests', () {
    test('Library has at least 60 curated templates across 18 categories', () {
      final templates = TemplatePresets.allTemplates;
      expect(templates.length >= 60, true, reason: 'Must have at least 60 templates');

      final categories = TemplatePresets.categories.where((c) => c != 'All').toList();
      expect(categories.length, 18, reason: 'Must cover 18 categories');

      for (final cat in categories) {
        final catTemplates = templates.where((t) => t.category == cat).toList();
        expect(catTemplates.isNotEmpty, true, reason: 'Category $cat must have templates');
      }
    });

    test('All templates generate valid project models with layers and editable objects', () {
      final templates = TemplatePresets.allTemplates;
      expect(templates.isNotEmpty, true);

      for (final tmpl in templates) {
        final project = tmpl.toProject(tmpl.title);
        expect(project.id.isNotEmpty, true);
        expect(project.layers.isNotEmpty, true);
        expect(project.name, tmpl.title);
        expect(tmpl.difficulty.isNotEmpty, true);
        expect(tmpl.suggestedUsage.isNotEmpty, true);

        // Verify cloning independence: editing project objects does not alter template
        final originalCount = tmpl.buildObjects('test-p', 'test-l').length;
        if (project.objects.isNotEmpty) {
          project.objects.clear();
          final freshObjects = tmpl.buildObjects('test-p', 'test-l');
          expect(freshObjects.length, originalCount);
        }
      }
    });

    test('Infinite Zoom collection contains deep nested structures', () {
      final zoomTemplates = TemplatePresets.getByCategory('Infinite Zoom Art');
      expect(zoomTemplates.length >= 8, true);

      final pip = zoomTemplates.firstWhere((t) => t.id == 'zoom_picture_in_picture');
      expect(pip.initialZoom, 1.0);
      final objects = pip.buildObjects('p', 'l');
      expect(objects.length >= 5, true);
    });
  });
}
