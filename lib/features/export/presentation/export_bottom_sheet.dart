import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/project_thumbnail_widget.dart';
import '../../canvas/domain/models/camera_state.dart';
import '../../canvas/domain/models/canvas_layer.dart';
import '../../canvas/domain/models/canvas_object.dart';
import '../../projects/domain/models/project_model.dart';
import '../data/export_service.dart';

class ExportBottomSheet extends StatefulWidget {
  final String projectName;
  final List<CanvasObject> objects;
  final List<CanvasLayer> layers;
  final CameraState camera;
  final Color backgroundColor;
  final List<String> selectedObjectIds;
  final double? canvasWidth;
  final double? canvasHeight;

  const ExportBottomSheet({
    super.key,
    required this.projectName,
    required this.objects,
    required this.layers,
    required this.camera,
    required this.backgroundColor,
    required this.selectedObjectIds,
    this.canvasWidth,
    this.canvasHeight,
  });

  @override
  State<ExportBottomSheet> createState() => _ExportBottomSheetState();
}

class _ExportBottomSheetState extends State<ExportBottomSheet> {
  ExportFormat _selectedFormat = ExportFormat.png;
  ExportBoundsType _selectedBounds = ExportBoundsType.completeArtwork;
  double _scaleFactor = 1.0;
  bool _isExporting = false;
  bool _exportSuccess = false;

  Future<void> _handleExport() async {
    setState(() => _isExporting = true);
    try {
      final file = await ExportService.exportProjectToFile(
        projectName: widget.projectName,
        objects: widget.objects,
        layers: widget.layers,
        camera: widget.camera,
        backgroundColor: widget.backgroundColor,
        format: _selectedFormat,
        boundsType: _selectedBounds,
        selectedObjectIds: widget.selectedObjectIds,
        scaleFactor: _scaleFactor,
        loadedImages: const {},
        canvasWidth: widget.canvasWidth,
        canvasHeight: widget.canvasHeight,
      );

      if (!mounted) return;
      setState(() {
        _isExporting = false;
        _exportSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      Navigator.of(context).pop();

      // Trigger native share sheet
      await ExportService.shareExportedFile(
        file,
        text: 'Exported from Infinora Studio: ${widget.projectName}',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isExporting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dummyProject = ProjectModel(
      id: 'preview',
      name: widget.projectName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      backgroundColor: _selectedFormat == ExportFormat.transparentPng
          ? Colors.transparent
          : widget.backgroundColor,
      layers: widget.layers,
      objects: widget.objects,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Export & Share Artwork',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Interactive Artwork Preview Card
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      // Checkerboard background for transparent mode
                      if (_selectedFormat == ExportFormat.transparentPng)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _CheckerboardPainter(),
                          ),
                        ),
                      Positioned.fill(
                        child: ProjectThumbnailWidget(
                          project: dummyProject,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.65),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${_scaleFactor.round()}x · ${_selectedFormat.name.toUpperCase()}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Format Selection
              const Text(
                'Export File Format',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _FormatSelectionCard(
                    title: 'PNG',
                    badge: 'Lossless',
                    isSelected: _selectedFormat == ExportFormat.png,
                    onTap: () => setState(() => _selectedFormat = ExportFormat.png),
                  ),
                  const SizedBox(width: 8),
                  _FormatSelectionCard(
                    title: 'JPEG',
                    badge: 'Compact',
                    isSelected: _selectedFormat == ExportFormat.jpeg,
                    onTap: () => setState(() => _selectedFormat = ExportFormat.jpeg),
                  ),
                  const SizedBox(width: 8),
                  _FormatSelectionCard(
                    title: 'PDF',
                    badge: 'Vector',
                    isSelected: _selectedFormat == ExportFormat.pdf,
                    onTap: () => setState(() => _selectedFormat = ExportFormat.pdf),
                  ),
                  const SizedBox(width: 8),
                  _FormatSelectionCard(
                    title: 'Alpha PNG',
                    badge: 'Clear',
                    isSelected: _selectedFormat == ExportFormat.transparentPng,
                    onTap: () => setState(() => _selectedFormat = ExportFormat.transparentPng),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Bounds Selection
              const Text(
                'Canvas Export Area',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ChipOption(
                    label: 'Complete Artwork',
                    isSelected: _selectedBounds == ExportBoundsType.completeArtwork,
                    onTap: () => setState(() => _selectedBounds = ExportBoundsType.completeArtwork),
                  ),
                  const SizedBox(width: 8),
                  _ChipOption(
                    label: 'Current Viewport',
                    isSelected: _selectedBounds == ExportBoundsType.currentViewport,
                    onTap: () => setState(() => _selectedBounds = ExportBoundsType.currentViewport),
                  ),
                  if (widget.selectedObjectIds.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    _ChipOption(
                      label: 'Selection',
                      isSelected: _selectedBounds == ExportBoundsType.selection,
                      onTap: () => setState(() => _selectedBounds = ExportBoundsType.selection),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 18),

              // Resolution Scale
              const Text(
                'Resolution Quality',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ChipOption(
                    label: '1x Standard',
                    isSelected: _scaleFactor == 1.0,
                    onTap: () => setState(() => _scaleFactor = 1.0),
                  ),
                  const SizedBox(width: 8),
                  _ChipOption(
                    label: '2x High Res',
                    isSelected: _scaleFactor == 2.0,
                    onTap: () => setState(() => _scaleFactor = 2.0),
                  ),
                  const SizedBox(width: 8),
                  _ChipOption(
                    label: '4x Ultra Studio',
                    isSelected: _scaleFactor == 4.0,
                    onTap: () => setState(() => _scaleFactor = 4.0),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Export CTA
              SizedBox(
                width: double.infinity,
                child: PremiumPrimaryButton(
                  label: _exportSuccess ? 'Ready to Share!' : (_isExporting ? 'Generating High-Res File...' : 'Export & Share'),
                  isLoading: _isExporting,
                  icon: _exportSuccess ? Icons.check_circle : Icons.share_rounded,
                  onPressed: _isExporting ? null : _handleExport,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormatSelectionCard extends StatelessWidget {
  final String title;
  final String badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatSelectionCard({
    required this.title,
    required this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isDark
                ? (isSelected ? const Color(0xFF1E293B) : AppColors.darkSurface)
                : (isSelected ? const Color(0xFFF0FDF4) : AppColors.surface),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryBrand : (isDark ? AppColors.darkBorder : AppColors.border),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                badge,
                style: TextStyle(
                  fontSize: 9.5,
                  color: isSelected ? AppColors.primaryBrand : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChipOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChipOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryBrand
                : (isDark ? AppColors.darkSurface : AppColors.surface),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryBrand : (isDark ? AppColors.darkBorder : AppColors.border),
              width: isSelected ? 1.8 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : (isDark ? AppColors.darkPrimaryText : AppColors.primaryText),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

class _CheckerboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const squareSize = 10.0;
    final paint1 = Paint()..color = const Color(0xFFE2E8F0);
    final paint2 = Paint()..color = Colors.white;

    for (double x = 0; x < size.width; x += squareSize) {
      for (double y = 0; y < size.height; y += squareSize) {
        final isEven = ((x / squareSize).floor() + (y / squareSize).floor()).isEven;
        canvas.drawRect(
          Rect.fromLTWH(x, y, squareSize, squareSize),
          isEven ? paint1 : paint2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
