import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../canvas/domain/models/canvas_layer.dart';
import '../../../canvas/domain/models/canvas_object.dart';
import '../../../projects/domain/models/project_model.dart';

class TemplateModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final IconData icon;
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final List<String> tags;
  final bool isPremium;
  final bool isFeatured;
  final bool isTrending;
  final bool isEditorsPick;
  final String suggestedUsage;
  final double? canvasWidth;
  final double? canvasHeight;
  final Color backgroundColor;
  final String gridStyle;
  final double initialZoom;
  final double initialCameraX;
  final double initialCameraY;
  final List<CanvasObject> Function(String projectId, String layerId) buildObjects;

  const TemplateModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    this.difficulty = 'Beginner',
    this.tags = const [],
    this.isPremium = false,
    this.isFeatured = false,
    this.isTrending = false,
    this.isEditorsPick = false,
    this.suggestedUsage = 'Open canvas and sketch, annotate, or expand on the existing vector layers.',
    this.canvasWidth,
    this.canvasHeight,
    this.backgroundColor = Colors.white,
    this.gridStyle = 'dots',
    this.initialZoom = 1.0,
    this.initialCameraX = 0.0,
    this.initialCameraY = 0.0,
    required this.buildObjects,
  });

  ProjectModel toProject(String name) {
    const uuid = Uuid();
    final projectId = uuid.v4();
    final defaultLayerId = uuid.v4();

    final defaultLayer = CanvasLayer(
      id: defaultLayerId,
      projectId: projectId,
      name: 'Layer 1',
      orderIndex: 0,
      isVisible: true,
      isLocked: false,
      opacity: 1.0,
    );

    final objects = buildObjects(projectId, defaultLayerId);

    return ProjectModel(
      id: projectId,
      name: name.isEmpty ? title : name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      canvasWidth: canvasWidth,
      canvasHeight: canvasHeight,
      backgroundColor: backgroundColor,
      showGrid: true,
      gridStyle: gridStyle,
      cameraX: initialCameraX,
      cameraY: initialCameraY,
      cameraZoom: initialZoom,
      layers: [defaultLayer],
      objects: objects,
    );
  }
}
