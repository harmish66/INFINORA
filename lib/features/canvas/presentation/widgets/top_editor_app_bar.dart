import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TopEditorAppBar extends StatelessWidget {
  final String projectName;
  final bool isSaving;
  final bool canUndo;
  final bool canRedo;
  final bool showMinimap;
  final bool showLayersPanel;
  final VoidCallback onBack;
  final VoidCallback onUndo;
  final VoidCallback onRedo;
  final VoidCallback onZoomFit;
  final VoidCallback onResetCamera;
  final VoidCallback onToggleMinimap;
  final VoidCallback onToggleLayers;
  final VoidCallback onExport;
  final Function(String) onRenameProject;
  final VoidCallback onDuplicateProject;

  const TopEditorAppBar({
    super.key,
    required this.projectName,
    required this.isSaving,
    required this.canUndo,
    required this.canRedo,
    required this.showMinimap,
    required this.showLayersPanel,
    required this.onBack,
    required this.onUndo,
    required this.onRedo,
    required this.onZoomFit,
    required this.onResetCamera,
    required this.onToggleMinimap,
    required this.onToggleLayers,
    required this.onExport,
    required this.onRenameProject,
    required this.onDuplicateProject,
  });

  void _showRenameDialog(BuildContext context) {
    final textController = TextEditingController(text: projectName);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Rename Project'),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Project Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = textController.text.trim();
              if (newName.isNotEmpty) {
                onRenameProject(newName);
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        // On very narrow screens (<360px), keep only primary tools visible on bar
        final isNarrow = availableWidth < 360;

        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.border,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Back Button
              _CompactButton(
                icon: Icons.arrow_back,
                tooltip: 'Back',
                onPressed: onBack,
              ),

              const SizedBox(width: 2),

              // Title with Saving Indicator
              Expanded(
                child: GestureDetector(
                  onTap: () => _showRenameDialog(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          projectName,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSaving) ...[
                        const SizedBox(width: 4),
                        const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 2),

              // Undo Button
              _CompactButton(
                icon: Icons.undo,
                tooltip: 'Undo',
                onPressed: canUndo ? onUndo : null,
              ),

              // Redo Button
              _CompactButton(
                icon: Icons.redo,
                tooltip: 'Redo',
                onPressed: canRedo ? onRedo : null,
              ),

              // Zoom Fit Button
              _CompactButton(
                icon: Icons.center_focus_strong,
                tooltip: 'Zoom Fit',
                onPressed: onZoomFit,
              ),

              // Layers Toggle (direct icon on normal screens)
              if (!isNarrow)
                _CompactButton(
                  icon: showLayersPanel ? Icons.layers : Icons.layers_outlined,
                  tooltip: 'Layers',
                  isActive: showLayersPanel,
                  onPressed: onToggleLayers,
                ),

              // Export Button
              _CompactButton(
                icon: Icons.file_upload_outlined,
                tooltip: 'Export',
                onPressed: onExport,
              ),

              // Overflow Menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 19,
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
                tooltip: 'More actions',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  switch (value) {
                    case 'rename':
                      _showRenameDialog(context);
                      break;
                    case 'layers':
                      onToggleLayers();
                      break;
                    case 'minimap':
                      onToggleMinimap();
                      break;
                    case 'reset_camera':
                      onResetCamera();
                      break;
                    case 'duplicate':
                      onDuplicateProject();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (isNarrow)
                    PopupMenuItem(
                      value: 'layers',
                      child: Row(
                        children: [
                          Icon(showLayersPanel ? Icons.layers : Icons.layers_outlined, size: 18),
                          const SizedBox(width: 10),
                          Text(showLayersPanel ? 'Hide Layers' : 'Show Layers'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    value: 'rename',
                    child: Row(
                      children: [
                        const Icon(Icons.edit_outlined, size: 18),
                        const SizedBox(width: 10),
                        const Text('Rename Project'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'minimap',
                    child: Row(
                      children: [
                        Icon(showMinimap ? Icons.map : Icons.map_outlined, size: 18),
                        const SizedBox(width: 10),
                        Text(showMinimap ? 'Hide Minimap' : 'Show Minimap'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'reset_camera',
                    child: Row(
                      children: [
                        const Icon(Icons.restart_alt, size: 18),
                        const SizedBox(width: 10),
                        const Text('Reset View (100%)'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        const Icon(Icons.copy_outlined, size: 18),
                        const SizedBox(width: 10),
                        const Text('Duplicate Project'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CompactButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  const _CompactButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onPressed != null;

    final Color iconColor;
    if (!enabled) {
      iconColor = isDark ? Colors.white24 : Colors.black26;
    } else if (isActive) {
      iconColor = AppColors.primaryBrand;
    } else {
      iconColor = isDark ? AppColors.darkPrimaryText : AppColors.primaryText;
    }

    return IconButton(
      icon: Icon(icon, size: 18, color: iconColor),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size(28, 28),
        maximumSize: const Size(32, 32),
        padding: const EdgeInsets.all(4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
