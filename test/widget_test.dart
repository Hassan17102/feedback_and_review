import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:feedback_and_review/main.dart';

void main() {
  testWidgets('Login screen loads with email, password and Sign In button', (
    WidgetTester tester,
  ) async {
    // Build the app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Check that the Login screen header/text exists
    expect(find.textContaining('Welcome', findRichText: false), findsOneWidget);

    // There should be two TextFormFields (email & password)
    expect(find.byType(TextFormField), findsNWidgets(2));

    // The Sign In button should be present
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);

    // The "Don't have an account?" or Sign Up link should be present
    expect(
      find.textContaining("Don't have an account", findRichText: false),
      findsOneWidget,
    );

    // Optionally: tap Sign In (this will only navigate if validation passes)
    // await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    // await tester.pumpAndSettle();
  });
}
