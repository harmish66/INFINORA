import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinora/database/app_database.dart' hide CanvasObject;
import 'package:infinora/features/canvas/domain/models/canvas_layer.dart';
import 'package:infinora/features/canvas/domain/models/canvas_object.dart';
import 'package:infinora/features/canvas/domain/models/canvas_point.dart';
import 'package:infinora/features/canvas/domain/models/canvas_tool.dart';
import 'package:infinora/features/projects/data/project_repository.dart';
import 'package:infinora/features/projects/domain/models/project_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late ProjectRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ProjectRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drawing Persistence Tests', () {
    test('Saving project with drawing strokes preserves all objects on reload', () async {
      const projectId = 'test-proj-persistence-1';
      const layerId = 'test-layer-1';

      final stroke1 = StrokeCanvasObject(
        id: 'stroke-1',
        layerId: layerId,
        orderIndex: 0,
        tool: CanvasTool.pen,
        color: const Color(0xFF6558F5),
        strokeWidth: 4.0,
        points: const [
          CanvasPoint(x: 10, y: 10),
          CanvasPoint(x: 20, y: 25),
          CanvasPoint(x: 40, y: 50),
        ],
      );

      final stroke2 = StrokeCanvasObject(
        id: 'stroke-2',
        layerId: layerId,
        orderIndex: 1,
        tool: CanvasTool.brush,
        color: const Color(0xFFF05BCB),
        strokeWidth: 8.0,
        points: const [
          CanvasPoint(x: 100, y: 100),
          CanvasPoint(x: 150, y: 120),
        ],
      );

      final project = ProjectModel(
        id: projectId,
        name: 'My Masterpiece',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        layers: [
          const CanvasLayer(
            id: layerId,
            projectId: projectId,
            name: 'Layer 1',
            orderIndex: 0,
            isVisible: true,
            isLocked: false,
            opacity: 1.0,
          ),
        ],
        objects: [stroke1, stroke2],
      );

      // Save to database
      await repository.saveProject(project);

      // 1. Verify getProjectById loads all objects
      final loadedById = await repository.getProjectById(projectId);
      expect(loadedById, isNotNull);
      expect(loadedById!.objects.length, 2);
      expect(loadedById.objects[0].id, 'stroke-1');
      expect((loadedById.objects[0] as StrokeCanvasObject).points.length, 3);
      expect(loadedById.objects[1].id, 'stroke-2');
      expect((loadedById.objects[1] as StrokeCanvasObject).points.length, 2);

      // 2. Verify getAllProjects loads all objects for home screen cards
      final allProjects = await repository.getAllProjects();
      expect(allProjects, isNotEmpty);
      final found = allProjects.firstWhere((p) => p.id == projectId);
      expect(found.objects.length, 2);
      expect(found.objects.first.id, 'stroke-1');
    });
  });
}
