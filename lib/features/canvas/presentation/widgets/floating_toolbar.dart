import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/models/canvas_tool.dart';

class FloatingToolbar extends StatelessWidget {
  final CanvasTool selectedTool;
  final Color currentColor;
  final double currentStrokeWidth;
  final ValueChanged<CanvasTool> onSelectTool;
  final VoidCallback onToggleBrushSettings;
  final VoidCallback onInsertText;
  final VoidCallback onInsertImage;
  final VoidCallback onInsertSticker;

  const FloatingToolbar({
    super.key,
    required this.selectedTool,
    required this.currentColor,
    required this.currentStrokeWidth,
    required this.onSelectTool,
    required this.onToggleBrushSettings,
    required this.onInsertText,
    required this.onInsertImage,
    required this.onInsertSticker,
  });

  void _showShapesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Shape',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ShapeOption(
                      icon: Icons.rectangle_outlined,
                      label: 'Rectangle',
                      isSelected: selectedTool == CanvasTool.rectangle,
                      onTap: () {
                        onSelectTool(CanvasTool.rectangle);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.circle_outlined,
                      label: 'Circle',
                      isSelected: selectedTool == CanvasTool.circle,
                      onTap: () {
                        onSelectTool(CanvasTool.circle);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.horizontal_rule_rounded,
                      label: 'Line',
                      isSelected: selectedTool == CanvasTool.line,
                      onTap: () {
                        onSelectTool(CanvasTool.line);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.arrow_forward_rounded,
                      label: 'Arrow',
                      isSelected: selectedTool == CanvasTool.arrow,
                      onTap: () {
                        onSelectTool(CanvasTool.arrow);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.change_history_rounded,
                      label: 'Triangle',
                      isSelected: selectedTool == CanvasTool.triangle,
                      onTap: () {
                        onSelectTool(CanvasTool.triangle);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.star_border_rounded,
                      label: 'Star',
                      isSelected: selectedTool == CanvasTool.star,
                      onTap: () {
                        onSelectTool(CanvasTool.star);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.pentagon_outlined,
                      label: 'Polygon',
                      isSelected: selectedTool == CanvasTool.polygon,
                      onTap: () {
                        onSelectTool(CanvasTool.polygon);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBrushesMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Drawing Tools',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _ShapeOption(
                      icon: Icons.edit_rounded,
                      label: 'Pen',
                      isSelected: selectedTool == CanvasTool.pen,
                      onTap: () {
                        onSelectTool(CanvasTool.pen);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.draw_outlined,
                      label: 'Pencil',
                      isSelected: selectedTool == CanvasTool.pencil,
                      onTap: () {
                        onSelectTool(CanvasTool.pencil);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.brush_rounded,
                      label: 'Brush',
                      isSelected: selectedTool == CanvasTool.brush,
                      onTap: () {
                        onSelectTool(CanvasTool.brush);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.mode_edit_outline_rounded,
                      label: 'Marker',
                      isSelected: selectedTool == CanvasTool.marker,
                      onTap: () {
                        onSelectTool(CanvasTool.marker);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.highlight_rounded,
                      label: 'Highlighter',
                      isSelected: selectedTool == CanvasTool.highlighter,
                      onTap: () {
                        onSelectTool(CanvasTool.highlighter);
                        Navigator.pop(ctx);
                      },
                    ),
                    _ShapeOption(
                      icon: Icons.flare_rounded,
                      label: 'Laser',
                      isSelected: selectedTool == CanvasTool.laser,
                      onTap: () {
                        onSelectTool(CanvasTool.laser);
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      borderRadius: BorderRadius.circular(18),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          // Select / Transform Tool
          _ToolIconButton(
            icon: Icons.near_me_rounded,
            tooltip: 'Select Tool',
            isSelected: selectedTool == CanvasTool.select,
            onTap: () => onSelectTool(CanvasTool.select),
          ),

          // Pan / Hand Tool
          _ToolIconButton(
            icon: Icons.pan_tool_outlined,
            tooltip: 'Pan Tool',
            isSelected: selectedTool == CanvasTool.pan,
            onTap: () => onSelectTool(CanvasTool.pan),
          ),

          const _ToolDivider(),

          // Drawing Tool (Pen/Pencil/Brush/Marker/Highlighter)
          _ToolIconButton(
            icon: _getBrushIcon(selectedTool),
            tooltip: 'Draw Tool',
            isSelected: selectedTool.isDrawingStroke,
            onTap: () {
              if (selectedTool.isDrawingStroke) {
                _showBrushesMenu(context);
              } else {
                onSelectTool(CanvasTool.pen);
              }
            },
          ),

          // Eraser
          _ToolIconButton(
            icon: Icons.auto_fix_high_rounded,
            tooltip: 'Eraser',
            isSelected: selectedTool == CanvasTool.eraser,
            onTap: () => onSelectTool(CanvasTool.eraser),
          ),

          // Shapes
          _ToolIconButton(
            icon: _getShapeIcon(selectedTool),
            tooltip: 'Shapes',
            isSelected: selectedTool.isShape,
            onTap: () {
              if (selectedTool.isShape) {
                _showShapesMenu(context);
              } else {
                onSelectTool(CanvasTool.rectangle);
              }
            },
          ),

          const _ToolDivider(),

          // Text Tool
          _ToolIconButton(
            icon: Icons.title_rounded,
            tooltip: 'Add Text',
            isSelected: selectedTool == CanvasTool.text,
            onTap: onInsertText,
          ),

          // Image Tool
          _ToolIconButton(
            icon: Icons.image_outlined,
            tooltip: 'Insert Image',
            isSelected: false,
            onTap: onInsertImage,
          ),

          // Sticker Tool
          _ToolIconButton(
            icon: Icons.star_outline_rounded,
            tooltip: 'Add Sticker',
            isSelected: false,
            onTap: onInsertSticker,
          ),

          const _ToolDivider(),

          // Color & Size Preview / Settings Trigger
          GestureDetector(
            onTap: onToggleBrushSettings,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkBackground : AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${currentStrokeWidth.round()}px',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
  }

  IconData _getBrushIcon(CanvasTool tool) {
    switch (tool) {
      case CanvasTool.pencil:
        return Icons.draw_outlined;
      case CanvasTool.brush:
        return Icons.brush_rounded;
      case CanvasTool.marker:
        return Icons.mode_edit_outline_rounded;
      case CanvasTool.highlighter:
        return Icons.highlight_rounded;
      case CanvasTool.laser:
        return Icons.flare_rounded;
      default:
        return Icons.edit_rounded;
    }
  }

  IconData _getShapeIcon(CanvasTool tool) {
    switch (tool) {
      case CanvasTool.circle:
        return Icons.circle_outlined;
      case CanvasTool.line:
        return Icons.horizontal_rule_rounded;
      case CanvasTool.arrow:
        return Icons.arrow_forward_rounded;
      case CanvasTool.triangle:
        return Icons.change_history_rounded;
      case CanvasTool.star:
        return Icons.star_border_rounded;
      case CanvasTool.polygon:
        return Icons.pentagon_outlined;
      default:
        return Icons.rectangle_outlined;
    }
  }
}

class _ToolIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToolIconButton({
    required this.icon,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 38,
          height: 38,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBrand : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _ToolDivider extends StatelessWidget {
  const _ToolDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 22,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Theme.of(context).dividerColor,
    );
  }
}

class _ShapeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShapeOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryBrand.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBrand : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? AppColors.primaryBrand : null,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
