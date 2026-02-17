import 'package:carrental/config/firebase_options.dart';
import 'package:carrental/main.dart';
import 'package:carrental/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mocks
class MockFirebaseCore extends Mock implements FirebasePlatform {
  @override
  Future<FirebaseAppPlatform> initializeApp({
    String? name,
    FirebaseOptions? options,
  }) async {
    return MockFirebaseApp();
  }
}

class MockFirebaseApp extends Mock implements FirebaseAppPlatform {}

void main() async {
  // Initialize Firebase for testing
  TestWidgetsFlutterBinding.ensureInitialized();
  setupFirebaseCoreMocks();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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