import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/providers/app_providers.dart';
import '../../domain/models/camera_state.dart';
import '../../domain/models/canvas_layer.dart';
import '../../domain/models/canvas_object.dart';
import '../../domain/models/canvas_point.dart';
import '../../domain/models/canvas_tool.dart';
import '../../domain/models/undo_redo_history.dart';
import '../../../projects/domain/models/project_model.dart';
import '../../../export/data/export_service.dart';

enum ObjectAlignment { left, centerH, right, top, centerV, bottom }

class CanvasState implements CanvasCommandContext {
  final ProjectModel project;
  final CameraState camera;
  final CanvasTool selectedTool;
  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;
  final double opacity;
  final bool isFilled;
  final String activeLayerId;
  final List<String> selectedObjectIds;
  final bool isSaving;
  final DateTime? lastSavedTime;
  final bool canUndo;
  final bool canRedo;
  final bool showMinimap;
  final bool showLayersPanel;
  final bool showBrushSettings;
  final Map<String, ui.Image> loadedImages;
  final StrokeCanvasObject? activeStroke;
  final ShapeCanvasObject? activeShapePreview;
  final Rect? activeSelectionRect;

  const CanvasState({
    required this.project,
    required this.camera,
    this.selectedTool = CanvasTool.pen,
    this.strokeColor = const Color(0xFF191A2E),
    this.fillColor = const Color(0xFF6558F5),
    this.strokeWidth = 4.0,
    this.opacity = 1.0,
    this.isFilled = false,
    required this.activeLayerId,
    this.selectedObjectIds = const [],
    this.isSaving = false,
    this.lastSavedTime,
    this.canUndo = false,
    this.canRedo = false,
    this.showMinimap = false,
    this.showLayersPanel = false,
    this.showBrushSettings = false,
    this.loadedImages = const {},
    this.activeStroke,
    this.activeShapePreview,
    this.activeSelectionRect,
  });

  @override
  List<CanvasObject> get objects => project.objects;

  @override
  List<CanvasLayer> get layers => project.layers;

  @override
  void addObject(CanvasObject object) {}

  @override
  void removeObject(String id) {}

  @override
  void updateObject(CanvasObject object) {}

  @override
  void setObjects(List<CanvasObject> newObjects) {}

  @override
  void addLayer(CanvasLayer layer) {}

  @override
  void removeLayer(String id) {}

  @override
  void updateLayer(CanvasLayer layer) {}

  @override
  void setLayers(List<CanvasLayer> newLayers) {}

  CanvasState copyWith({
    ProjectModel? project,
    CameraState? camera,
    CanvasTool? selectedTool,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    double? opacity,
    bool? isFilled,
    String? activeLayerId,
    List<String>? selectedObjectIds,
    bool? isSaving,
    DateTime? lastSavedTime,
    bool? canUndo,
    bool? canRedo,
    bool? showMinimap,
    bool? showLayersPanel,
    bool? showBrushSettings,
    Map<String, ui.Image>? loadedImages,
    StrokeCanvasObject? activeStroke,
    ShapeCanvasObject? activeShapePreview,
    Rect? activeSelectionRect,
    bool clearActiveStroke = false,
    bool clearActiveShape = false,
    bool clearActiveSelectionRect = false,
  }) {
    return CanvasState(
      project: project ?? this.project,
      camera: camera ?? this.camera,
      selectedTool: selectedTool ?? this.selectedTool,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      opacity: opacity ?? this.opacity,
      isFilled: isFilled ?? this.isFilled,
      activeLayerId: activeLayerId ?? this.activeLayerId,
      selectedObjectIds: selectedObjectIds ?? this.selectedObjectIds,
      isSaving: isSaving ?? this.isSaving,
      lastSavedTime: lastSavedTime ?? this.lastSavedTime,
      canUndo: canUndo ?? this.canUndo,
      canRedo: canRedo ?? this.canRedo,
      showMinimap: showMinimap ?? this.showMinimap,
      showLayersPanel: showLayersPanel ?? this.showLayersPanel,
      showBrushSettings: showBrushSettings ?? this.showBrushSettings,
      loadedImages: loadedImages ?? this.loadedImages,
      activeStroke: clearActiveStroke ? null : (activeStroke ?? this.activeStroke),
      activeShapePreview: clearActiveShape ? null : (activeShapePreview ?? this.activeShapePreview),
      activeSelectionRect: clearActiveSelectionRect ? null : (activeSelectionRect ?? this.activeSelectionRect),
    );
  }
}

class CanvasController extends Notifier<CanvasState> implements CanvasCommandContext {
  final ProjectModel initialProject;
  final HistoryManager _historyManager = HistoryManager();
  Timer? _autosaveTimer;
  static const _uuid = Uuid();

