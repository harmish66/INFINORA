import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/models/canvas_layer.dart';

class LayersPanelWidget extends StatelessWidget {
  final List<CanvasLayer> layers;
  final String activeLayerId;
  final ValueChanged<String> onSelectLayer;
  final VoidCallback onAddLayer;
  final ValueChanged<String> onDeleteLayer;
  final ValueChanged<String> onToggleVisibility;
  final ValueChanged<String> onToggleLock;
  final void Function(String layerId, double opacity) onOpacityChanged;
  final void Function(int oldIndex, int newIndex) onReorderLayers;
  final void Function(String layerId, String newName) onRenameLayer;
  final VoidCallback onClose;

  const LayersPanelWidget({
    super.key,
    required this.layers,
    required this.activeLayerId,
    required this.onSelectLayer,
    required this.onAddLayer,
    required this.onDeleteLayer,
    required this.onToggleVisibility,
    required this.onToggleLock,
    required this.onOpacityChanged,
    required this.onReorderLayers,
    required this.onRenameLayer,
    required this.onClose,
  });

  void _showRenameDialog(BuildContext context, CanvasLayer layer) {
    final controller = TextEditingController(text: layer.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Rename Layer'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Layer name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                onRenameLayer(layer.id, newName);
              }
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLayer = layers.firstWhere(
      (l) => l.id == activeLayerId,
      orElse: () => layers.first,
    );

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320, maxHeight: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Layers',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 22),
                      tooltip: 'Add Layer',
                      onPressed: onAddLayer,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: onClose,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Layers List
            Flexible(
              child: ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: layers.length,
                onReorder: onReorderLayers,
                itemBuilder: (context, index) {
                  final layer = layers[index];
                  final isSelected = layer.id == activeLayerId;

                  return Container(
                    key: ValueKey(layer.id),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBrand.withValues(alpha: isDark ? 0.25 : 0.12)
                          : (isDark ? AppColors.darkBackground : AppColors.secondaryBackground),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryBrand
                            : (isDark ? AppColors.darkBorder : AppColors.border),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      onTap: () => onSelectLayer(layer.id),
                      leading: IconButton(
                        icon: Icon(
                          layer.isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                          size: 18,
                          color: layer.isVisible ? AppColors.primaryBrand : Colors.grey,
                        ),
                        onPressed: () => onToggleVisibility(layer.id),
                        visualDensity: VisualDensity.compact,
                      ),
                      title: GestureDetector(
                        onDoubleTap: () => _showRenameDialog(context, layer),
                        child: Text(
                          layer.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              layer.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                              size: 18,
                              color: layer.isLocked ? AppColors.warning : Colors.grey,
                            ),
                            onPressed: () => onToggleLock(layer.id),
                            visualDensity: VisualDensity.compact,
                          ),
                          if (layers.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.grey),
                              onPressed: () => onDeleteLayer(layer.id),
                              visualDensity: VisualDensity.compact,
                            ),
                          const Icon(Icons.drag_handle_rounded, size: 18, color: Colors.grey),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 20),

            // Active Layer Opacity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Layer Opacity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${(activeLayer.opacity * 100).round()}%', style: const TextStyle(fontSize: 12)),
              ],
            ),
            Slider(
              value: activeLayer.opacity,
              min: 0.1,
              max: 1.0,
              activeColor: AppColors.primaryBrand,
              onChanged: (val) => onOpacityChanged(activeLayer.id, val),
            ),
          ],
        ),
      ),
    );
  }
}
