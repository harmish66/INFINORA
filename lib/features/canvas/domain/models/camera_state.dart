import 'package:flutter/material.dart';

class CameraState {
  final Offset offset;
  final double zoom;
  final Size viewportSize;

  static const double minZoom = 0.05;
  static const double maxZoom = 50.0;

  const CameraState({
    this.offset = Offset.zero,
    this.zoom = 1.0,
    this.viewportSize = Size.zero,
  });

  CameraState copyWith({
    Offset? offset,
    double? zoom,
    Size? viewportSize,
  }) {
    return CameraState(
      offset: offset ?? this.offset,
      zoom: zoom ?? this.zoom,
      viewportSize: viewportSize ?? this.viewportSize,
    );
  }

  Offset screenToWorld(Offset screenPoint) {
    return (screenPoint - offset) / zoom;
  }

  Offset worldToScreen(Offset worldPoint) {
    return worldPoint * zoom + offset;
  }

  Rect worldRectToScreen(Rect worldRect) {
    final topLeft = worldToScreen(worldRect.topLeft);
    final bottomRight = worldToScreen(worldRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  Rect screenRectToWorld(Rect screenRect) {
    final topLeft = screenToWorld(screenRect.topLeft);
    final bottomRight = screenToWorld(screenRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  Rect get visibleWorldRect {
    if (viewportSize.isEmpty) {
      return Rect.fromLTWH(-10000, -10000, 20000, 20000);
    }
    return screenRectToWorld(Offset.zero & viewportSize);
  }

  CameraState zoomAt(Offset screenFocalPoint, double zoomMultiplier) {
    final double newZoom = (zoom * zoomMultiplier).clamp(minZoom, maxZoom);
    final worldFocalPoint = screenToWorld(screenFocalPoint);
    final newOffset = screenFocalPoint - worldFocalPoint * newZoom;
    return copyWith(
      offset: newOffset,
      zoom: newZoom,
    );
  }

  CameraState pan(Offset screenDelta) {
    return copyWith(offset: offset + screenDelta);
  }

  CameraState zoomToFit(Rect targetWorldBounds, {double padding = 60.0}) {
    if (viewportSize.isEmpty || targetWorldBounds.isEmpty) {
      return this;
    }

    final double availableWidth = viewportSize.width - padding * 2;
    final double availableHeight = viewportSize.height - padding * 2;

    if (availableWidth <= 0 || availableHeight <= 0) return this;

    final double scaleX = availableWidth / targetWorldBounds.width;
    final double scaleY = availableHeight / targetWorldBounds.height;
    final double targetZoom = (scaleX < scaleY ? scaleX : scaleY).clamp(minZoom, 4.0);

    final Offset centerScreen = Offset(viewportSize.width / 2, viewportSize.height / 2);
    final Offset centerWorld = targetWorldBounds.center;
    final Offset targetOffset = centerScreen - centerWorld * targetZoom;

    return copyWith(
      offset: targetOffset,
      zoom: targetZoom,
    );
  }

  CameraState reset() {
    final center = viewportSize.isEmpty
        ? Offset.zero
        : Offset(viewportSize.width / 2, viewportSize.height / 2);
    return CameraState(
      offset: center,
      zoom: 1.0,
      viewportSize: viewportSize,
    );
  }
}
