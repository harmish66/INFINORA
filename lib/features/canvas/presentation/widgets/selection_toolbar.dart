import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/canvas_controller.dart';

class SelectionToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onScaleUp;
  final VoidCallback onScaleDown;
  final VoidCallback onRotate;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onDeselect;
  final VoidCallback onBringToFront;
  final VoidCallback onSendToBack;
  final VoidCallback onBringForward;
  final VoidCallback onSendBackward;
  final void Function(ObjectAlignment) onAlign;

  const SelectionToolbar({
    super.key,
    required this.selectedCount,
    required this.onScaleUp,
    required this.onScaleDown,
    required this.onRotate,
    required this.onDuplicate,
    required this.onDelete,
    required this.onDeselect,
    required this.onBringToFront,
    required this.onSendToBack,
    required this.onBringForward,
    required this.onSendBackward,
    required this.onAlign,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Compact selected item count badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$selectedCount',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0284C7),
                ),
              ),
            ),
            Container(
              height: 18,
              width: 1,
              color: isDark ? AppColors.darkBorder : AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 3),
            ),

            // Scale Up / Enlarge
            _ToolbarAction(
              icon: Icons.zoom_in,
              tooltip: 'Enlarge (+25%)',
              onPressed: onScaleUp,
            ),

            // Scale Down / Shrink
            _ToolbarAction(
              icon: Icons.zoom_out,
              tooltip: 'Shrink (-20%)',
              onPressed: onScaleDown,
            ),

            // Rotate
            _ToolbarAction(
              icon: Icons.rotate_right,
              tooltip: 'Rotate 90 degrees',
              onPressed: onRotate,
            ),

            // Duplicate
            _ToolbarAction(
              icon: Icons.copy_outlined,
              tooltip: 'Duplicate',
              onPressed: onDuplicate,
            ),

            // Arrange & Layering Menu (Top, Bottom, Forward, Backward, Align)
            SizedBox(
              width: 32,
              height: 32,
              child: PopupMenuButton<String>(
                tooltip: 'Arrange & Adjust (Top, Bottom, Align)',
                padding: EdgeInsets.zero,
                iconSize: 18,
                icon: const Icon(
                  Icons.layers_outlined,
                  color: Color(0xFF0284C7),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: isDark ? AppColors.darkSurface : Colors.white,
                elevation: 8,
                onSelected: (val) {
                  switch (val) {
                    case 'front':
                      onBringToFront();
                      break;
                    case 'forward':
                      onBringForward();
                      break;
                    case 'backward':
                      onSendBackward();
                      break;
                    case 'back':
                      onSendToBack();
                      break;
                    case 'align_top':
                      onAlign(ObjectAlignment.top);
                      break;
                    case 'align_center_v':
                      onAlign(ObjectAlignment.centerV);
                      break;
                    case 'align_bottom':
                      onAlign(ObjectAlignment.bottom);
                      break;
                    case 'align_left':
                      onAlign(ObjectAlignment.left);
                      break;
                    case 'align_center_h':
                      onAlign(ObjectAlignment.centerH);
                      break;
                    case 'align_right':
                      onAlign(ObjectAlignment.right);
                      break;
                  }
                },
                itemBuilder: (ctx) => [
                  const PopupMenuItem<String>(
                    enabled: false,
                    height: 26,
                    child: Text(
                      'LAYER ORDER (TOP / BOTTOM)',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0284C7),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'front',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(Icons.flip_to_front_rounded, size: 18, color: Color(0xFF0284C7)),
                        SizedBox(width: 10),
                        Text('Bring to Top / Front', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'forward',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_upward_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Bring Forward (+1 level)', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'backward',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Send Backward (-1 level)', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'back',
                    height: 38,
                    child: Row(
                      children: [
                        Icon(Icons.flip_to_back_rounded, size: 18, color: Color(0xFF64748B)),
                        SizedBox(width: 10),
                        Text('Send to Bottom / Back', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(height: 12),
                  const PopupMenuItem<String>(
                    enabled: false,
                    height: 26,
                    child: Text(
                      'ALIGNMENT ADJUSTMENTS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF059669),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_top',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_vertical_top_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align to Top', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_center_v',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_vertical_center_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align Center Vertical', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_bottom',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_vertical_bottom_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align to Bottom', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_left',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_horizontal_left_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align to Left', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_center_h',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_horizontal_center_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align Center Horizontal', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'align_right',
                    height: 36,
                    child: Row(
                      children: [
                        Icon(Icons.align_horizontal_right_rounded, size: 18),
                        SizedBox(width: 10),
                        Text('Align to Right', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Delete
            _ToolbarAction(
              icon: Icons.delete_outline,
              tooltip: 'Delete',
              color: AppColors.error,
              onPressed: onDelete,
            ),

            Container(
              height: 18,
              width: 1,
              color: isDark ? AppColors.darkBorder : AppColors.border,
              margin: const EdgeInsets.symmetric(horizontal: 3),
            ),

            // Deselect / Done
            _ToolbarAction(
              icon: Icons.check_rounded,
              tooltip: 'Done',
              color: AppColors.primaryBrand,
              onPressed: onDeselect,
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color? color;

  const _ToolbarAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? AppColors.darkPrimaryText : AppColors.primaryText;

    return IconButton(
      icon: Icon(icon, size: 18, color: color ?? defaultColor),
      tooltip: tooltip,
      onPressed: onPressed,
      style: IconButton.styleFrom(
        minimumSize: const Size(30, 30),
        maximumSize: const Size(32, 32),
        padding: const EdgeInsets.all(4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
