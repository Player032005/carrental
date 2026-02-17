# Car Rental App - Setup Instructions

## 🚀 Quick Start Guide

### Prerequisites

Before you begin, ensure you have:
- Flutter SDK (v3.10.4 or higher)
- Dart SDK
- Android Studio / Xcode
- Firebase account
- Google Chrome (for web development)

### Step 1: Firebase Project Setup

1. **Create Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Click "Add project"
   - Enter "CarRental" as project name
   - Enable Google Analytics (optional)
   - Click "Create project"

2. **Enable Authentication:**
   - In Firebase Console, go to "Authentication"
   - Click "Get Started"
   - Select "Email/Password" provider
   - Click "Enable"
   - Save your changes

3. **Create Firestore Database:**
   - Go to "Firestore Database"
   - Click "Create Database"
   - Start in **Test mode** (for development)
   - Choose cloud region closest to you
   - Click "Create"

4. **Get Firebase Configuration:**

   **For Android:**
   - In Firebase Console, go to Project Settings
   - Under "Your apps", click the Android icon
   - Register your app with package name `com.example.carrental`
   - Download `google-services.json`
   - Place it in `android/app/` directory

   **For iOS:**
   - Register iOS app with bundle ID `com.example.carrental`
   - Download `GoogleService-Info.plist`
   - Add it to Xcode project under Runner folder

### Step 2: Update Firebase Options

1. Open `lib/config/firebase_options.dart`

2. Update with your Firebase credentials:

```dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'YOUR_API_KEY',              // From Firebase Settings
      appId: 'YOUR_APP_ID',                 // From Firebase Settings
      messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',  // From Firebase Settings
      projectId: 'YOUR_PROJECT_ID',         // From Firebase Settings
      authDomain: 'YOUR_AUTH_DOMAIN',       // YOUR_PROJECT_ID.firebaseapp.com
      databaseURL: 'YOUR_DATABASE_URL',
      storageBucket: 'YOUR_STORAGE_BUCKET', // YOUR_PROJECT_ID.appspot.com
    );
  }
}
```

### Step 3: Create Firestore Collections

1. In Firebase Console, go to Firestore Database
2. Create the following collections:

   **Collection: users**
   - Click "Start Collection"
   - Collection ID: `users`
   - Auto-generate document ID
   - Click "Save"

   **Collection: cars**
   - Repeat for `cars` collection

   **Collection: bookings**
   - Repeat for `bookings` collection

   **Collection: reviews**
   - Repeat for `reviews` collection

### Step 4: Install Dependencies

```bash
cd carrental
flutter pub get
```

### Step 5: Run the App

```bash
# Run on connected device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## 📊 Sample Data Setup

After app setup, add sample data to Firestore:

### Add Sample Car

1. In Firebase Console, go to Firestore
2. Click on "cars" collection
3. Click "Add Document"
4. Add this data:

```json
{
  "name": "Toyota Camry",
  "model": "2023",
  "year": 2023,
  "category": "Sedan",
  "pricePerDay": 49.99,
  "rating": 4.5,
  "reviewCount": 28,
  "seats": 5,
  "transmission": "Automatic",
  "fuelType": "Petrol",
  "airConditioning": true,
  "description": "Reliable family sedan with excellent fuel economy and comfortable seating",
  "imageUrls": [
    "https://via.placeholder.com/400x300?text=Toyota+Camry"
  ],
  "isAvailable": true,
  "bookedDates": [],
  "createdAt": "2024-02-17T00:00:00Z"
}
```

### Add More Sample Cars

Repeat the above process with different car details.

## 🗄️ Firestore Security Rules (Production)

For production, update your Firestore Security Rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own documents
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
    
    // Anyone can read cars
    match /cars/{document=**} {
      allow read: if true;
      allow write: if request.auth.uid != null && request.auth.token.isAdmin == true;
    }
    
    // Users can read/write their own bookings
    match /bookings/{bookingId} {
      allow read, write: if request.auth.uid == resource.data.userId;
    }
    
    // Anyone can read reviews
    match /reviews/{reviewId} {
      allow read: if true;
      allow create: if request.auth.uid != null;
      allow update, delete: if request.auth.uid == resource.data.userId;
    }
  }
}
```

