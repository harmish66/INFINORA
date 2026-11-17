import 'package:flutter/material.dart';
import 'canvas_object.dart';
import 'canvas_layer.dart';

abstract class CanvasCommand {
  void execute(CanvasCommandContext context);
  void undo(CanvasCommandContext context);
}

abstract class CanvasCommandContext {
  List<CanvasObject> get objects;
  List<CanvasLayer> get layers;

  void addObject(CanvasObject object);
  void removeObject(String id);
  void updateObject(CanvasObject object);
  void setObjects(List<CanvasObject> newObjects);

  void addLayer(CanvasLayer layer);
  void removeLayer(String id);
  void updateLayer(CanvasLayer layer);
  void setLayers(List<CanvasLayer> newLayers);
}

class AddObjectCommand extends CanvasCommand {
  final CanvasObject object;

  AddObjectCommand(this.object);

  @override
  void execute(CanvasCommandContext context) {
    context.addObject(object);
  }

  @override
  void undo(CanvasCommandContext context) {
    context.removeObject(object.id);
  }
}

class DeleteObjectsCommand extends CanvasCommand {
  final List<CanvasObject> objects;

  DeleteObjectsCommand(this.objects);

  @override
  void execute(CanvasCommandContext context) {
    for (final obj in objects) {
      context.removeObject(obj.id);
    }
  }

  @override
  void undo(CanvasCommandContext context) {
    for (final obj in objects) {
      context.addObject(obj);
    }
  }
}

class ModifyObjectCommand extends CanvasCommand {
  final CanvasObject oldObject;
  final CanvasObject newObject;

  ModifyObjectCommand({
    required this.oldObject,
    required this.newObject,
  });

  @override
  void execute(CanvasCommandContext context) {
    context.updateObject(newObject);
  }

  @override
  void undo(CanvasCommandContext context) {
    context.updateObject(oldObject);
  }
}

class MoveObjectsCommand extends CanvasCommand {
  final List<String> objectIds;
  final double dx;
  final double dy;

  MoveObjectsCommand({
    required this.objectIds,
    required this.dx,
    required this.dy,
  });

  @override
  void execute(CanvasCommandContext context) {
    for (final id in objectIds) {
      final index = context.objects.indexWhere((o) => o.id == id);
      if (index != -1) {
        final obj = context.objects[index];
        context.updateObject(obj.translate(Offset(dx, dy)));
      }
    }
  }

  @override
  void undo(CanvasCommandContext context) {
    for (final id in objectIds) {
      final index = context.objects.indexWhere((o) => o.id == id);
      if (index != -1) {
        final obj = context.objects[index];
        context.updateObject(obj.translate(Offset(-dx, -dy)));
      }
    }
  }
}

class AddLayerCommand extends CanvasCommand {
  final CanvasLayer layer;

  AddLayerCommand(this.layer);

  @override
  void execute(CanvasCommandContext context) {
    context.addLayer(layer);
  }

  @override
  void undo(CanvasCommandContext context) {
    context.removeLayer(layer.id);
  }
}

class DeleteLayerCommand extends CanvasCommand {
  final CanvasLayer layer;
  final List<CanvasObject> layerObjects;

  DeleteLayerCommand({
    required this.layer,
    required this.layerObjects,
  });

  @override
  void execute(CanvasCommandContext context) {
    for (final obj in layerObjects) {
      context.removeObject(obj.id);
    }
    context.removeLayer(layer.id);
  }

  @override
  void undo(CanvasCommandContext context) {
    context.addLayer(layer);
    for (final obj in layerObjects) {
      context.addObject(obj);
    }
  }
}

class ReorderObjectsCommand extends CanvasCommand {
  final List<CanvasObject> oldObjects;
  final List<CanvasObject> newObjects;

  ReorderObjectsCommand({
    required this.oldObjects,
    required this.newObjects,
  });

  @override
  void execute(CanvasCommandContext context) {
    context.setObjects(newObjects);
  }

  @override
  void undo(CanvasCommandContext context) {
    context.setObjects(oldObjects);
  }
}

class HistoryManager {
  final int maxHistoryLength;
  final List<CanvasCommand> _undoStack = [];
  final List<CanvasCommand> _redoStack = [];

  HistoryManager({this.maxHistoryLength = 100});

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  void record(CanvasCommand command, CanvasCommandContext context) {
    command.execute(context);
    _undoStack.add(command);
    if (_undoStack.length > maxHistoryLength) {
      _undoStack.removeAt(0);
    }
    _redoStack.clear();
  }

  void undo(CanvasCommandContext context) {
    if (!canUndo) return;
    final command = _undoStack.removeLast();
    command.undo(context);
    _redoStack.add(command);
  }

  void redo(CanvasCommandContext context) {
    if (!canRedo) return;
    final command = _redoStack.removeLast();
    command.execute(context);
    _undoStack.add(command);
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }
}
