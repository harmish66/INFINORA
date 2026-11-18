import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../../database/app_database.dart' hide CanvasObject;
import '../../canvas/domain/models/canvas_layer.dart';
import '../../canvas/domain/models/canvas_object.dart';
import '../domain/models/project_model.dart';

class ProjectRepository {
  final AppDatabase db;
  static const _uuid = Uuid();

  ProjectRepository(this.db);

  Future<List<ProjectModel>> getAllProjects({bool includeArchived = false}) async {
    final query = db.select(db.projects);
    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    query.orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    final rows = await query.get();

    final projects = <ProjectModel>[];
    for (final row in rows) {
      final p = await getProjectById(row.id);
      if (p != null) {
        projects.add(p);
      } else {
        projects.add(_projectFromRow(row));
      }
    }
    return projects;
  }

  Future<List<ProjectModel>> getFavoriteProjects() async {
    final query = db.select(db.projects)
      ..where((tbl) => tbl.isFavorite.equals(true) & tbl.isArchived.equals(false))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    final rows = await query.get();

    final projects = <ProjectModel>[];
    for (final row in rows) {
      final p = await getProjectById(row.id);
      if (p != null) {
        projects.add(p);
      } else {
        projects.add(_projectFromRow(row));
      }
    }
    return projects;
  }

