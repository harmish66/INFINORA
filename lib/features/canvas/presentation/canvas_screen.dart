import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../export/presentation/export_bottom_sheet.dart';
import '../../projects/domain/models/project_model.dart';
import '../domain/models/canvas_tool.dart';
import 'controllers/canvas_controller.dart';
import 'painters/infinite_canvas_painter.dart';
import 'painters/minimap_painter.dart';
import 'widgets/brush_settings_panel.dart';
import 'widgets/floating_toolbar.dart';
import 'widgets/layers_panel_widget.dart';
import 'widgets/selection_toolbar.dart';
import 'widgets/top_editor_app_bar.dart';

class CanvasScreen extends ConsumerStatefulWidget {
  final ProjectModel project;

  const CanvasScreen({
    super.key,
    required this.project,
  });

  @override
  ConsumerState<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends ConsumerState<CanvasScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  void _showTextDialog(BuildContext context, CanvasController controller) {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Add Text'),
        content: TextField(
          controller: textController,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Type your note or title here...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                controller.addTextObject(text);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add to Canvas'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleInsertImage(BuildContext context, CanvasController controller) async {
    try {
      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 2048,
        maxHeight: 2048,
      );
      if (picked != null) {
        final bytes = await File(picked.path).readAsBytes();
        final decoded = await decodeImageFromList(bytes);
        final size = Size(decoded.width.toDouble(), decoded.height.toDouble());

        // Normalize initial size to max 400px wide
        final scale = (size.width > 400) ? 400 / size.width : 1.0;
        final finalSize = Size(size.width * scale, size.height * scale);

        await controller.addImageObject(picked.path, finalSize);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showStickerSheet(BuildContext context, CanvasController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        const stickers = [
          {'key': 'star', 'icon': Icons.star_rounded, 'name': 'Star'},
          {'key': 'heart', 'icon': Icons.favorite_rounded, 'name': 'Heart'},
          {'key': 'badge', 'icon': Icons.verified_rounded, 'name': 'Verified'},
          {'key': 'check', 'icon': Icons.check_circle_rounded, 'name': 'Check'},
          {'key': 'flash', 'icon': Icons.bolt_rounded, 'name': 'Lightning'},
          {'key': 'fire', 'icon': Icons.local_fire_department_rounded, 'name': 'Flame'},
          {'key': 'bookmark', 'icon': Icons.bookmark_rounded, 'name': 'Bookmark'},
          {'key': 'smile', 'icon': Icons.emoji_emotions_rounded, 'name': 'Smile'},
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Insert Vector Sticker',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: stickers.map((s) {
                    final key = s['key'] as String;
                    final icon = s['icon'] as IconData;
                    final name = s['name'] as String;
                    return InkWell(
                      onTap: () {
                        controller.addStickerObject(key);
                        Navigator.pop(ctx);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Icon(icon, size: 36, color: AppColors.primaryBrand),
                            const SizedBox(height: 6),
                            Text(name, style: const TextStyle(fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showExportSheet(BuildContext context, CanvasState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => ExportBottomSheet(
        projectName: state.project.name,
        objects: state.project.objects,
        layers: state.project.layers,
        camera: state.camera,
        backgroundColor: state.project.backgroundColor,
        selectedObjectIds: state.selectedObjectIds,
        canvasWidth: state.project.canvasWidth,
        canvasHeight: state.project.canvasHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(canvasControllerProvider(widget.project));
    final controller = ref.read(canvasControllerProvider(widget.project).notifier);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await controller.saveProjectManual();
        if (context.mounted) {
          ref.read(projectsListProvider.notifier).refresh();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: LayoutBuilder(
        builder: (context, constraints) {
          final viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
          if (state.camera.viewportSize != viewportSize) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                controller.updateViewportSize(viewportSize);
              }
            });
          }

          return Stack(
            children: [
              // 1. Infinite Canvas Drawing Viewport
              Positioned.fill(
                child: GestureDetector(
                  onScaleStart: controller.onScaleStart,
                  onScaleUpdate: controller.onScaleUpdate,
                  onScaleEnd: controller.onScaleEnd,
                  onDoubleTapDown: controller.onDoubleTap,
                  child: CustomPaint(
                    painter: InfiniteCanvasPainter(
                      camera: state.camera,
                      backgroundColor: state.project.backgroundColor,
                      canvasWidth: state.project.canvasWidth,
                      canvasHeight: state.project.canvasHeight,
                      showGrid: state.project.showGrid,
                      gridStyle: state.project.gridStyle,
                      layers: state.project.layers,
                      objects: state.project.objects,
                      selectedObjectIds: state.selectedObjectIds,
                      activeStroke: state.activeStroke,
                      activeShapePreview: state.activeShapePreview,
                      activeSelectionRect: state.activeSelectionRect,
                      loadedImages: state.loadedImages,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                ),
              ),

              // 2. Selection action bar (Delete, Duplicate, Clear) when items selected
              if (state.selectedObjectIds.isNotEmpty)
                Positioned(
                  top: 76,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primaryBrand),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, size: 18),
                          tooltip: 'Duplicate',
                          onPressed: controller.duplicateSelectedObjects,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                          tooltip: 'Delete',
                          onPressed: controller.deleteSelectedObjects,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          tooltip: 'Deselect',
                          onPressed: controller.clearSelection,
                        ),
                      ],
                    ),
                  ),
                ),

              // 3. Top Editor Bar
              Positioned(
                top: MediaQuery.of(context).padding.top + 8,
                left: 16,
                right: 16,
                child: TopEditorAppBar(
                  projectName: state.project.name,
                  isSaving: state.isSaving,
                  canUndo: state.canUndo,
                  canRedo: state.canRedo,
                  showMinimap: state.showMinimap,
                  showLayersPanel: state.showLayersPanel,
                  onBack: () async {
                    await controller.saveProjectManual();
                    if (context.mounted) {
                      ref.read(projectsListProvider.notifier).refresh();
                      Navigator.of(context).pop();
                    }
                  },
                  onUndo: controller.undo,
                  onRedo: controller.redo,
                  onZoomFit: controller.zoomFit,
                  onResetCamera: controller.resetCamera,
                  onToggleMinimap: controller.toggleMinimap,
                  onToggleLayers: controller.toggleLayersPanel,
                  onExport: () => _showExportSheet(context, state),
                  onRenameProject: (newName) {
                    ref.read(projectsListProvider.notifier).refresh();
                  },
                  onDuplicateProject: () async {
                    final dup = await ref.read(projectsListProvider.notifier).duplicateProject(
                          state.project.id,
                          '${state.project.name} (Copy)',
                        );
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => CanvasScreen(project: dup)),
                      );
                    }
                  },
                ),
              ),

              // 4. Floating Minimap (Right Side)
              if (state.showMinimap)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 72,
                  right: 16,
                  child: Container(
                    width: 140,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTapDown: (details) {
                        // Pan canvas to tapped point in minimap
                        final rect = Rect.fromLTWH(0, 0, 140, 100);
                        final relX = details.localPosition.dx / rect.width;
                        final relY = details.localPosition.dy / rect.height;
                        final targetX = (relX - 0.5) * 2000;
                        final targetY = (relY - 0.5) * 2000;
                        controller.panTo(Offset(targetX, targetY));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CustomPaint(
                          painter: MinimapPainter(
                            objects: state.project.objects,
                            camera: state.camera,
                            backgroundColor: state.project.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // 5. Floating Layers Panel (Right Side)
              if (state.showLayersPanel)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 72,
                  right: 16,
                  child: LayersPanelWidget(
                    layers: state.project.layers,
                    activeLayerId: state.activeLayerId,
                    onSelectLayer: controller.selectLayer,
                    onAddLayer: controller.createNewLayer,
                    onDeleteLayer: controller.deleteLayerById,
                    onToggleVisibility: controller.toggleLayerVisibility,
                    onToggleLock: controller.toggleLayerLock,
                    onOpacityChanged: controller.setLayerOpacity,
                    onReorderLayers: controller.reorderLayers,
                    onRenameLayer: (id, name) {
                      final layer = state.project.layers.firstWhere((l) => l.id == id);
                      controller.updateLayer(layer.copyWith(name: name));
                    },
                    onClose: controller.toggleLayersPanel,
                  ),
                ),

              // 6. Floating Brush & Tool Settings Panel (Left/Bottom Side)
              if (state.showBrushSettings)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 80,
                  left: 16,
                  child: BrushSettingsPanel(
                    selectedTool: state.selectedTool,
                    strokeWidth: state.strokeWidth,
                    opacity: state.opacity,
                    strokeColor: state.strokeColor,
                    fillColor: state.fillColor,
                    isFilled: state.isFilled,
                    onStrokeWidthChanged: controller.setStrokeWidth,
                    onOpacityChanged: controller.setOpacity,
                    onStrokeColorChanged: controller.setColor,
                    onFillColorChanged: controller.setFillColor,
                    onIsFilledChanged: controller.setIsFilled,
                    onClose: controller.toggleBrushSettings,
                  ),
                ),

              // 7. Contextual Selection Toolbar (When objects are selected in Select mode)
              if (state.selectedTool == CanvasTool.select && state.selectedObjectIds.isNotEmpty)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 76,
                  left: 8,
                  right: 8,
                  child: Center(
                    child: SelectionToolbar(
                      selectedCount: state.selectedObjectIds.length,
                      onScaleUp: () => controller.scaleSelectedObjects(1.25),
                      onScaleDown: () => controller.scaleSelectedObjects(0.8),
                      onRotate: () => controller.rotateSelectedObjects(1.5707963267948966),
                      onDuplicate: controller.duplicateSelectedObjects,
                      onDelete: controller.deleteSelectedObjects,
                      onDeselect: controller.clearSelection,
                      onBringToFront: controller.bringToFront,
                      onSendToBack: controller.sendToBack,
                      onBringForward: controller.bringForward,
                      onSendBackward: controller.sendBackward,
                      onAlign: controller.alignSelectedObjects,
                    ),
                  ),
                ),

              // 8. Floating Bottom Toolbar
              Positioned(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
                child: Center(
                  child: FloatingToolbar(
                    selectedTool: state.selectedTool,
                    currentColor: state.strokeColor,
                    currentStrokeWidth: state.strokeWidth,
                    onSelectTool: controller.setTool,
                    onToggleBrushSettings: controller.toggleBrushSettings,
                    onInsertText: () => _showTextDialog(context, controller),
                    onInsertImage: () => _handleInsertImage(context, controller),
                    onInsertSticker: () => _showStickerSheet(context, controller),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}
