import 'package:firebase_core/firebase_core.dart';
import 'package:carrental/firebase_options.dart';

/// Firebase configuration class
class FirebaseConfig {
  /// Initialize Firebase
  static Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }
}