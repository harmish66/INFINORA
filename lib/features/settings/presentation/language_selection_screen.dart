import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/monetization/admob/native_ad_manager.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/creative_illustrations.dart';
import 'widgets/country_flag_widget.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  final bool isInitialSetup;

  const LanguageSelectionScreen({
    super.key,
    this.isInitialSetup = true,
  });

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  late String _selectedCode;

  final List<Map<String, String>> _languages = const [
    {
      'code': 'en',
      'name': 'English',
      'native': 'English',
      'badge': 'EN',
      'script': 'Latin',
    },
    {
      'code': 'hi',
      'name': 'Hindi',
      'native': 'हिन्दी',
      'badge': 'HI',
      'script': 'देवनागरी',
    },
    {
      'code': 'gu',
      'name': 'Gujarati',
      'native': 'ગુજરાતી',
      'badge': 'GU',
      'script': 'ગુજરાતી',
    },
    {
      'code': 'es',
      'name': 'Spanish',
      'native': 'Español',
      'badge': 'ES',
      'script': 'Romance',
    },
    {
      'code': 'fr',
      'name': 'French',
      'native': 'Français',
      'badge': 'FR',
      'script': 'Romance',
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'native': 'العربية',
      'badge': 'AR',
      'script': 'العربية',
    },
  ];

  @override
  void initState() {
    super.initState();
    final currentLocale = ref.read(localeProvider);
    _selectedCode = currentLocale?.languageCode ?? 'en';
  }

  Future<void> _handleContinue() async {
    await ref.read(localeProvider.notifier).setLocale(_selectedCode);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('language_selected', true);

    if (!mounted) return;

    if (widget.isInitialSetup) {
      final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
      if (seenOnboarding) {
        context.go('/home');
      } else {
        context.go('/onboarding');
      }
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: widget.isInitialSetup
          ? null
          : AppBar(
              title: const Text('Language Settings'),
              centerTitle: true,
              elevation: 0,
            ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Header Illustration & Title
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // Language Globe Artwork
                      const Center(
                        child: LanguageWorldIllustration(size: 140),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'Choose Your Language',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Select your preferred workspace language. You can change this anytime in Settings.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // 6 Language Selection Cards
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.35,
                        ),
                        itemCount: _languages.length,
                        itemBuilder: (context, index) {
                          final lang = _languages[index];
                          final code = lang['code']!;
                          final isSelected = _selectedCode == code;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCode = code;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? (isSelected ? const Color(0xFF1E293B) : AppColors.darkSurface)
                                    : (isSelected ? const Color(0xFFF0FDF4) : AppColors.surface),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBrand
                                      : (isDark ? AppColors.darkBorder : AppColors.border),
                                  width: isSelected ? 2.0 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryBrand.withValues(alpha: 0.25),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Flag Image / Icon + Code Badge
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CountryFlagWidget(
                                            code: code,
                                            width: 32,
                                            height: 22,
                                            borderRadius: 4,
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primaryBrand
                                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              lang['badge']!,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      // Selection radio indicator
                                      if (isSelected)
                                        const Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryBrand,
                                          size: 19,
                                        )
                                      else
                                        Icon(
                                          Icons.radio_button_unchecked,
                                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                                          size: 17,
                                        ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang['native']!,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        lang['name']!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Dedicated non-intrusive native advertisement in reserved bottom area
              const NativeLanguageBottomAdWidget(),

              // Continue Action Button
              SizedBox(
                width: double.infinity,
                child: PremiumPrimaryButton(
                  label: 'Continue',
                  icon: Icons.arrow_forward,
                  onPressed: _handleContinue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