  // Gesture tracking
  Offset? _initialFocalPoint;
  double _initialZoom = 1.0;
  Offset _initialCameraOffset = Offset.zero;
  int _pointerCount = 0;
  Offset? _selectionDragStart;
  bool _isMovingSelection = false;
  bool _isScalingSelection = false;
  Offset? _scaleAnchor;
  double _scaleInitialDist = 1.0;
  List<CanvasObject> _preTransformSelectedObjects = [];

  CanvasController(this.initialProject);

  @override
  CanvasState build() {
    ref.onDispose(() {
      _autosaveTimer?.cancel();
    });

    final defaultLayerId = initialProject.layers.isNotEmpty
        ? initialProject.layers.first.id
        : _uuid.v4();

    final project = initialProject.layers.isEmpty
        ? initialProject.copyWith(
            layers: [
              CanvasLayer(
                id: defaultLayerId,
                projectId: initialProject.id,
                name: 'Layer 1',
                orderIndex: 0,
                isVisible: true,
                isLocked: false,
                opacity: 1.0,
              ),
            ],
          )
        : initialProject;

    Future.microtask(() => _loadExistingImages());

    return CanvasState(
      project: project,
      camera: CameraState(
        offset: Offset(project.cameraX, project.cameraY),
        zoom: project.cameraZoom,
      ),
      activeLayerId: defaultLayerId,
    );
  }

  @override
  List<CanvasObject> get objects => state.project.objects;

  @override
  List<CanvasLayer> get layers => state.project.layers;

  Future<void> _loadExistingImages() async {
    final imagesMap = Map<String, ui.Image>.from(state.loadedImages);
    for (final obj in state.project.objects) {
      if (obj is ImageCanvasObject) {
        if (!imagesMap.containsKey(obj.imagePath)) {
          final loaded = await _loadImageFromFile(obj.imagePath);
          if (loaded != null) {
            imagesMap[obj.imagePath] = loaded;
          }
        }
      }
    }
    state = state.copyWith(loadedImages: imagesMap);
  }

