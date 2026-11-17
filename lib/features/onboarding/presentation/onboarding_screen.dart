import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import 'widgets/onboarding_artwork_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = const [
    {
      'tag': 'UNBOUNDED CANVAS',
      'icon': Icons.all_out_rounded,
      'title': 'Boundless Vector Space',
      'desc': 'Think, design, and sketch without edges. An expansive infinite canvas built for creative ideation, architectural drafts, and mind mapping.',
      'artwork': InfiniteCanvasArtwork(width: 320, height: 210),
    },
    {
      'tag': 'STUDIO INSTRUMENTS',
      'icon': Icons.draw_rounded,
      'title': 'Precision Drawing Tools',
      'desc': 'Pressure-sensitive ink pens, technical graphite pencils, chisel markers, highlighters, and smart geometric vector shapes at your fingertips.',
      'artwork': StudioToolsArtwork(width: 320, height: 210),
    },
    {
      'tag': '10,000X DEEP ZOOM',
      'icon': Icons.zoom_in_map_rounded,
      'title': 'Infinite Nested Worlds',
      'desc': 'Zoom seamlessly from overarching concept roadmaps down to sub-pixel microscopic details with smooth, focal-point optical precision.',
      'artwork': InfiniteZoomArtwork(width: 320, height: 210),
    },
    {
      'tag': 'LOSSLESS VAULT',
      'icon': Icons.file_download_outlined,
      'title': 'Studio Export & Security',
      'desc': 'All your sketches stay private and fully offline on your device. Export high-resolution PNG, ultra-crisp JPEG, and multi-page PDF documents.',
      'artwork': LosslessExportArtwork(width: 320, height: 210),
    },
  ];

  Future<void> _completeOnboarding() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.setHasSeenOnboarding(true);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded, size: 20),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
        actions: [
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _completeOnboarding,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Slide Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tag Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                page['icon'] as IconData,
                                size: 14,
                                color: const Color(0xFF0284C7),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                page['tag'] as String,
                                style: const TextStyle(
                                  color: Color(0xFF0284C7),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Attractive Visual Artwork Card
                        Center(child: page['artwork'] as Widget),

                        const SizedBox(height: 28),

                        // Title
                        Text(
                          page['title'] as String,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 10),

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            page['desc'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                              height: 1.5,
                              fontSize: 13.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Navigation & Progress Indicator
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                children: [
                  // Minimal Indicator Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (idx) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == idx ? 28 : 8,
                        height: 5,
                        decoration: BoxDecoration(
                          color: _currentPage == idx
                              ? const Color(0xFF0284C7)
                              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Continue / Get Started Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: PremiumPrimaryButton(
                      label: _currentPage == _pages.length - 1 ? 'Start Creating' : 'Continue',
                      icon: _currentPage == _pages.length - 1 ? Icons.check : Icons.arrow_forward_rounded,
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _completeOnboarding();
                        }
                      },
                    ),
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
