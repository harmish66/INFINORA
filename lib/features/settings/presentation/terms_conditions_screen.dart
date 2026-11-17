import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Terms and Conditions for Infinora - Infinite Canvas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text(
              'Last Updated: November 2026',
              style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
            ),
            SizedBox(height: 18),
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'By downloading, accessing, or using Infinora, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, please do not use the application.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '2. Intellectual Property Rights',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'You retain full intellectual property ownership of all artwork, notes, designs, sketches, and exported images that you create using Infinora. We claim zero ownership or license rights over your creative creations.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '3. User Responsibilities',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'You are responsible for safely managing and maintaining backups of your local project files. Because Infinora is an offline-first tool, deleting the application or clearing device app data without creating backups will delete local files.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'Infinora is provided on an "as is" and "as available" basis without warranties of any kind. In no event shall the authors or copyright holders be liable for any direct or consequential damages resulting from the use of the app.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 16),
            Text(
              '5. Modifications',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text(
              'We reserve the right to revise these Terms and Conditions at any time. Continued use of the application after changes constitutes acceptance of the updated terms.',
              style: TextStyle(fontSize: 14, height: 1.45),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
