import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/monetization/admob/native_ad_manager.dart';
import '../../../core/monetization/admob/rewarded_ad_manager.dart';
import '../../../core/monetization/subscriptions/subscription_service.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/project_thumbnail_widget.dart';
import '../../canvas/presentation/canvas_screen.dart';
import '../domain/models/template_model.dart';
import 'providers/template_providers.dart';

class TemplatePreviewScreen extends ConsumerWidget {
  final TemplateModel template;

  const TemplatePreviewScreen({
    super.key,
    required this.template,
  });

  void _handleUseTemplate(BuildContext context, WidgetRef ref) async {
    final project = template.toProject(template.title);
    final repo = ref.read(projectRepositoryProvider);
    await repo.saveProject(project);
    ref.read(projectsListProvider.notifier).refresh();

    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CanvasScreen(project: project)),
    );
  }

  void _handleUnlockWithAd(BuildContext context, WidgetRef ref) {
    RewardedAdManager.showRewardedAdWithConsent(
      context: context,
      rewardTitle: 'Unlock Premium Template',
      rewardDescription: 'Unlock access to "${template.title}" for your current editing session.',
      onRewardGranted: () {
        _handleUseTemplate(context, ref);
      },
      onFailedOrDeclined: () {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Watch the entire video to unlock this premium template.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAdFree = ref.watch(isAdFreeUserProvider);
    final requiresUnlock = template.isPremium && !isAdFree;
    final favorites = ref.watch(favoriteTemplatesProvider);
    final isFav = favorites.contains(template.id);
    final previewProject = template.toProject(template.title);

    final difficultyColor = switch (template.difficulty.toLowerCase()) {
      'beginner' => const Color(0xFF059669),
      'intermediate' => const Color(0xFF0284C7),
      'advanced' => const Color(0xFFD97706),
      _ => const Color(0xFF64748B),
    };

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          template.title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? const Color(0xFFE11D48) : null,
            ),
            tooltip: isFav ? 'Remove from Favorites' : 'Add to Favorites',
            onPressed: () {
              ref.read(favoriteTemplatesProvider.notifier).toggleFavorite(template.id);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Artwork Live Preview Card
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ProjectThumbnailWidget(
                        project: previewProject,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    if (template.isPremium)
                      Positioned(
                        top: 14,
                        right: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD97706),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'PRO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (requiresUnlock) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF78350F).withValues(alpha: 0.3)
                      : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark ? const Color(0xFFB45309) : const Color(0xFFFDE68A),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Premium template: Unlock for free by watching a short video ad, or subscribe to Studio Pro for unlimited access.',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isDark ? const Color(0xFFFDE68A) : const Color(0xFF92400E),
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Metadata Badges Row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Category Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(template.icon, size: 14, color: const Color(0xFF0284C7)),
                      const SizedBox(width: 6),
                      Text(
                        template.category,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ),

                // Difficulty Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: difficultyColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    template.difficulty.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: difficultyColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),

                // Vector Objects Count
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Text(
                    '${previewProject.objects.length} vector objects',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Title & Description
            Text(
              template.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              template.description,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),

            // Canvas Specs Grid Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Canvas Specifications',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  _specRow(
                    context: context,
                    icon: Icons.all_out_rounded,
                    label: 'Canvas Format',
                    value: template.canvasWidth != null
                        ? '${template.canvasWidth!.toInt()} x ${template.canvasHeight!.toInt()} px'
                        : 'Unbounded Infinite Canvas',
                    isDark: isDark,
                  ),
                  const Divider(height: 16),
                  _specRow(
                    context: context,
                    icon: Icons.grid_4x4_rounded,
                    label: 'Grid Pattern',
                    value: template.gridStyle.toUpperCase(),
                    isDark: isDark,
                  ),
                  const Divider(height: 16),
                  _specRow(
                    context: context,
                    icon: Icons.zoom_in_rounded,
                    label: 'Initial Zoom Level',
                    value: '${template.initialZoom}x (Infinite Range 0.05x to 1000x)',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Suggested Usage & Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_rounded,
                    color: Color(0xFF0284C7),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Suggested Usage & Creative Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          template.suggestedUsage,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Tags
            if (template.tags.isNotEmpty) ...[
              const Text(
                'Tags',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: template.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                      ),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Optional Native Advertisement below main template details
            const NativeTemplateDetailsAdWidget(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
          ),
          child: Row(
            children: [
              // Favorite Quick Toggle
              IconButton.outlined(
                icon: Icon(
                  isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: isFav ? const Color(0xFFE11D48) : null,
                ),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.border,
                  ),
                ),
                onPressed: () {
                  ref.read(favoriteTemplatesProvider.notifier).toggleFavorite(template.id);
                },
              ),
              const SizedBox(width: 12),

              // Use Template or Unlock Button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: requiresUnlock
                      ? () => _handleUnlockWithAd(context, ref)
                      : () => _handleUseTemplate(context, ref),
                  icon: Icon(
                    requiresUnlock ? Icons.ondemand_video_rounded : Icons.palette_rounded,
                    size: 18,
                  ),
                  label: Text(
                    requiresUnlock ? 'Watch Ad to Unlock' : 'Use Template',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: requiresUnlock
                        ? const Color(0xFFD97706)
                        : const Color(0xFF0284C7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _specRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0284C7)),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
