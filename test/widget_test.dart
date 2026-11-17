import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinora/core/widgets/common_widgets.dart';

void main() {
  group('Widget Tests', () {
    testWidgets('PremiumPrimaryButton renders label and triggers tap', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PremiumPrimaryButton(
              label: 'Create Canvas',
              onPressed: () => tapped = true,
              icon: Icons.add,
            ),
          ),
        ),
      );

      expect(find.text('Create Canvas'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.text('Create Canvas'));
      expect(tapped, true);
    });

    testWidgets('EmptyStateWidget renders title, description and button', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.palette_outlined,
              title: 'No Projects Yet',
              description: 'Create your first canvas to begin sketching.',
              actionLabel: 'New Project',
              onAction: () => actionTriggered = true,
            ),
          ),
        ),
      );

      expect(find.text('No Projects Yet'), findsOneWidget);
      expect(find.text('Create your first canvas to begin sketching.'), findsOneWidget);
      expect(find.text('New Project'), findsOneWidget);

      await tester.tap(find.text('New Project'));
      expect(actionTriggered, true);
    });

    testWidgets('ConfirmationDialog calls confirm callback', (tester) async {
      bool confirmed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmationDialog(
                      title: 'Delete Item',
                      message: 'Are you sure?',
                      confirmLabel: 'Delete',
                      cancelLabel: 'Cancel',
                      onConfirm: () => confirmed = true,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Item'), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(confirmed, true);
    });
  });
}