  Future<List<ProjectModel>> getArchivedProjects() async {
    final query = db.select(db.projects)
      ..where((tbl) => tbl.isArchived.equals(true))
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.updatedAt)]);
    final rows = await query.get();

    final projects = <ProjectModel>[];
    for (final row in rows) {
      final p = await getProjectById(row.id);
      if (p != null) {
        projects.add(p);
      } else {
        projects.add(_projectFromRow(row));
      }
    }
    return projects;
  }

  Future<ProjectModel?> getProjectById(String id) async {
    final projectRow = await (db.select(db.projects)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (projectRow == null) return null;

    final layerRows = await (db.select(db.layers)
          ..where((tbl) => tbl.projectId.equals(id))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
        .get();

    final objectRows = await (db.select(db.canvasObjects)
          ..where((tbl) => tbl.projectId.equals(id))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.orderIndex)]))
        .get();

    final layers = layerRows
        .map((r) => CanvasLayer(
              id: r.id,
              projectId: r.projectId,
              name: r.name,
              orderIndex: r.orderIndex,
              isVisible: r.isVisible,
              isLocked: r.isLocked,
              opacity: r.opacity,
            ))
        .toList();

    final objects = objectRows.map((r) {
      final json = jsonDecode(r.data) as Map<String, dynamic>;
      return CanvasObject.fromJson(json);
    }).toList();

    return _projectFromRow(projectRow).copyWith(
      layers: layers,
      objects: objects,
    );
  }

  Future<void> saveProject(ProjectModel project) async {
    await db.transaction(() async {
      // Upsert project
      await db.into(db.projects).insertOnConflictUpdate(ProjectsCompanion(
        id: Value(project.id),
        name: Value(project.name),
        createdAt: Value(project.createdAt),
        updatedAt: Value(DateTime.now()),
        isFavorite: Value(project.isFavorite),
        isArchived: Value(project.isArchived),
        thumbnailPath: Value(project.thumbnailPath),
        canvasWidth: Value(project.canvasWidth),
        canvasHeight: Value(project.canvasHeight),
        backgroundColor: Value(project.backgroundColor.toARGB32()),
        showGrid: Value(project.showGrid),
        gridStyle: Value(project.gridStyle),
        cameraX: Value(project.cameraX),
        cameraY: Value(project.cameraY),
        cameraZoom: Value(project.cameraZoom),
        documentVersion: Value(project.documentVersion),
      ));

      // Synchronize layers
      await (db.delete(db.layers)..where((tbl) => tbl.projectId.equals(project.id))).go();
      for (final layer in project.layers) {
        await db.into(db.layers).insert(LayersCompanion(
          id: Value(layer.id),
          projectId: Value(project.id),
          name: Value(layer.name),
          orderIndex: Value(layer.orderIndex),
          isVisible: Value(layer.isVisible),
          isLocked: Value(layer.isLocked),
          opacity: Value(layer.opacity),
        ));
      }

      // Synchronize objects
      await (db.delete(db.canvasObjects)..where((tbl) => tbl.projectId.equals(project.id))).go();
      for (final obj in project.objects) {
        await db.into(db.canvasObjects).insert(CanvasObjectsCompanion(
          id: Value(obj.id),
          projectId: Value(project.id),
          layerId: Value(obj.layerId),
          type: Value(obj.toJson()['type'] as String),
          orderIndex: Value(obj.orderIndex),
          data: Value(jsonEncode(obj.toJson())),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
        ));
      }
    });
  }

  Future<void> deleteProject(String id) async {
    await db.transaction(() async {
      await (db.delete(db.canvasObjects)..where((tbl) => tbl.projectId.equals(id))).go();
      await (db.delete(db.layers)..where((tbl) => tbl.projectId.equals(id))).go();
      await (db.delete(db.projects)..where((tbl) => tbl.id.equals(id))).go();
    });
  }

  Future<ProjectModel> duplicateProject(String id, String newName) async {
    final original = await getProjectById(id);
    if (original == null) throw StateError('Project not found');

    final newProjectId = _uuid.v4();
    final layerIdMap = <String, String>{};

    final newLayers = original.layers.map((l) {
      final newLayerId = _uuid.v4();
      layerIdMap[l.id] = newLayerId;
      return l.copyWith(id: newLayerId, projectId: newProjectId);
    }).toList();

    final newObjects = original.objects.map((o) {
      final targetLayerId = layerIdMap[o.layerId] ?? (newLayers.isNotEmpty ? newLayers.first.id : 'layer-1');
      final json = o.toJson();
      json['id'] = _uuid.v4();
      json['layerId'] = targetLayerId;
      return CanvasObject.fromJson(json);
    }).toList();

    final duplicated = original.copyWith(
      id: newProjectId,
      name: newName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      layers: newLayers,
      objects: newObjects,
    );

    await saveProject(duplicated);
    return duplicated;
  }

  Future<void> toggleFavorite(String id, bool isFavorite) async {
    await (db.update(db.projects)..where((tbl) => tbl.id.equals(id))).write(
      ProjectsCompanion(isFavorite: Value(isFavorite)),
    );
  }

  Future<void> toggleArchive(String id, bool isArchived) async {
    await (db.update(db.projects)..where((tbl) => tbl.id.equals(id))).write(
      ProjectsCompanion(isArchived: Value(isArchived)),
    );
  }

  Future<String?> saveThumbnail(String projectId, Uint8List pngBytes) async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final thumbDir = Directory(p.join(docsDir.path, 'thumbnails'));
      if (!thumbDir.existsSync()) {
        thumbDir.createSync(recursive: true);
      }
      final filePath = p.join(thumbDir.path, '$projectId.png');
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await (db.update(db.projects)..where((tbl) => tbl.id.equals(projectId))).write(
        ProjectsCompanion(thumbnailPath: Value(filePath)),
      );
      return filePath;
    } catch (e) {
      debugPrint('Error saving thumbnail: $e');
      return null;
    }
  }

  ProjectModel _projectFromRow(Project row) {
    return ProjectModel(
      id: row.id,
      name: row.name,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isFavorite: row.isFavorite,
      isArchived: row.isArchived,
      thumbnailPath: row.thumbnailPath,
      canvasWidth: row.canvasWidth,
      canvasHeight: row.canvasHeight,
      backgroundColor: Color(row.backgroundColor),
      showGrid: row.showGrid,
      gridStyle: row.gridStyle,
      cameraX: row.cameraX,
      cameraY: row.cameraY,
      cameraZoom: row.cameraZoom,
      documentVersion: row.documentVersion,
    );
  }
}
