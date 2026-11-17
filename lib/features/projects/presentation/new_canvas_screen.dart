import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../canvas/domain/models/canvas_layer.dart';
import '../../canvas/domain/models/canvas_object.dart';
import '../../canvas/presentation/canvas_screen.dart';
import '../domain/models/project_model.dart';

enum CanvasPreset {
  infinite,
  square,
  portrait,
  landscape,
  a4Portrait,
  custom,
}

class NewCanvasScreen extends ConsumerStatefulWidget {
  const NewCanvasScreen({super.key});

  @override
  ConsumerState<NewCanvasScreen> createState() => _NewCanvasScreenState();
}

class _NewCanvasScreenState extends ConsumerState<NewCanvasScreen> {
  final TextEditingController _nameController = TextEditingController(text: 'Untitled Canvas');
  final TextEditingController _widthController = TextEditingController(text: '1920');
  final TextEditingController _heightController = TextEditingController(text: '1080');

  CanvasPreset _selectedPreset = CanvasPreset.infinite;
  Color _backgroundColor = const Color(0xFFFFFFFF);
  String _gridStyle = 'dots';
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onPresetChanged(CanvasPreset preset) {
    setState(() {
      _selectedPreset = preset;
      switch (preset) {
        case CanvasPreset.infinite:
          break;
        case CanvasPreset.square:
          _widthController.text = '1080';
          _heightController.text = '1080';
          break;
        case CanvasPreset.portrait:
          _widthController.text = '1080';
          _heightController.text = '1920';
          break;
        case CanvasPreset.landscape:
          _widthController.text = '1920';
          _heightController.text = '1080';
          break;
        case CanvasPreset.a4Portrait:
          _widthController.text = '1240';
          _heightController.text = '1754';
          break;
        case CanvasPreset.custom:
          break;
      }
    });
  }

  Future<void> _handleImportImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      const uuid = Uuid();
      final projectId = uuid.v4();
      final layerId = uuid.v4();

      final bytes = await File(picked.path).readAsBytes();
      final decoded = await decodeImageFromList(bytes);
      final size = Size(decoded.width.toDouble(), decoded.height.toDouble());
      final scale = (size.width > 600) ? 600 / size.width : 1.0;
      final finalSize = Size(size.width * scale, size.height * scale);

      final imageObj = ImageCanvasObject(
        id: uuid.v4(),
        layerId: layerId,
        orderIndex: 0,
        imagePath: picked.path,
        position: Offset(-finalSize.width / 2, -finalSize.height / 2),
        width: finalSize.width,
        height: finalSize.height,
      );

      final layer = CanvasLayer(
        id: layerId,
        projectId: projectId,
        name: 'Layer 1',
        orderIndex: 0,
        isVisible: true,
        isLocked: false,
        opacity: 1.0,
      );

      final project = ProjectModel(
        id: projectId,
        name: 'Imported Canvas',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        layers: [layer],
        objects: [imageObj],
      );

