import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../core/widgets/creative_illustrations.dart';
import 'widgets/country_flag_widget.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _cacheSize = 'Calculating...';

  @override
  void initState() {
    super.initState();
    _calculateStorageUsage();
  }

  Future<void> _calculateStorageUsage() async {
    try {
      final tempDir = await getTemporaryDirectory();
      int totalBytes = 0;
      if (tempDir.existsSync()) {
        final files = tempDir.listSync(recursive: true, followLinks: false);
        for (final file in files) {
          if (file is File) {
            totalBytes += await file.length();
          }
        }
      }
      final mb = (totalBytes / (1024 * 1024)).toStringAsFixed(1);
      if (mounted) {
        setState(() => _cacheSize = '$mb MB');
      }
    } catch (e) {
      if (mounted) setState(() => _cacheSize = '0.0 MB');
    }
  }

  Future<void> _clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        final files = tempDir.listSync(recursive: true, followLinks: false);
        for (final file in files) {
          if (file is File) {
            try {
              file.deleteSync();
            } catch (_) {}
          }
        }
      }
      await _calculateStorageUsage();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Temporary cache cleared successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: 'Clear Temporary Cache',
        message: 'This will remove temporary export files. Your projects and drawings will remain completely safe.',
        confirmLabel: 'Clear Cache',
        cancelLabel: 'Cancel',
        isDestructive: false,
        onConfirm: _clearCache,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);
    final settingsRepo = ref.watch(settingsRepositoryProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: Appearance
          const _SectionHeader(title: 'Appearance'),
          RoundedCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ThemeOptionTile(
                  title: 'System Default',
                  isSelected: themeMode == ThemeMode.system,
                  onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system),
                ),
                const Divider(height: 8),
                _ThemeOptionTile(
                  title: 'Light Theme',
                  isSelected: themeMode == ThemeMode.light,
                  onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light),
                ),
                const Divider(height: 8),
                _ThemeOptionTile(
                  title: 'Dark Theme',
                  isSelected: themeMode == ThemeMode.dark,
                  onTap: () => ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Language
          const _SectionHeader(title: 'Language & Locale'),
          RoundedCard(
            onTap: () => context.push('/language', extra: false),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.language_rounded, color: AppColors.primaryBrand),
                    SizedBox(width: 12),
                    Text('Workspace Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ],
                ),
                Row(
                  children: [
                    CountryFlagWidget(
                      code: currentLocale?.languageCode ?? 'en',
                      width: 24,
                      height: 16,
                      borderRadius: 3,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getLanguageDisplayName(currentLocale?.languageCode ?? 'en'),
                      style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Canvas Preferences
          const _SectionHeader(title: 'Canvas Preferences'),
          RoundedCard(
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.brush_outlined, color: AppColors.primaryBrand),
                  title: const Text('Default Stroke Width', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Text(
                    '${settingsRepo.getDefaultBrushSize().round()} px',
                    style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.grid_4x4_rounded, color: AppColors.primaryBrand),
                  title: const Text('Default Grid Style', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Text(
                    settingsRepo.getDefaultGridStyle().toUpperCase(),
                    style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: Storage
          const _SectionHeader(title: 'Storage & Data'),
          RoundedCard(
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.storage_rounded, color: AppColors.primaryBrand),
                  title: const Text('Temporary Cache', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  subtitle: const Text('Rendered export files', style: TextStyle(fontSize: 12)),
                  trailing: Text(
                    _cacheSize,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 8),
                SecondaryButton(
                  label: 'Clear Temporary Cache',
                  width: double.infinity,
                  height: 42,
                  icon: Icons.cleaning_services_rounded,
                  onPressed: _showClearCacheDialog,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section: About & Legal
          const _SectionHeader(title: 'About Infinora'),
          RoundedCard(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      InfinoraLogoGlyph(size: 44),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Infinora',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Infinite Canvas Studio',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 16),
                const ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.info_outline_rounded, color: AppColors.primaryBrand),
                  title: Text('App Version', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: Text('1.0.0 (Build 1)', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                ),
                const Divider(height: 12),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.primaryBrand),
                  title: const Text('Privacy Policy', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.secondaryText),
                  onTap: () => context.push('/privacy-policy'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getLanguageDisplayName(String code) {
    switch (code) {
      case 'hi':
        return 'हिन्दी (Hindi)';
      case 'gu':
        return 'ગુજરાતી (Gujarati)';
      case 'es':
        return 'Español (Spanish)';
      case 'fr':
        return 'Français (French)';
      case 'ar':
        return 'العربية (Arabic)';
      default:
        return 'English';
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.secondaryText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? AppColors.primaryBrand : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryBrand, size: 20)
          : const Icon(Icons.radio_button_unchecked_rounded, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