  Future<ui.Image?> _loadImageFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(bytes);
      final frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    } catch (e) {
      debugPrint('Error loading image file: $e');
      return null;
    }
  }

  // --- CanvasCommandContext implementations ---
  @override
  void addObject(CanvasObject object) {
    final updated = List<CanvasObject>.from(state.project.objects)..add(object);
    state = state.copyWith(project: state.project.copyWith(objects: updated));
    _triggerAutosave();
  }

  @override
  void removeObject(String id) {
    final updated = state.project.objects.where((o) => o.id != id).toList();
    state = state.copyWith(project: state.project.copyWith(objects: updated));
    _triggerAutosave();
  }

  @override
  void updateObject(CanvasObject object) {
    final updated = state.project.objects.map((o) => o.id == object.id ? object : o).toList();
    state = state.copyWith(project: state.project.copyWith(objects: updated));
    _triggerAutosave();
  }

  @override
  void setObjects(List<CanvasObject> newObjects) {
    state = state.copyWith(project: state.project.copyWith(objects: newObjects));
    _triggerAutosave();
  }

  @override
  void addLayer(CanvasLayer layer) {
    final updated = List<CanvasLayer>.from(state.project.layers)..add(layer);
    state = state.copyWith(
      project: state.project.copyWith(layers: updated),
      activeLayerId: layer.id,
    );
    _triggerAutosave();
  }

  @override
  void removeLayer(String id) {
    if (state.project.layers.length <= 1) return; // Keep at least one layer
    final updated = state.project.layers.where((l) => l.id != id).toList();
    final remainingObjects = state.project.objects.where((o) => o.layerId != id).toList();
    state = state.copyWith(
      project: state.project.copyWith(layers: updated, objects: remainingObjects),
      activeLayerId: updated.first.id,
    );
    _triggerAutosave();
  }

  @override
  void updateLayer(CanvasLayer layer) {
    final updated = state.project.layers.map((l) => l.id == layer.id ? layer : l).toList();
    state = state.copyWith(project: state.project.copyWith(layers: updated));
    _triggerAutosave();
  }

  @override
  void setLayers(List<CanvasLayer> newLayers) {
    state = state.copyWith(project: state.project.copyWith(layers: newLayers));
    _triggerAutosave();
  }

  // --- Tool & Style Selection ---
  void setTool(CanvasTool tool) {
    state = state.copyWith(
      selectedTool: tool,
      clearActiveStroke: true,
      clearActiveShape: true,
      clearActiveSelectionRect: true,
      selectedObjectIds: tool == CanvasTool.select ? state.selectedObjectIds : [],
    );
  }

  void setColor(Color color) {
    state = state.copyWith(strokeColor: color);
  }

  void setFillColor(Color color) {
    state = state.copyWith(fillColor: color);
  }

  void setStrokeWidth(double width) {
    state = state.copyWith(strokeWidth: width);
  }

  void setOpacity(double opacity) {
    state = state.copyWith(opacity: opacity);
  }

  void setIsFilled(bool filled) {
    state = state.copyWith(isFilled: filled);
  }

  void updateViewportSize(Size size) {
    if (state.camera.viewportSize != size) {
      state = state.copyWith(camera: state.camera.copyWith(viewportSize: size));
    }
  }

  // --- Gesture Handling ---
  void onScaleStart(ScaleStartDetails details) {
    _pointerCount = details.pointerCount;
    _initialFocalPoint = details.localFocalPoint;
    _initialZoom = state.camera.zoom;
    _initialCameraOffset = state.camera.offset;

    if (_pointerCount > 1 || state.selectedTool == CanvasTool.pan) {
      // Pinch to zoom or pan mode
      return;
    }

    final worldPoint = state.camera.screenToWorld(details.localFocalPoint);

    if (state.selectedTool == CanvasTool.select) {
      final selectedObjects = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
      if (selectedObjects.isNotEmpty) {
        Rect unionBounds = selectedObjects.first.boundingBox;
        for (int i = 1; i < selectedObjects.length; i++) {
          unionBounds = unionBounds.expandToInclude(selectedObjects[i].boundingBox);
        }
        final paddedBounds = unionBounds.inflate(8.0);
        final touchTolerance = 24.0 / state.camera.zoom;

        // Check if tapping corner handles for scaling
        if ((worldPoint - paddedBounds.topLeft).distance <= touchTolerance) {
          _isScalingSelection = true;
          _scaleAnchor = paddedBounds.bottomRight;
          _scaleInitialDist = (worldPoint - _scaleAnchor!).distance;
          _preTransformSelectedObjects = selectedObjects;
          return;
        } else if ((worldPoint - paddedBounds.topRight).distance <= touchTolerance) {
          _isScalingSelection = true;
          _scaleAnchor = paddedBounds.bottomLeft;
          _scaleInitialDist = (worldPoint - _scaleAnchor!).distance;
          _preTransformSelectedObjects = selectedObjects;
          return;
        } else if ((worldPoint - paddedBounds.bottomLeft).distance <= touchTolerance) {
          _isScalingSelection = true;
          _scaleAnchor = paddedBounds.topRight;
          _scaleInitialDist = (worldPoint - _scaleAnchor!).distance;
          _preTransformSelectedObjects = selectedObjects;
          return;
        } else if ((worldPoint - paddedBounds.bottomRight).distance <= touchTolerance) {
          _isScalingSelection = true;
          _scaleAnchor = paddedBounds.topLeft;
          _scaleInitialDist = (worldPoint - _scaleAnchor!).distance;
          _preTransformSelectedObjects = selectedObjects;
          return;
        }
      }

      // Check if tapping on an already selected object to move it
      final hitSelected = state.selectedObjectIds.any((id) {
        final obj = state.project.objects.firstWhere((o) => o.id == id, orElse: () => state.project.objects.first);
        return obj.hitTest(worldPoint);
      });

      if (hitSelected) {
        _isMovingSelection = true;
        _selectionDragStart = worldPoint;
        _preTransformSelectedObjects = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
      } else {
        // Hit test any object
        final hit = _hitTestObjects(worldPoint);
        if (hit != null) {
          state = state.copyWith(selectedObjectIds: [hit.id]);
          _isMovingSelection = true;
          _selectionDragStart = worldPoint;
          _preTransformSelectedObjects = [hit];
        } else {
          // Start marquee selection box
          state = state.copyWith(
            selectedObjectIds: [],
            activeSelectionRect: Rect.fromPoints(worldPoint, worldPoint),
          );
        }
      }
      return;
    }

    // Check active layer is not locked or hidden
    final currentLayer = state.project.layers.firstWhere(
      (l) => l.id == state.activeLayerId,
      orElse: () => state.project.layers.first,
    );
    if (currentLayer.isLocked || !currentLayer.isVisible) return;

    if (state.selectedTool.isDrawingStroke) {
      final newStroke = StrokeCanvasObject(
        id: _uuid.v4(),
        layerId: state.activeLayerId,
        orderIndex: state.project.objects.length,
        tool: state.selectedTool,
        points: [CanvasPoint(x: worldPoint.dx, y: worldPoint.dy)],
        color: state.strokeColor,
        strokeWidth: state.strokeWidth,
        opacity: state.opacity,
      );
      state = state.copyWith(activeStroke: newStroke);
    } else if (state.selectedTool.isShape) {
      final newShape = ShapeCanvasObject(
        id: _uuid.v4(),
        layerId: state.activeLayerId,
        orderIndex: state.project.objects.length,
        shapeType: state.selectedTool,
        rect: Rect.fromPoints(worldPoint, worldPoint),
        strokeColor: state.strokeColor,
        fillColor: state.fillColor,
        strokeWidth: state.strokeWidth,
        opacity: state.opacity,
        isFilled: state.isFilled,
      );
      state = state.copyWith(activeShapePreview: newShape);
    } else if (state.selectedTool == CanvasTool.eraser) {
      _eraseAt(worldPoint);
    }
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount > 1 || state.selectedTool == CanvasTool.pan) {
      // Two-finger zoom/pan or Hand Pan tool
      final double newZoom = (_initialZoom * details.scale).clamp(CameraState.minZoom, CameraState.maxZoom);
      final Offset focalDelta = details.localFocalPoint - (_initialFocalPoint ?? details.localFocalPoint);

      final worldFocal = (details.localFocalPoint - _initialCameraOffset) / _initialZoom;
      final newOffset = details.localFocalPoint - worldFocal * newZoom + (details.scale == 1.0 ? focalDelta : Offset.zero);

      state = state.copyWith(
        camera: state.camera.copyWith(
          offset: details.scale == 1.0 ? _initialCameraOffset + focalDelta : newOffset,
          zoom: newZoom,
        ),
      );
      return;
    }

    final worldPoint = state.camera.screenToWorld(details.localFocalPoint);

    if (state.selectedTool == CanvasTool.select) {
      if (_isScalingSelection && _scaleAnchor != null && _scaleInitialDist > 0) {
        final currentDist = (worldPoint - _scaleAnchor!).distance;
        final factor = (currentDist / _scaleInitialDist).clamp(0.05, 20.0);
        final scaledObjects = _preTransformSelectedObjects.map((o) {
          return o.scale(factor, _scaleAnchor!);
        }).toList();

        final updated = state.project.objects.map((o) {
          final idx = scaledObjects.indexWhere((s) => s.id == o.id);
          return idx != -1 ? scaledObjects[idx] : o;
        }).toList();
        state = state.copyWith(project: state.project.copyWith(objects: updated));
        return;
      }

      if (_isMovingSelection && _selectionDragStart != null) {
        final delta = worldPoint - _selectionDragStart!;
        final updated = state.project.objects.map((o) {
          if (state.selectedObjectIds.contains(o.id)) {
            return o.translate(delta);
          }
          return o;
        }).toList();
        state = state.copyWith(project: state.project.copyWith(objects: updated));
        _selectionDragStart = worldPoint;
      } else if (state.activeSelectionRect != null) {
        final origin = state.activeSelectionRect!.topLeft;
        state = state.copyWith(
          activeSelectionRect: Rect.fromPoints(origin, worldPoint),
        );
      }
      return;
    }

    if (state.selectedTool.isDrawingStroke && state.activeStroke != null) {
      final pts = List<CanvasPoint>.from(state.activeStroke!.points)
        ..add(CanvasPoint(x: worldPoint.dx, y: worldPoint.dy));
      state = state.copyWith(activeStroke: state.activeStroke!.copyWith(points: pts));
    } else if (state.selectedTool.isShape && state.activeShapePreview != null) {
      final origin = state.activeShapePreview!.rect.topLeft;
      state = state.copyWith(
        activeShapePreview: state.activeShapePreview!.copyWith(
          rect: Rect.fromPoints(origin, worldPoint),
        ),
      );
    } else if (state.selectedTool == CanvasTool.eraser) {
      _eraseAt(worldPoint);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (state.selectedTool.isDrawingStroke && state.activeStroke != null) {
      if (state.activeStroke!.points.isNotEmpty) {
        _historyManager.record(AddObjectCommand(state.activeStroke!), this);
      }
      state = state.copyWith(
        clearActiveStroke: true,
        canUndo: _historyManager.canUndo,
        canRedo: _historyManager.canRedo,
      );
    } else if (state.selectedTool.isShape && state.activeShapePreview != null) {
      final r = state.activeShapePreview!.rect;
      if (r.width.abs() > 4 || r.height.abs() > 4) {
        // Normalize rect
        final normalized = Rect.fromLTRB(
          math.min(r.left, r.right),
          math.min(r.top, r.bottom),
          math.max(r.left, r.right),
          math.max(r.top, r.bottom),
        );
        final finalShape = state.activeShapePreview!.copyWith(rect: normalized);
        _historyManager.record(AddObjectCommand(finalShape), this);
      }
      state = state.copyWith(
        clearActiveShape: true,
        canUndo: _historyManager.canUndo,
        canRedo: _historyManager.canRedo,
      );
    } else if (state.selectedTool == CanvasTool.select) {
      if (_isScalingSelection) {
        _isScalingSelection = false;
        for (final oldObj in _preTransformSelectedObjects) {
          final newObj = state.project.objects.firstWhere((o) => o.id == oldObj.id, orElse: () => oldObj);
          if (newObj != oldObj) {
            _historyManager.record(ModifyObjectCommand(oldObject: oldObj, newObject: newObj), this);
          }
        }
        _preTransformSelectedObjects = [];
        state = state.copyWith(
          canUndo: _historyManager.canUndo,
          canRedo: _historyManager.canRedo,
        );
      } else if (_isMovingSelection) {
        _isMovingSelection = false;
        _selectionDragStart = null;
        for (final oldObj in _preTransformSelectedObjects) {
          final newObj = state.project.objects.firstWhere((o) => o.id == oldObj.id, orElse: () => oldObj);
          if (newObj != oldObj) {
            _historyManager.record(ModifyObjectCommand(oldObject: oldObj, newObject: newObj), this);
          }
        }
        _preTransformSelectedObjects = [];
        state = state.copyWith(
          canUndo: _historyManager.canUndo,
          canRedo: _historyManager.canRedo,
        );
      } else if (state.activeSelectionRect != null) {
        final box = state.activeSelectionRect!;
        final matched = state.project.objects.where((o) => box.overlaps(o.boundingBox)).map((o) => o.id).toList();
        state = state.copyWith(
          selectedObjectIds: matched,
          clearActiveSelectionRect: true,
        );
      }
    }
  }

  void onDoubleTap(TapDownDetails details) {
    final screenFocal = details.localPosition;
    state = state.copyWith(camera: state.camera.zoomAt(screenFocal, 1.8));
  }

  CanvasObject? _hitTestObjects(Offset worldPoint) {
    // Reverse order (top objects first)
    final sorted = List<CanvasObject>.from(state.project.objects)
      ..sort((a, b) => b.orderIndex.compareTo(a.orderIndex));
    for (final obj in sorted) {
      if (obj.hitTest(worldPoint)) {
        return obj;
      }
    }
    return null;
  }

  void _eraseAt(Offset worldPoint) {
    final hit = _hitTestObjects(worldPoint);
    if (hit != null) {
      _historyManager.record(DeleteObjectsCommand([hit]), this);
      state = state.copyWith(
        canUndo: _historyManager.canUndo,
        canRedo: _historyManager.canRedo,
      );
    }
  }

  // --- Object Modification & Insertions ---
  void addTextObject(String text, {Offset? position}) {
    final pos = position ?? state.camera.visibleWorldRect.center;
    final textObj = TextCanvasObject(
      id: _uuid.v4(),
      layerId: state.activeLayerId,
      orderIndex: state.project.objects.length,
      text: text,
      position: pos,
      fontSize: 20,
      color: state.strokeColor,
    );
    _historyManager.record(AddObjectCommand(textObj), this);
    state = state.copyWith(
      selectedTool: CanvasTool.select,
      selectedObjectIds: [textObj.id],
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void updateTextObject(
    String id,
    String text, {
    double? fontSize,
    Color? color,
    Color? backgroundColor,
    bool? isBold,
    bool? isItalic,
    bool? isUnderline,
    TextAlign? alignment,
  }) {
    final index = state.project.objects.indexWhere((o) => o.id == id);
    if (index == -1) return;
    final old = state.project.objects[index];
    if (old is TextCanvasObject) {
      final updated = old.copyWith(
        text: text,
        fontSize: fontSize,
        color: color,
        backgroundColor: backgroundColor,
        isBold: isBold,
        isItalic: isItalic,
        isUnderline: isUnderline,
        alignment: alignment,
      );
      _historyManager.record(ModifyObjectCommand(oldObject: old, newObject: updated), this);
      state = state.copyWith(
        canUndo: _historyManager.canUndo,
        canRedo: _historyManager.canRedo,
      );
    }
  }

  Future<void> addImageObject(String imagePath, Size size, {Offset? position}) async {
    final pos = position ?? state.camera.visibleWorldRect.center - Offset(size.width / 2, size.height / 2);
    final imageObj = ImageCanvasObject(
      id: _uuid.v4(),
      layerId: state.activeLayerId,
      orderIndex: state.project.objects.length,
      imagePath: imagePath,
      position: pos,
      width: size.width,
      height: size.height,
    );

    // Cache ui.Image
    final uiImg = await _loadImageFromFile(imagePath);
    if (uiImg != null) {
      final map = Map<String, ui.Image>.from(state.loadedImages);
      map[imagePath] = uiImg;
      state = state.copyWith(loadedImages: map);
    }

    _historyManager.record(AddObjectCommand(imageObj), this);
    state = state.copyWith(
      selectedTool: CanvasTool.select,
      selectedObjectIds: [imageObj.id],
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void addStickerObject(String stickerKey, {Offset? position}) {
    final pos = position ?? state.camera.visibleWorldRect.center - const Offset(30, 30);
    final stickerObj = StickerCanvasObject(
      id: _uuid.v4(),
      layerId: state.activeLayerId,
      orderIndex: state.project.objects.length,
      stickerKey: stickerKey,
      position: pos,
      size: 60,
      color: state.strokeColor,
    );
    _historyManager.record(AddObjectCommand(stickerObj), this);
    state = state.copyWith(
      selectedTool: CanvasTool.select,
      selectedObjectIds: [stickerObj.id],
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void deleteSelectedObjects() {
    if (state.selectedObjectIds.isEmpty) return;
    final toDelete = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    if (toDelete.isNotEmpty) {
      _historyManager.record(DeleteObjectsCommand(toDelete), this);
      state = state.copyWith(
        selectedObjectIds: [],
        canUndo: _historyManager.canUndo,
        canRedo: _historyManager.canRedo,
      );
    }
  }

  void duplicateSelectedObjects() {
    if (state.selectedObjectIds.isEmpty) return;
    final selected = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    final newObjects = <CanvasObject>[];
    final newIds = <String>[];

    for (final obj in selected) {
      final json = obj.toJson();
      final newId = _uuid.v4();
      json['id'] = newId;
      final duplicated = CanvasObject.fromJson(json).translate(const Offset(20, 20));
      newObjects.add(duplicated);
      newIds.add(newId);
    }

    for (final obj in newObjects) {
      _historyManager.record(AddObjectCommand(obj), this);
    }

    state = state.copyWith(
      selectedObjectIds: newIds,
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void scaleSelectedObjects(double scaleFactor) {
    if (state.selectedObjectIds.isEmpty) return;
    final selected = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    if (selected.isEmpty) return;

    Rect bounds = selected.first.boundingBox;
    for (int i = 1; i < selected.length; i++) {
      bounds = bounds.expandToInclude(selected[i].boundingBox);
    }
    final origin = bounds.center;

    for (final oldObj in selected) {
      final scaled = oldObj.scale(scaleFactor, origin);
      _historyManager.record(ModifyObjectCommand(oldObject: oldObj, newObject: scaled), this);
      updateObject(scaled);
    }
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void rotateSelectedObjects(double angleDelta) {
    if (state.selectedObjectIds.isEmpty) return;
    final selected = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    if (selected.isEmpty) return;

    Rect bounds = selected.first.boundingBox;
    for (int i = 1; i < selected.length; i++) {
      bounds = bounds.expandToInclude(selected[i].boundingBox);
    }
    final origin = bounds.center;

    for (final oldObj in selected) {
      final rotated = oldObj.rotate(angleDelta, origin);
      _historyManager.record(ModifyObjectCommand(oldObject: oldObj, newObject: rotated), this);
      updateObject(rotated);
    }
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  // --- Z-Order Layering & Alignment Adjustments ---
  void bringToFront() {
    if (state.selectedObjectIds.isEmpty) return;
    final selectedIds = state.selectedObjectIds.toSet();
    final allObjs = List<CanvasObject>.from(state.project.objects);
    allObjs.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final nonSelected = allObjs.where((o) => !selectedIds.contains(o.id)).toList();
    final selected = allObjs.where((o) => selectedIds.contains(o.id)).toList();

    final reordered = [...nonSelected, ...selected];
    final updated = <CanvasObject>[];
    for (int i = 0; i < reordered.length; i++) {
      updated.add(reordered[i].withOrderIndex(i));
    }

    _historyManager.record(
      ReorderObjectsCommand(oldObjects: state.project.objects, newObjects: updated),
      this,
    );
    setObjects(updated);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void sendToBack() {
    if (state.selectedObjectIds.isEmpty) return;
    final selectedIds = state.selectedObjectIds.toSet();
    final allObjs = List<CanvasObject>.from(state.project.objects);
    allObjs.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final nonSelected = allObjs.where((o) => !selectedIds.contains(o.id)).toList();
    final selected = allObjs.where((o) => selectedIds.contains(o.id)).toList();

    final reordered = [...selected, ...nonSelected];
    final updated = <CanvasObject>[];
    for (int i = 0; i < reordered.length; i++) {
      updated.add(reordered[i].withOrderIndex(i));
    }

    _historyManager.record(
      ReorderObjectsCommand(oldObjects: state.project.objects, newObjects: updated),
      this,
    );
    setObjects(updated);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void bringForward() {
    if (state.selectedObjectIds.isEmpty) return;
    final selectedIds = state.selectedObjectIds.toSet();
    final allObjs = List<CanvasObject>.from(state.project.objects);
    allObjs.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (int i = allObjs.length - 2; i >= 0; i--) {
      if (selectedIds.contains(allObjs[i].id) && !selectedIds.contains(allObjs[i + 1].id)) {
        final temp = allObjs[i];
        allObjs[i] = allObjs[i + 1];
        allObjs[i + 1] = temp;
      }
    }

    final updated = <CanvasObject>[];
    for (int i = 0; i < allObjs.length; i++) {
      updated.add(allObjs[i].withOrderIndex(i));
    }

    _historyManager.record(
      ReorderObjectsCommand(oldObjects: state.project.objects, newObjects: updated),
      this,
    );
    setObjects(updated);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void sendBackward() {
    if (state.selectedObjectIds.isEmpty) return;
    final selectedIds = state.selectedObjectIds.toSet();
    final allObjs = List<CanvasObject>.from(state.project.objects);
    allObjs.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    for (int i = 1; i < allObjs.length; i++) {
      if (selectedIds.contains(allObjs[i].id) && !selectedIds.contains(allObjs[i - 1].id)) {
        final temp = allObjs[i];
        allObjs[i] = allObjs[i - 1];
        allObjs[i - 1] = temp;
      }
    }

    final updated = <CanvasObject>[];
    for (int i = 0; i < allObjs.length; i++) {
      updated.add(allObjs[i].withOrderIndex(i));
    }

    _historyManager.record(
      ReorderObjectsCommand(oldObjects: state.project.objects, newObjects: updated),
      this,
    );
    setObjects(updated);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void alignSelectedObjects(ObjectAlignment alignment) {
    if (state.selectedObjectIds.isEmpty) return;
    final selected = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    if (selected.isEmpty) return;

    Rect targetBounds;
    if (selected.length > 1) {
      targetBounds = selected.first.boundingBox;
      for (int i = 1; i < selected.length; i++) {
        targetBounds = targetBounds.expandToInclude(selected[i].boundingBox);
      }
    } else {
      final vpCenter = state.camera.screenToWorld(
        Offset(state.camera.viewportSize.width / 2, state.camera.viewportSize.height / 2),
      );
      targetBounds = Rect.fromCenter(
        center: vpCenter,
        width: selected.first.boundingBox.width,
        height: selected.first.boundingBox.height,
      );
    }

    final updated = <CanvasObject>[];
    for (final obj in state.project.objects) {
      if (!state.selectedObjectIds.contains(obj.id)) {
        updated.add(obj);
        continue;
      }

      final b = obj.boundingBox;
      double dx = 0;
      double dy = 0;

      switch (alignment) {
        case ObjectAlignment.left:
          dx = targetBounds.left - b.left;
          break;
        case ObjectAlignment.centerH:
          dx = targetBounds.center.dx - b.center.dx;
          break;
        case ObjectAlignment.right:
          dx = targetBounds.right - b.right;
          break;
        case ObjectAlignment.top:
          dy = targetBounds.top - b.top;
          break;
        case ObjectAlignment.centerV:
          dy = targetBounds.center.dy - b.center.dy;
          break;
        case ObjectAlignment.bottom:
          dy = targetBounds.bottom - b.bottom;
          break;
      }

      if (dx != 0 || dy != 0) {
        final translated = obj.translate(Offset(dx, dy));
        _historyManager.record(ModifyObjectCommand(oldObject: obj, newObject: translated), this);
        updated.add(translated);
      } else {
        updated.add(obj);
      }
    }

    setObjects(updated);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void clearSelection() {
    state = state.copyWith(selectedObjectIds: []);
  }

  // --- Layer Management ---
  void selectLayer(String layerId) {
    state = state.copyWith(activeLayerId: layerId);
  }

  void createNewLayer() {
    final newLayer = CanvasLayer(
      id: _uuid.v4(),
      projectId: state.project.id,
      name: 'Layer ${state.project.layers.length + 1}',
      orderIndex: state.project.layers.length,
      isVisible: true,
      isLocked: false,
      opacity: 1.0,
    );
    _historyManager.record(AddLayerCommand(newLayer), this);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void deleteLayerById(String layerId) {
    if (state.project.layers.length <= 1) return;
    final layer = state.project.layers.firstWhere((l) => l.id == layerId);
    final layerObjs = state.project.objects.where((o) => o.layerId == layerId).toList();
    _historyManager.record(DeleteLayerCommand(layer: layer, layerObjects: layerObjs), this);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void toggleLayerVisibility(String layerId) {
    final layer = state.project.layers.firstWhere((l) => l.id == layerId);
    updateLayer(layer.copyWith(isVisible: !layer.isVisible));
  }

  void toggleLayerLock(String layerId) {
    final layer = state.project.layers.firstWhere((l) => l.id == layerId);
    updateLayer(layer.copyWith(isLocked: !layer.isLocked));
  }

  void setLayerOpacity(String layerId, double opacity) {
    final layer = state.project.layers.firstWhere((l) => l.id == layerId);
    updateLayer(layer.copyWith(opacity: opacity));
  }

  void reorderLayers(int oldIndex, int newIndex) {
    final updated = List<CanvasLayer>.from(state.project.layers);
    if (newIndex > oldIndex) newIndex -= 1;
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    final reindexed = <CanvasLayer>[];
    for (int i = 0; i < updated.length; i++) {
      reindexed.add(updated[i].copyWith(orderIndex: i));
    }
    setLayers(reindexed);
  }

  // --- History (Undo/Redo) ---
  void undo() {
    _historyManager.undo(this);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  void redo() {
    _historyManager.redo(this);
    state = state.copyWith(
      canUndo: _historyManager.canUndo,
      canRedo: _historyManager.canRedo,
    );
  }

  // --- Camera Operations ---
  void zoomFit() {
    Rect bounds = state.project.objects.isNotEmpty
        ? state.project.objects.first.boundingBox
        : const Rect.fromLTWH(-500, -500, 1000, 1000);
    for (final obj in state.project.objects) {
      bounds = bounds.expandToInclude(obj.boundingBox);
    }
    state = state.copyWith(camera: state.camera.zoomToFit(bounds));
  }

  void zoomSelection() {
    if (state.selectedObjectIds.isEmpty) {
      zoomFit();
      return;
    }
    final selected = state.project.objects.where((o) => state.selectedObjectIds.contains(o.id)).toList();
    Rect bounds = selected.first.boundingBox;
    for (final s in selected) {
      bounds = bounds.expandToInclude(s.boundingBox);
    }
    state = state.copyWith(camera: state.camera.zoomToFit(bounds));
  }

  void resetCamera() {
    state = state.copyWith(camera: state.camera.reset());
  }

  void panTo(Offset worldPoint) {
    final centerScreen = Offset(state.camera.viewportSize.width / 2, state.camera.viewportSize.height / 2);
    final newOffset = centerScreen - worldPoint * state.camera.zoom;
    state = state.copyWith(camera: state.camera.copyWith(offset: newOffset));
  }

  // --- Panels & Toggles ---
  void toggleMinimap() {
    state = state.copyWith(showMinimap: !state.showMinimap);
  }

  void toggleLayersPanel() {
    state = state.copyWith(showLayersPanel: !state.showLayersPanel);
  }

  void toggleBrushSettings() {
    state = state.copyWith(showBrushSettings: !state.showBrushSettings);
  }

  // --- Persistence & Autosave ---
  void _triggerAutosave() {
    _autosaveTimer?.cancel();
    _autosaveTimer = Timer(const Duration(milliseconds: 1500), () {
      saveProjectManual();
    });
  }

  Future<void> saveProjectManual() async {
    state = state.copyWith(isSaving: true);
    try {
      final repo = ref.read(projectRepositoryProvider);
      final currentProject = state.project.copyWith(
        cameraX: state.camera.offset.dx,
        cameraY: state.camera.offset.dy,
        cameraZoom: state.camera.zoom,
        updatedAt: DateTime.now(),
      );

      await repo.saveProject(currentProject);

      // Save a mini thumbnail in the background
      try {
        final thumbBytes = await ExportService.renderCanvasToImage(
          objects: state.project.objects,
          layers: state.project.layers,
          camera: state.camera,
          backgroundColor: state.project.backgroundColor,
          format: ExportFormat.png,
          boundsType: ExportBoundsType.completeArtwork,
          selectedObjectIds: [],
          scaleFactor: 0.2,
          loadedImages: state.loadedImages,
        );
        await repo.saveThumbnail(state.project.id, thumbBytes);
      } catch (e) {
        debugPrint('Thumbnail generation failed: $e');
      }

      state = state.copyWith(
        isSaving: false,
        lastSavedTime: DateTime.now(),
      );
    } catch (e) {
      debugPrint('Error saving project: $e');
      state = state.copyWith(isSaving: false);
    }
  }
}

final canvasControllerProvider =
    NotifierProvider.family<CanvasController, CanvasState, ProjectModel>(
  (arg) => CanvasController(arg),
);