      final repo = ref.read(projectRepositoryProvider);
      await repo.saveProject(project);
      ref.read(projectsListProvider.notifier).refresh();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => CanvasScreen(project: project)),
        );
      }
    }
  }

  Future<void> _handleCreate() async {
    setState(() => _isCreating = true);
    final String name = _nameController.text.trim().isEmpty ? 'Untitled Canvas' : _nameController.text.trim();

    double? w;
    double? h;
    if (_selectedPreset != CanvasPreset.infinite) {
      w = double.tryParse(_widthController.text) ?? 1920;
      h = double.tryParse(_heightController.text) ?? 1080;
    }

    const uuid = Uuid();
    final projectId = uuid.v4();
    final defaultLayerId = uuid.v4();

    final defaultLayer = CanvasLayer(
      id: defaultLayerId,
      projectId: projectId,
      name: 'Layer 1',
      orderIndex: 0,
      isVisible: true,
      isLocked: false,
      opacity: 1.0,
    );

    final project = ProjectModel(
      id: projectId,
      name: name,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      backgroundColor: _backgroundColor,
      gridStyle: _gridStyle,
      canvasWidth: w,
      canvasHeight: h,
      layers: [defaultLayer],
      objects: const [],
    );

    final repo = ref.read(projectRepositoryProvider);
    await repo.saveProject(project);
    ref.read(projectsListProvider.notifier).refresh();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CanvasScreen(project: project)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Create Canvas'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4 Mode Selection Quick Cards
              Row(
                children: [
                  Expanded(
                    child: _ModeSelectionCard(
                      title: 'Infinite Zoom',
                      subtitle: 'Boundless scale',
                      icon: Icons.all_out_rounded,
                      color: const Color(0xFF0284C7),
                      isSelected: _selectedPreset == CanvasPreset.infinite,
                      onTap: () => _onPresetChanged(CanvasPreset.infinite),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeSelectionCard(
                      title: 'Fixed Framing',
                      subtitle: 'Document sizes',
                      icon: Icons.crop_free_rounded,
                      color: const Color(0xFF10B981),
                      isSelected: _selectedPreset != CanvasPreset.infinite,
                      onTap: () => _onPresetChanged(CanvasPreset.landscape),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ModeSelectionCard(
                      title: 'Import Image',
                      subtitle: 'Trace photo / sketch',
                      icon: Icons.add_photo_alternate_outlined,
                      color: const Color(0xFFF59E0B),
                      isSelected: false,
                      onTap: _handleImportImage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeSelectionCard(
                      title: 'Templates',
                      subtitle: 'Browse 8 presets',
                      icon: Icons.dashboard_customize_outlined,
                      color: const Color(0xFF2563EB),
                      isSelected: false,
                      onTap: () => context.push('/templates'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Project Name Field
              Text(
                'Project Title',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'My Masterpiece',
                  prefixIcon: Icon(Icons.edit_outlined, size: 20),
                ),
              ),

              const SizedBox(height: 24),

              // Canvas Dimensions Presets
              Text(
                'Canvas Aspect Ratio & Dimensions',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _PresetRatioCard(
                      label: 'Infinite',
                      sub: 'Unlimited',
                      icon: Icons.all_out,
                      isSelected: _selectedPreset == CanvasPreset.infinite,
                      onTap: () => _onPresetChanged(CanvasPreset.infinite),
                    ),
                    const SizedBox(width: 8),
                    _PresetRatioCard(
                      label: 'Square',
                      sub: '1080 x 1080',
                      icon: Icons.crop_square,
                      isSelected: _selectedPreset == CanvasPreset.square,
                      onTap: () => _onPresetChanged(CanvasPreset.square),
                    ),
                    const SizedBox(width: 8),
                    _PresetRatioCard(
                      label: 'Landscape',
                      sub: '1920 x 1080',
                      icon: Icons.crop_16_9,
                      isSelected: _selectedPreset == CanvasPreset.landscape,
                      onTap: () => _onPresetChanged(CanvasPreset.landscape),
                    ),
                    const SizedBox(width: 8),
                    _PresetRatioCard(
                      label: 'Portrait',
                      sub: '1080 x 1920',
                      icon: Icons.crop_portrait,
                      isSelected: _selectedPreset == CanvasPreset.portrait,
                      onTap: () => _onPresetChanged(CanvasPreset.portrait),
                    ),
                    const SizedBox(width: 8),
                    _PresetRatioCard(
                      label: 'A4 Document',
                      sub: '1240 x 1754',
                      icon: Icons.description_outlined,
                      isSelected: _selectedPreset == CanvasPreset.a4Portrait,
                      onTap: () => _onPresetChanged(CanvasPreset.a4Portrait),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Background Color Swatches
              Text(
                'Background Paper Color',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _ColorSwatch(
                    color: const Color(0xFFFFFFFF),
                    label: 'Pure White',
                    isSelected: _backgroundColor == const Color(0xFFFFFFFF),
                    onTap: () => setState(() => _backgroundColor = const Color(0xFFFFFFFF)),
                  ),
                  const SizedBox(width: 10),
                  _ColorSwatch(
                    color: const Color(0xFFF7F8FC),
                    label: 'Studio Off-White',
                    isSelected: _backgroundColor == const Color(0xFFF7F8FC),
                    onTap: () => setState(() => _backgroundColor = const Color(0xFFF7F8FC)),
                  ),
                  const SizedBox(width: 10),
                  _ColorSwatch(
                    color: const Color(0xFFFFFDF5),
                    label: 'Warm Cream',
                    isSelected: _backgroundColor == const Color(0xFFFFFDF5),
                    onTap: () => setState(() => _backgroundColor = const Color(0xFFFFFDF5)),
                  ),
                  const SizedBox(width: 10),
                  _ColorSwatch(
                    color: const Color(0xFF1E222D),
                    label: 'Slate Dark',
                    isSelected: _backgroundColor == const Color(0xFF1E222D),
                    onTap: () => setState(() => _backgroundColor = const Color(0xFF1E222D)),
                  ),
                  const SizedBox(width: 10),
                  _ColorSwatch(
                    color: const Color(0xFF11121A),
                    label: 'Deep Night',
                    isSelected: _backgroundColor == const Color(0xFF11121A),
                    onTap: () => setState(() => _backgroundColor = const Color(0xFF11121A)),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Grid Style Visual Selector
              Text(
                'Canvas Drafting Grid Style',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _GridStyleCard(
                    title: 'None',
                    styleKey: 'none',
                    isSelected: _gridStyle == 'none',
                    onTap: () => setState(() => _gridStyle = 'none'),
                  ),
                  const SizedBox(width: 8),
                  _GridStyleCard(
                    title: 'Dots',
                    styleKey: 'dots',
                    isSelected: _gridStyle == 'dots',
                    onTap: () => setState(() => _gridStyle = 'dots'),
                  ),
                  const SizedBox(width: 8),
                  _GridStyleCard(
                    title: 'Lines',
                    styleKey: 'lines',
                    isSelected: _gridStyle == 'lines',
                    onTap: () => setState(() => _gridStyle = 'lines'),
                  ),
                  const SizedBox(width: 8),
                  _GridStyleCard(
                    title: 'Crosses',
                    styleKey: 'crosses',
                    isSelected: _gridStyle == 'crosses',
                    onTap: () => setState(() => _gridStyle = 'crosses'),
                  ),
                  const SizedBox(width: 8),
                  _GridStyleCard(
                    title: 'Isometric',
                    styleKey: 'isometric',
                    isSelected: _gridStyle == 'isometric',
                    onTap: () => setState(() => _gridStyle = 'isometric'),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Create CTA
              SizedBox(
                width: double.infinity,
                child: PremiumPrimaryButton(
                  label: _isCreating ? 'Creating Workspace...' : 'Create Canvas',
                  icon: Icons.check,
                  isLoading: _isCreating,
                  onPressed: _isCreating ? null : _handleCreate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeSelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeSelectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? const Color(0xFF1E293B) : AppColors.darkSurface)
              : (isSelected ? const Color(0xFFF0FDF4) : AppColors.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBrand : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetRatioCard extends StatelessWidget {
  final String label;
  final String sub;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetRatioCard({
    required this.label,
    required this.sub,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: isDark
              ? (isSelected ? const Color(0xFF1E293B) : AppColors.darkSurface)
              : (isSelected ? const Color(0xFFF0FDF4) : AppColors.surface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBrand : (isDark ? AppColors.darkBorder : AppColors.border),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: isSelected ? AppColors.primaryBrand : Colors.grey),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              sub,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorSwatch({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.primaryBrand : Colors.grey.shade400,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    size: 18,
                    color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            label.split(' ').first,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _GridStyleCard extends StatelessWidget {
  final String title;
  final String styleKey;
  final bool isSelected;
  final VoidCallback onTap;

  const _GridStyleCard({
    required this.title,
    required this.styleKey,
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
              _buildGridThumbnail(styleKey, isDark),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridThumbnail(String key, bool isDark) {
    final dotColor = isDark ? Colors.white38 : Colors.black38;

    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _MiniGridPainter(styleKey: key, color: dotColor),
      ),
    );
  }
}

class _MiniGridPainter extends CustomPainter {
  final String styleKey;
  final Color color;

  _MiniGridPainter({required this.styleKey, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    switch (styleKey) {
      case 'dots':
        paint.style = PaintingStyle.fill;
        for (double x = 4; x <= size.width - 4; x += 8) {
          for (double y = 4; y <= size.height - 4; y += 8) {
            canvas.drawCircle(Offset(x, y), 1.0, paint);
          }
        }
        break;
      case 'lines':
        for (double x = 4; x <= size.width; x += 8) {
          canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
        }
        for (double y = 4; y <= size.height; y += 8) {
          canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
        }
        break;
      case 'crosses':
        for (double x = 6; x <= size.width - 6; x += 12) {
          for (double y = 6; y <= size.height - 6; y += 12) {
            canvas.drawLine(Offset(x - 2, y), Offset(x + 2, y), paint);
            canvas.drawLine(Offset(x, y - 2), Offset(x, y + 2), paint);
          }
        }
        break;
      case 'isometric':
        paint.strokeWidth = 0.8;
        canvas.drawLine(const Offset(0, 12), Offset(size.width, 0), paint);
        canvas.drawLine(const Offset(0, 24), Offset(size.width, 12), paint);
        canvas.drawLine(Offset(0, 0), Offset(size.width, 12), paint);
        canvas.drawLine(Offset(0, 12), Offset(size.width, 24), paint);
        break;
      default:
        // 'none' - empty box
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
