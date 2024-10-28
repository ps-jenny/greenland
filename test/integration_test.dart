import 'package:greenland/LoginPage.dart';
import 'package:greenland/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenland/main.dart' as app;
// Adjust this import based on your actual main.dart file

void main() {
  testWidgets('Welcome, Signup, and Signin Navigation Integration Test',
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    final signupButtonFinder = find.byKey(Key('signupButtonKey'));
    final signinButtonFinder = find.byKey(Key('signinButtonKey'));

    // Navigate to SignupPage
    if (signupButtonFinder.evaluate().isNotEmpty) {
      await tester.tap(signupButtonFinder);
      await tester.pumpAndSettle();
      // Verify SignupPage is displayed
      expect(find.byType(SignUpPage), findsOneWidget);
    }

    // Navigate to SigninPage
    if (signinButtonFinder.evaluate().isNotEmpty) {
      await tester.tap(signinButtonFinder);
      await tester.pumpAndSettle();
      // Verify SigninPage is displayed
      expect(find.byType(LoginPage), findsOneWidget);
    }
  });
}
