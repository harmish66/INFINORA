import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/monetization/admob/ad_config.dart';
import '../../../core/monetization/admob/native_ad_manager.dart';
import '../../../core/monetization/subscriptions/subscription_service.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/project_thumbnail_widget.dart';
import '../../canvas/presentation/canvas_screen.dart';
import '../data/template_presets.dart';
import '../domain/models/template_model.dart';
import 'providers/template_providers.dart';
import 'template_preview_screen.dart';

class TemplatesScreen extends ConsumerStatefulWidget {
  const TemplatesScreen({super.key});

  @override
  ConsumerState<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends ConsumerState<TemplatesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _onlyFavorites = false;
  String _selectedDifficulty = 'All'; // 'All', 'Beginner', 'Intermediate', 'Advanced'
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _useTemplate(BuildContext context, TemplateModel template) async {
    final project = template.toProject(template.title);
    final repo = ref.read(projectRepositoryProvider);
    await repo.saveProject(project);
    ref.read(projectsListProvider.notifier).refresh();

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CanvasScreen(project: project)),
    );
  }

  void _openTemplatePreview(BuildContext context, TemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TemplatePreviewScreen(template: template),
      ),
    );
  }

  List<TemplateModel> _filterTemplates(List<TemplateModel> all, Set<String> favorites) {
    return all.where((t) {
      if (_onlyFavorites && !favorites.contains(t.id)) {
        return false;
      }
      if (_selectedCategory != 'All' && t.category != _selectedCategory) {
        return false;
      }
      if (_selectedDifficulty != 'All' &&
          t.difficulty.toLowerCase() != _selectedDifficulty.toLowerCase()) {
        return false;
      }
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase().trim();
        final matchTitle = t.title.toLowerCase().contains(query);
        final matchDesc = t.description.toLowerCase().contains(query);
        final matchCategory = t.category.toLowerCase().contains(query);
        final matchTags = t.tags.any((tag) => tag.toLowerCase().contains(query));
        if (!matchTitle && !matchDesc && !matchCategory && !matchTags) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allTemplates = TemplatePresets.allTemplates;
    final favorites = ref.watch(favoriteTemplatesProvider);
    final filtered = _filterTemplates(allTemplates, favorites);
    final isAdFree = ref.watch(isAdFreeUserProvider);

    final showFeatured = _searchQuery.isEmpty &&
        !_onlyFavorites &&
        _selectedCategory == 'All' &&
        _selectedDifficulty == 'All';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text(
          'Explore Templates',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Favorites Quick Toggle in AppBar
          IconButton(
            icon: Icon(
              _onlyFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _onlyFavorites ? const Color(0xFFE11D48) : null,
            ),
            tooltip: 'Show Favorites',
            onPressed: () {
              setState(() {
                _onlyFavorites = !_onlyFavorites;
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search & Filter Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      decoration: InputDecoration(
                        hintText: 'Search templates, styles, or tags...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurface : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDark ? AppColors.darkBorder : AppColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0284C7),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick Difficulty & Favorites Filter Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Favorites Chip
                          FilterChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _onlyFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                  size: 14,
                                  color: _onlyFavorites ? Colors.white : const Color(0xFFE11D48),
                                ),
                                const SizedBox(width: 4),
                                Text('Favorites (${favorites.length})'),
                              ],
                            ),
                            selected: _onlyFavorites,
                            onSelected: (val) => setState(() => _onlyFavorites = val),
                            selectedColor: const Color(0xFFE11D48),
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _onlyFavorites
                                  ? Colors.white
                                  : (isDark ? AppColors.darkPrimaryText : AppColors.primaryText),
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          const SizedBox(width: 8),

                          // Difficulty chips
                          for (final diff in ['All', 'Beginner', 'Intermediate', 'Advanced']) ...[
                            ChoiceChip(
                              label: Text(diff),
                              selected: _selectedDifficulty == diff,
                              onSelected: (sel) {
                                if (sel) setState(() => _selectedDifficulty = diff);
                              },
                              selectedColor: const Color(0xFF0284C7),
                              labelStyle: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: _selectedDifficulty == diff
                                    ? Colors.white
                                    : (isDark ? AppColors.darkPrimaryText : AppColors.primaryText),
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            const SizedBox(width: 6),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Horizontally Scrollable 18 Category Bar
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: TemplatePresets.categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = TemplatePresets.categories[index];
                    final isSelected = _selectedCategory == cat;
                    final count = cat == 'All'
                        ? allTemplates.length
                        : allTemplates.where((t) => t.category == cat).length;

                    return InkWell(
                      onTap: () => setState(() => _selectedCategory = cat),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0284C7)
                              : (isDark ? AppColors.darkSurface : Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0284C7)
                                : (isDark ? AppColors.darkBorder : AppColors.border),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.darkPrimaryText : AppColors.primaryText),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : (isDark ? Colors.white12 : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Featured Hero Section (when browsing All)
            if (showFeatured) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: Color(0xFFD97706), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Featured & Spotlight',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 190,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: TemplatePresets.featuredTemplates.take(5).length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final feat = TemplatePresets.featuredTemplates[index];
                      final previewProj = feat.toProject(feat.title);

                      return InkWell(
                        onTap: () => _openTemplatePreview(context, feat),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: 280,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.border,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Visual Preview Half
                              SizedBox(
                                width: 120,
                                height: double.infinity,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(13),
                                  ),
                                  child: ProjectThumbnailWidget(
                                    project: previewProj,
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(13),
                                    ),
                                  ),
                                ),
                              ),
                              // Content Half
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          feat.category,
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF0284C7),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        feat.title,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        feat.description,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: isDark
                                              ? AppColors.darkSecondaryText
                                              : AppColors.secondaryText,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () => _useTemplate(context, feat),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0284C7),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          minimumSize: const Size(0, 28),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: const Text('Try Now', style: TextStyle(fontSize: 10.5)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],

            // Real Google Mobile Ads Native Ad Section
            if (!isAdFree && AdConfig.isAdMobEnabled && AdConfig.enableTemplateNativeAd) ...[
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: NativeTemplateSectionAdWidget(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],

            // Section Header: All Templates
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      _selectedCategory == 'All' ? 'All Templates' : _selectedCategory,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${filtered.length})',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Empty State
            if (filtered.isEmpty) ...[
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF94A3B8)),
                      const SizedBox(height: 12),
                      const Text(
                        'No matching templates found',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try clearing search keywords or resetting difficulty and category filters.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                            _selectedCategory = 'All';
                            _selectedDifficulty = 'All';
                            _onlyFavorites = false;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Reset All Filters'),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Grid View of Templates
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.70,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final tpl = filtered[index];
                      final previewProj = tpl.toProject(tpl.title);
                      final isFav = favorites.contains(tpl.id);

                      return InkWell(
                        onTap: () => _openTemplatePreview(context, tpl),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.border,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Artwork Vector Thumbnail
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned.fill(
                                      child: ProjectThumbnailWidget(
                                        project: previewProj,
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(13),
                                        ),
                                      ),
                                    ),
                                    // Pro Badge
                                    if (tpl.isPremium)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFD97706),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'PRO',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    // Favorite Toggle Button
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.35),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          constraints: const BoxConstraints(
                                            minWidth: 32,
                                            minHeight: 32,
                                          ),
                                          padding: EdgeInsets.zero,
                                          icon: Icon(
                                            isFav
                                                ? Icons.favorite_rounded
                                                : Icons.favorite_border_rounded,
                                            size: 16,
                                            color: isFav ? const Color(0xFFE11D48) : Colors.white,
                                          ),
                                          onPressed: () {
                                            ref
                                                .read(favoriteTemplatesProvider.notifier)
                                                .toggleFavorite(tpl.id);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Template Info & Action
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tpl.title,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      tpl.description,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: isDark
                                            ? AppColors.darkSecondaryText
                                            : AppColors.secondaryText,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 30,
                                      child: OutlinedButton(
                                        onPressed: () => _useTemplate(context, tpl),
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Use Template',
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
