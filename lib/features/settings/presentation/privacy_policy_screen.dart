import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy for Infinora: Infinite Canvas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              'Effective Date: November 19, 2026',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            const SizedBox(height: 16),

            _buildHighlightBanner(
              'Core Privacy Guarantee: Infinora uses a local-first architecture. Your drawings, sketches, canvas objects, notes, and imported photos remain stored strictly on your personal device. The app is completely free to use with no in-app purchases.',
              isDark,
            ),
            const SizedBox(height: 20),

            _buildSection(
              '1. Overview',
              'Infinora: Infinite Canvas ("we", "us", or "our") values and respects your personal privacy. This Privacy Policy explains our practices regarding user information, local data handling, and third-party advertising SDK integrations within our Android application (Package: com.hpcreation.infinora).',
            ),

            _buildSection(
              '2. Artwork and Creative Content (Local Storage Only)',
              'All creative work generated in Infinora stays on your device:\n'
              '• Zero Cloud Upload: Your drawings, vector strokes, canvas layers, notes, and exported images are saved exclusively in your device private app directory and SQLite database.\n'
              '• No Account Needed: You can use all canvas features without creating an account or providing personal details.\n'
              '• On-Device Processing: Image imports, color mixing, stroke rendering, and exports occur entirely on-device without network transmission.',
            ),

            _buildSection(
              '3. Advertising and Google AdMob',
              'To support ongoing maintenance and provide free access to all canvas tools, Infinora displays advertisements through Google AdMob (Google LLC). Google AdMob may collect and process certain device and diagnostic data to deliver ads:\n'
              '• Google Advertising ID (AAID)\n'
              '• Coarse approximate location derived from IP address (country or city level, no GPS tracking)\n'
              '• Device technical data (model, operating system version, carrier)\n'
              '• Ad interaction and performance metrics\n\n'
              'You can reset or opt out of personalized ads at any time via your device settings at Settings > Google > Ads.',
            ),

            _buildSection(
              '4. No In-App Purchases or Financial Transactions',
              'Infinora does not offer or process any in-app purchases, paid subscriptions, paywalls, or digital transactions. All drawing, sketching, painting, and infinite canvas tools are completely free to use. We do not request, process, or store credit card details, debit card numbers, billing addresses, or any banking or financial information.',
            ),

            _buildSection(
              '5. Device Permissions',
              'Infinora requests only essential permissions required for creative operations:\n'
              '• Photos and Media Access: Used only when you choose to import a reference picture onto your canvas or export high-resolution drawings to your gallery.\n'
              '• Internet Access: Used exclusively to load ads from Google AdMob and access external support links.\n'
              '• Network State: Used to check connectivity before ad requests.',
            ),

            _buildSection(
              '6. Children\'s Privacy (COPPA Compliance)',
              'Infinora is a general audience creative productivity app designed for sketching, ideation, and digital art. The application is not directed toward children under 13 years of age. We do not knowingly collect personal information from children.',
            ),

            _buildSection(
              '7. Data Retention and Deletion',
              'Because your artwork is stored locally on your device:\n'
              '• Project Deletion: Deleting a project inside the app immediately and permanently purges that file and its database records from your device.\n'
              '• Complete Data Purge: Clearing app data in Android Settings > Apps > Infinora > Storage or uninstalling the app permanently deletes all local project files.\n'
              '• Advertising Data: Data collected by Google AdMob is retained according to Google standard privacy retention policies.',
            ),

            _buildSection(
              '8. Data Security',
              'Your drawings are protected by the Android application sandbox, preventing unauthorized access by other installed apps. Any network communication for ads uses industry-standard HTTPS/TLS encryption.',
            ),

            _buildSection(
              '9. Contact Information',
              'If you have any questions or feedback regarding this Privacy Policy or your data protection, please reach out to us:\n'
              '• Application: Infinora: Infinite Canvas\n'
              '• Developer: [YOUR DEVELOPER / STUDIO NAME]\n'
              '• Email: support@infinora.app\n'
              '• Website: https://infinora-privacy.blogspot.com/2026/11/privacy-policy-infinora-infinite-canvas.html',
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static Widget _buildHighlightBanner(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: const Color(0xFF2563EB),
            width: 4,
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          height: 1.45,
          fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E3A8A),
        ),
      ),
    );
  }

  static Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
