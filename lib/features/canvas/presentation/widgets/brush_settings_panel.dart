import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../domain/models/canvas_tool.dart';
import 'color_picker_widget.dart';

class BrushSettingsPanel extends StatelessWidget {
  final CanvasTool selectedTool;
  final double strokeWidth;
  final double opacity;
  final Color strokeColor;
  final Color fillColor;
  final bool isFilled;
  final ValueChanged<double> onStrokeWidthChanged;
  final ValueChanged<double> onOpacityChanged;
  final ValueChanged<Color> onStrokeColorChanged;
  final ValueChanged<Color> onFillColorChanged;
  final ValueChanged<bool> onIsFilledChanged;
  final VoidCallback onClose;

  const BrushSettingsPanel({
    super.key,
    required this.selectedTool,
    required this.strokeWidth,
    required this.opacity,
    required this.strokeColor,
    required this.fillColor,
    required this.isFilled,
    required this.onStrokeWidthChanged,
    required this.onOpacityChanged,
    required this.onStrokeColorChanged,
    required this.onFillColorChanged,
    required this.onIsFilledChanged,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _toolTitle(selectedTool),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: onClose,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Live stroke preview
            Center(
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 140,
                    height: strokeWidth.clamp(2.0, 40.0),
                    decoration: BoxDecoration(
                      color: strokeColor.withValues(alpha: strokeColor.a * opacity),
                      borderRadius: BorderRadius.circular(strokeWidth / 2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Stroke size slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Size', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${strokeWidth.round()} px', style: const TextStyle(fontSize: 12)),
              ],
            ),
            Slider(
              value: strokeWidth,
              min: 1.0,
              max: 60.0,
              activeColor: AppColors.primaryBrand,
              onChanged: onStrokeWidthChanged,
            ),

            // Opacity slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Opacity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                Text('${(opacity * 100).round()}%', style: const TextStyle(fontSize: 12)),
              ],
            ),
            Slider(
              value: opacity,
              min: 0.1,
              max: 1.0,
              activeColor: AppColors.primaryBrand,
              onChanged: onOpacityChanged,
            ),

            // If shape, show Fill options
            if (selectedTool.isShape) ...[
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Fill Shape', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  Switch(
                    value: isFilled,
                    activeTrackColor: AppColors.primaryBrand,
                    onChanged: onIsFilledChanged,
                  ),
                ],
              ),
              if (isFilled) ...[
                const SizedBox(height: 8),
                const Text('Fill Color', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                ColorPickerWidget(
                  currentColor: fillColor,
                  onColorChanged: onFillColorChanged,
                ),
              ],
            ],

            const Divider(height: 20),
            ColorPickerWidget(
              currentColor: strokeColor,
              onColorChanged: onStrokeColorChanged,
            ),
          ],
        ),
      ),
    );
  }

  String _toolTitle(CanvasTool tool) {
    switch (tool) {
      case CanvasTool.pen:
        return 'Pen Settings';
      case CanvasTool.pencil:
        return 'Pencil Settings';
      case CanvasTool.brush:
        return 'Brush Settings';
      case CanvasTool.marker:
        return 'Marker Settings';
      case CanvasTool.highlighter:
        return 'Highlighter Settings';
      case CanvasTool.laser:
        return 'Laser Pointer Settings';
      case CanvasTool.eraser:
        return 'Eraser Settings';
      case CanvasTool.line:
      case CanvasTool.arrow:
      case CanvasTool.rectangle:
      case CanvasTool.circle:
      case CanvasTool.triangle:
      case CanvasTool.polygon:
      case CanvasTool.star:
        return 'Shape Settings';
      default:
        return 'Tool Settings';
    }
  }
}
