import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Privacy Policy for Infinora - Infinite Canvas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Last Updated: November 2026',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            SizedBox(height: 18),
            Text(
              '1. Overview',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Infinora is committed to safeguarding your privacy. Our core philosophy is local-first creativity. Your drawings, sketches, notes, and imported pictures are stored directly on your personal device using local SQLite and storage directories.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '2. Data Collection and Usage',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'We do not collect personal identifiable information. We do not transmit your creative artwork, canvas layers, or private notes to external servers. All project rendering, image export, and document generation occur on-device without cloud dependence.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '3. Device Permissions',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Infinora requests device permissions only when strictly necessary for user-initiated actions, such as picking an image from your photo library or exporting canvas documents to your device storage.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '4. Third-Party Services',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Infinora operates completely offline. We do not use third-party analytics trackers, background profiling tools, or external ad networks in this version.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '5. Contact and Inquiries',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'If you have questions regarding this Privacy Policy or your data security, please contact us at support@infinora.app.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
