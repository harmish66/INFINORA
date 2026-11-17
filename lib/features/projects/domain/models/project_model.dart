import 'package:flutter/material.dart';
import '../../../canvas/domain/models/canvas_layer.dart';
import '../../../canvas/domain/models/canvas_object.dart';

class ProjectModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isArchived;
  final String? thumbnailPath;
  final double? canvasWidth;
  final double? canvasHeight;
  final Color backgroundColor;
  final bool showGrid;
  final String gridStyle; // 'dots', 'lines', 'cross', 'isometric'
  final double cameraX;
  final double cameraY;
  final double cameraZoom;
  final int documentVersion;
  final List<CanvasLayer> layers;
  final List<CanvasObject> objects;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
    this.isArchived = false,
    this.thumbnailPath,
    this.canvasWidth,
    this.canvasHeight,
    this.backgroundColor = Colors.white,
    this.showGrid = true,
    this.gridStyle = 'dots',
    this.cameraX = 0.0,
    this.cameraY = 0.0,
    this.cameraZoom = 1.0,
    this.documentVersion = 1,
    this.layers = const [],
    this.objects = const [],
  });

  bool get isInfinite => canvasWidth == null || canvasHeight == null;

  ProjectModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isArchived,
    String? thumbnailPath,
    double? canvasWidth,
    double? canvasHeight,
    Color? backgroundColor,
    bool? showGrid,
    String? gridStyle,
    double? cameraX,
    double? cameraY,
    double? cameraZoom,
    int? documentVersion,
    List<CanvasLayer>? layers,
    List<CanvasObject>? objects,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showGrid: showGrid ?? this.showGrid,
      gridStyle: gridStyle ?? this.gridStyle,
      cameraX: cameraX ?? this.cameraX,
      cameraY: cameraY ?? this.cameraY,
      cameraZoom: cameraZoom ?? this.cameraZoom,
      documentVersion: documentVersion ?? this.documentVersion,
      layers: layers ?? this.layers,
      objects: objects ?? this.objects,
    );
  }
}
