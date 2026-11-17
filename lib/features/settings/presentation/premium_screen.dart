import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/creative_illustrations.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlanIndex = 1; // 0 = monthly, 1 = yearly (best value)

  final List<Map<String, dynamic>> _features = const [
    {
      'title': 'Ultra HD & 8K Vector Export',
      'desc': 'Export crystal-clear PNG, JPEG, and PDF documents at any resolution.',
      'icon': Icons.high_quality_outlined,
      'color': Color(0xFF0284C7),
    },
    {
      'title': 'Unlimited Studio Layers',
      'desc': 'Create multi-depth compositions with layer opacity and blending controls.',
      'icon': Icons.layers_outlined,
      'color': Color(0xFF10B981),
    },
    {
      'title': 'Extreme Infinite Zoom',
      'desc': 'Explore deep nested fractal artwork zooming up to 1,000,000 percent.',
      'icon': Icons.zoom_in,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'Pro Brush & Texture Suite',
      'desc': 'Unlock calligraphy, watercolor markers, geometric guides, and stickers.',
      'icon': Icons.brush_outlined,
      'color': Color(0xFF2563EB),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Infinora Pro Studio'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Large Premium Hero Illustration
              const Center(
                child: PremiumHeroIllustration(size: 150),
              ),

              const SizedBox(height: 16),

              Text(
                'Unlock Unlimited Creative Freedom',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 6),

              Text(
                'Experience professional boundless canvas drawing with pro studio tools and ultra-high-resolution exports.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Feature Cards
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _features.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final f = _features[index];
                  final iconColor = f['color'] as Color;

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(f['icon'] as IconData, color: iconColor, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f['title'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                f['desc'] as String,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Pricing Plan Cards
              Row(
                children: [
                  // Monthly Card
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedPlanIndex = 0),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPlanIndex == 0
                                ? AppColors.primaryBrand
                                : (isDark ? AppColors.darkBorder : AppColors.border),
                            width: _selectedPlanIndex == 0 ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Monthly',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '\$4.99',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Billed monthly',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Yearly Card (Highlighted)
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedPlanIndex = 1),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? (_selectedPlanIndex == 1 ? const Color(0xFF1E293B) : AppColors.darkSurface)
                              : (_selectedPlanIndex == 1 ? const Color(0xFFEFF6FF) : AppColors.surface),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedPlanIndex == 1
                                ? AppColors.primaryBrand
                                : (isDark ? AppColors.darkBorder : AppColors.border),
                            width: _selectedPlanIndex == 1 ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Yearly',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'SAVE 33%',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              '\$39.99',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '\$3.33 per month',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subscribe CTA
              SizedBox(
                width: double.infinity,
                child: PremiumPrimaryButton(
                  label: _selectedPlanIndex == 1 ? 'Start Yearly Studio Access' : 'Start Monthly Studio Access',
                  icon: Icons.workspace_premium,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Infinora Pro Studio subscription activated.')),
                    );
                    context.pop();
                  },
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.push('/privacy-policy'),
                    child: const Text('Privacy Policy', style: TextStyle(fontSize: 12)),
                  ),
                  const Text('·', style: TextStyle(color: Colors.grey)),
                  TextButton(
                    onPressed: () => context.push('/terms-conditions'),
                    child: const Text('Terms of Service', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
