import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/monetization/admob/ad_config.dart';
import '../../../core/monetization/admob/banner_ad_manager.dart';
import '../../../core/monetization/admob/native_ad_manager.dart';
import '../../../core/monetization/admob/navigation_ad_controller.dart';
import '../../../core/monetization/subscriptions/subscription_service.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/creative_illustrations.dart';
import '../../../core/widgets/project_thumbnail_widget.dart';
import '../../canvas/domain/models/canvas_layer.dart';
import '../../canvas/domain/models/canvas_object.dart';
import '../../canvas/presentation/canvas_screen.dart';
import '../../projects/domain/models/project_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0; // 0 = All, 1 = Favorites, 2 = Archived
  bool _isGridView = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openProject(ProjectModel project) async {
    final repo = ref.read(projectRepositoryProvider);
    final fullProject = await repo.getProjectById(project.id) ?? project;

    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CanvasScreen(project: fullProject)),
    );
    if (mounted) {
      ref.read(projectsListProvider.notifier).refresh();
    }
  }

  Widget _buildGridCard(ProjectModel proj) {
    return _CommercialGridCard(
      project: proj,
      onTap: () => _openProject(proj),
      onToggleFavorite: () {
        ref.read(projectsListProvider.notifier).toggleFavorite(
              proj.id,
              !proj.isFavorite,
            );
      },
      onRename: () => _showRenameDialog(proj),
      onDuplicate: () async {
        final dup = await ref.read(projectsListProvider.notifier).duplicateProject(
              proj.id,
              '${proj.name} (Copy)',
            );
        if (mounted) _openProject(dup);
      },
      onToggleArchive: () {
        ref.read(projectsListProvider.notifier).toggleArchive(
              proj.id,
              !proj.isArchived,
            );
      },
      onDelete: () => _showDeleteDialog(proj),
    );
  }

  Future<void> _handleNewCanvas() async {
    const uuid = Uuid();
    final projectId = uuid.v4();
    final layerId = uuid.v4();

    final project = ProjectModel(
      id: projectId,
      name: 'Untitled ${DateFormat('MMM d, h:mm a').format(DateTime.now())}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      layers: [
        CanvasLayer(
          id: layerId,
          projectId: projectId,
          name: 'Layer 1',
          orderIndex: 0,
          isVisible: true,
          isLocked: false,
          opacity: 1.0,
        ),
      ],
      objects: const [],
      cameraZoom: 1.0,
    );

    final repo = ref.read(projectRepositoryProvider);
    await repo.saveProject(project);
    ref.read(projectsListProvider.notifier).refresh();

    if (mounted) {
      _openProject(project);
    }
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
      final scale = (size.width > 800) ? 800 / size.width : 1.0;
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
        _openProject(project);
      }
    }
  }

  void _showRenameDialog(ProjectModel project) {
    final controller = TextEditingController(text: project.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Rename Project'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Project name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              Navigator.pop(ctx);
              if (newName.isNotEmpty) {
                final repo = ref.read(projectRepositoryProvider);
                await repo.saveProject(project.copyWith(name: newName));
                ref.read(projectsListProvider.notifier).refresh();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(ProjectModel project) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Delete Project',
        message: 'Are you sure you want to delete "${project.name}"? This action cannot be undone.',
        confirmLabel: 'Delete',
        cancelLabel: 'Cancel',
        isDestructive: true,
        onConfirm: () async {
          await ref.read(projectsListProvider.notifier).deleteProject(project.id);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final projectsAsync = ref.watch(projectsListProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Studio Header (Clean & Minimalist, like Procreate / Concepts)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 16, 10),
              child: Row(
                children: [
                  const InfinoraLogoGlyph(size: 32),
                  const SizedBox(width: 10),
                  Text(
                    'Infinora',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                    ),
                  ),
                  const Spacer(),
                  // Pro Studio Access Chip
                  InkWell(
                    onTap: () => context.push('/premium'),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.workspace_premium_outlined, size: 15, color: Color(0xFF2563EB)),
                          SizedBox(width: 4),
                          Text(
                            'Studio Pro',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 21),
                    tooltip: 'Settings',
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            // Studio Action Strip (+ New Canvas, Import, Templates)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: _handleNewCanvas,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('New Canvas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrand,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: _handleImportImage,
                        icon: const Icon(Icons.image_outlined, size: 16),
                        label: const Text('Import', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 40,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          NavigationAdController.recordBrowsingInteraction();
                          NavigationAdController.handleNavigationWithAd(
                            context: context,
                            destinationRoute: '/templates',
                            ref: ref,
                            onNavigate: () => context.push('/templates'),
                          );
                        },
                        icon: const Icon(Icons.dashboard_customize_outlined, size: 16),
                        label: const Text('Templates', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Search Bar & Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() {}),
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search artworks...',
                          hintStyle: TextStyle(fontSize: 12.5, color: isDark ? Colors.white38 : Colors.black38),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 16),
                                  onPressed: () => setState(() => _searchController.clear()),
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          filled: true,
                          fillColor: isDark ? AppColors.darkSurface : AppColors.surface,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.primaryBrand, width: 1.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(_isGridView ? Icons.view_list_outlined : Icons.grid_view_outlined, size: 20),
                    tooltip: _isGridView ? 'List View' : 'Grid View',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _isGridView = !_isGridView),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Tab Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StudioTab(
                    label: 'All Artworks',
                    isSelected: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                  const SizedBox(width: 16),
                  _StudioTab(
                    label: 'Starred',
                    isSelected: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                  const SizedBox(width: 16),
                  _StudioTab(
                    label: 'Archived',
                    isSelected: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ],
              ),
            ),

            const Divider(height: 16, thickness: 1),

            // Projects Gallery Viewport
            Expanded(
              child: projectsAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryBrand),
                ),
                error: (err, stack) => Center(
                  child: Text('Error: $err'),
                ),
                data: (allProjects) {
                  final query = _searchController.text.trim().toLowerCase();
                  final filtered = allProjects.where((p) {
                    if (query.isNotEmpty && !p.name.toLowerCase().contains(query)) {
                      return false;
                    }
                    if (_selectedTabIndex == 1) return p.isFavorite && !p.isArchived;
                    if (_selectedTabIndex == 2) return p.isArchived;
                    return !p.isArchived;
                  }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const EmptyProjectsIllustration(size: 110),
                            const SizedBox(height: 16),
                            Text(
                              _selectedTabIndex == 1
                                  ? 'No Starred Artworks'
                                  : (_selectedTabIndex == 2 ? 'No Archived Artworks' : 'No Artworks Yet'),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _selectedTabIndex == 1
                                  ? 'Star projects in the gallery to easily access them here.'
                                  : (_selectedTabIndex == 2
                                      ? 'Archived projects will be preserved here.'
                                      : 'Tap New Canvas above to start drawing on an unlimited infinite canvas.'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                height: 1.4,
                              ),
                            ),
                            if (_selectedTabIndex == 0) ...[
                              const SizedBox(height: 16),
                              OutlinedButton.icon(
                                onPressed: () => context.push('/templates'),
                                icon: const Icon(Icons.dashboard_customize_outlined, size: 16),
                                label: const Text('Explore Templates', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                                  side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  final isAdFree = ref.watch(isAdFreeUserProvider);
                  final showProjectNativeAd = !isAdFree &&
                      AdConfig.isAdMobEnabled &&
                      AdConfig.enableProjectNativeAd &&
                      filtered.length >= 3;
                  const adIndex = 2;

                  if (_isGridView) {
                    if (showProjectNativeAd && filtered.length >= 2) {
                      final firstChunk = filtered.take(2).toList();
                      final remainingChunk = filtered.skip(2).toList();
                      return CustomScrollView(
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                            sliver: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _buildGridCard(firstChunk[index]),
                                childCount: firstChunk.length,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                              child: NativeProjectListAdWidget(),
                            ),
                          ),
                          if (remainingChunk.isNotEmpty)
                            SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              sliver: SliverGrid(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.85,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildGridCard(remainingChunk[index]),
                                  childCount: remainingChunk.length,
                                ),
                              ),
                            ),
                        ],
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) => _buildGridCard(filtered[index]),
                    );
                  } else {
                    final listCount = showProjectNativeAd ? filtered.length + 1 : filtered.length;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: listCount,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        if (showProjectNativeAd && index == adIndex) {
                          return const NativeProjectListAdWidget();
                        }
                        final projIndex =
                            (showProjectNativeAd && index > adIndex) ? index - 1 : index;
                        final proj = filtered[projIndex];
                        return _CommercialListCard(
                          project: proj,
                          onTap: () => _openProject(proj),
                          onToggleFavorite: () {
                            ref.read(projectsListProvider.notifier).toggleFavorite(
                                  proj.id,
                                  !proj.isFavorite,
                                );
                          },
                          onRename: () => _showRenameDialog(proj),
                          onDuplicate: () async {
                            final dup = await ref.read(projectsListProvider.notifier).duplicateProject(
                                  proj.id,
                                  '${proj.name} (Copy)',
                                );
                            if (mounted) _openProject(dup);
                          },
                          onToggleArchive: () {
                            ref.read(projectsListProvider.notifier).toggleArchive(
                                  proj.id,
                                  !proj.isArchived,
                                );
                          },
                          onDelete: () => _showDeleteDialog(proj),
                        );
                      },
                    );
                  }
                },
              ),
            ),

            // AdMob Banner for Free Users (Clean, non-intrusive)
            const AdmobBannerWidget(placement: 'home_bottom'),
          ],
        ),
      ),
    );
  }
}