## 🔧 Configuration Files

### pubspec.yaml
Already configured with all required dependencies. No changes needed unless you want to add more packages.

### iOS Configuration (if building for iOS)

1. Open `ios/Podfile`
2. Ensure minimum iOS version is 11.0:
```ruby
platform :ios, '11.0'
```

3. Run:
```bash
cd ios
pod install
cd ..
```

### Android Configuration

Ensure `android/build.gradle` has:
```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
}
```

## 📱 Testing the App

### Test User Account

Create a test user in Firebase:

1. Go to Firebase Console → Authentication
2. Click "Add User"
3. Email: `test@example.com`
4. Password: `Test@1234`

### Test Data

The app comes with predefined sample data structures. You can:
1. Manually add cars through Firestore
2. Use the admin panel (commented in code)
3. Create bookings through the app UI

## 🛠️ Troubleshooting

### Firebase Initialization Error
```
Error: Firebase initialization failed
```
**Solution:**
- Verify Firebase credentials in `firebase_options.dart`
- Check internet connection
- Ensure Firebase project is active
- Verify Android/iOS app registration in Firebase Console

### Firestore Permission Denied
```
Error: Missing or insufficient permissions
```
**Solution:**
- For development, use Firestore in Test mode
- Check Security Rules in Firestore Console
- Ensure user is authenticated before accessing data

### Dependencies Installation Issues
```bash
# Clear pub cache
flutter pub cache clean

# Get dependencies again
flutter pub get

# If still issues, use upgrade
flutter pub upgrade
```

### Build Issues

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Rebuild
flutter pub run build_runner build
```

## 📱 Building for Production

### Android APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS IPA

```bash
flutter build ios --release
```

### Web

```bash
flutter build web
```

## 📋 Checklist Before Deployment

- [ ] Update Firebase credentials
- [ ] Configure Firestore Security Rules
- [ ] Add real car images (replace placeholder URLs)
- [ ] Test all features (auth, booking, profile, etc.)
- [ ] Test on real devices (Android & iOS)
- [ ] Update app version in `pubspec.yaml`
- [ ] Update app name/branding if needed
- [ ] Test error handling and edge cases
- [ ] Verify internet connectivity handling
- [ ] Test on slow network conditions

## 📞 Support Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
- [Firebase Auth](https://firebase.google.com/docs/auth)

## 🎓 Learning Resources

### Understanding the App Architecture

1. **Models** (`lib/models/`)
   - Define data structures
   - Include validation logic
   - Support JSON serialization

2. **Services** (`lib/services/`)
   - Handle Firebase operations
   - Provide business logic
   - Manage data fetching/storing

3. **Providers** (`lib/providers/`)
   - Manage app state using Provider package
   - Notify UI of changes
   - Handle loading and error states

4. **Screens** (`lib/screens/`)
   - UI pages visible to users
   - Use Consumers to rebuild on state changes
   - Handle user interactions

5. **Widgets** (`lib/widgets/`)
   - Reusable UI components
   - Follow DRY principle
   - Support composition

## 🚀 Next Steps

1. **Customize Branding:**
   - Update app name
   - Change color scheme in `constants/app_colors.dart`
   - Update app strings in `constants/app_strings.dart`

2. **Add Features:**
   - Payment integration
   - Email notifications
   - Push notifications
   - In-app messaging
   - Advanced analytics

3. **Optimize Performance:**
   - Implement image caching
   - Add pagination for large lists
   - Optimize Firestore queries
   - Lazy load data

## 📝 Useful Commands

```bash
# Check Flutter version
flutter --version

# Analyze code
flutter analyze

# Run tests
flutter test

# Get all dependencies
flutter pub get

# Update dependencies
flutter pub upgrade

# Clean everything
flutter clean

# Build runner for code generation
flutter pub run build_runner build

# Check device connectivity
flutter devices

# Update Flutter
flutter upgrade
```

---

**Your Car Rental App is now ready to use! 🚗✨**

For any issues or questions, refer to the IMPLEMENTATION_GUIDE.md for detailed architecture information.
