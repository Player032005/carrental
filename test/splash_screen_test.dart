import 'package:carrental/main.dart';
import 'package:carrental/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    setupFirebaseCoreMocks();
    await Firebase.initializeApp();
  });

  testWidgets('Splash screen navigates to login screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // The splash screen is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the splash screen to finish
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that the login screen is shown.
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}