class _StudioTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _StudioTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.white : AppColors.primaryText)
                    : (isDark ? AppColors.darkSecondaryText : AppColors.secondaryText),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 2,
              width: isSelected ? 24 : 0,
              color: isSelected ? AppColors.primaryBrand : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _CommercialGridCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onToggleArchive;
  final VoidCallback onDelete;

  const _CommercialGridCard({
    required this.project,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onRename,
    required this.onDuplicate,
    required this.onToggleArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = DateFormat('MMM d').format(project.updatedAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork Preview
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ProjectThumbnailWidget(
                      project: project,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                    ),
                  ),

                  // Favorite Icon Button
                  Positioned(
                    top: 6,
                    left: 6,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          project.isFavorite ? Icons.star : Icons.star_outline,
                          size: 14,
                          color: project.isFavorite ? Colors.amber : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Project Info Footer
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$dateStr · ${project.objects.length} elements',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (val) {
                      switch (val) {
                        case 'rename':
                          onRename();
                          break;
                        case 'duplicate':
                          onDuplicate();
                          break;
                        case 'archive':
                          onToggleArchive();
                          break;
                        case 'delete':
                          onDelete();
                          break;
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: 'rename', child: Text('Rename')),
                      const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      PopupMenuItem(
                        value: 'archive',
                        child: Text(project.isArchived ? 'Unarchive' : 'Archive'),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                      ),
                    ],
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

class _CommercialListCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback onRename;
  final VoidCallback onDuplicate;
  final VoidCallback onToggleArchive;
  final VoidCallback onDelete;

  const _CommercialListCard({
    required this.project,
    required this.onTap,
    required this.onToggleFavorite,
    required this.onRename,
    required this.onDuplicate,
    required this.onToggleArchive,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateStr = DateFormat('MMM d, yyyy').format(project.updatedAt);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: ProjectThumbnailWidget(
                project: project,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    project.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr · ${project.objects.length} elements',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                project.isFavorite ? Icons.star : Icons.star_outline,
                color: project.isFavorite ? Colors.amber : Colors.grey,
                size: 19,
              ),
              onPressed: onToggleFavorite,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              onSelected: (val) {
                switch (val) {
                  case 'rename':
                    onRename();
                    break;
                  case 'duplicate':
                    onDuplicate();
                    break;
                  case 'archive':
                    onToggleArchive();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (ctx) => [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                PopupMenuItem(
                  value: 'archive',
                  child: Text(project.isArchived ? 'Unarchive' : 'Archive'),
                ),
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
