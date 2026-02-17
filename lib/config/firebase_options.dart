import 'package:firebase_core/firebase_core.dart';

// TODO: Update these Firebase options with your project details
// Get these from Firebase Console -> Project Settings -> Your Apps
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // For development, using default options
    // Update with your actual Firebase project details
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',
      appId: 'YOUR_APP_ID',
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
      projectId: 'YOUR_PROJECT_ID',
      authDomain: 'YOUR_AUTH_DOMAIN',
      databaseURL: 'YOUR_DATABASE_URL',
      storageBucket: 'YOUR_STORAGE_BUCKET',
    );
  }
}
