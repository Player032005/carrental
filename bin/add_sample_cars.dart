import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Firebase config - update these with your Firebase project details
const String projectId = 'carrental-f4d21'; // Replace with your project ID
const String apiKey = 'AIzaSyCugkfthvNmrzl8PUh-rvABu2OaSbz75-I'; // Replace with your API key

void main() async {
  print('🔧 Prerequisites:');
  print('1. Make sure you have internet connection');
  print('2. Firestore database created in Firebase Console');
  print('3. Firebase project is accessible\n');

  // Initialize Firebase with explicit options
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey,
      appId: '1:869636106856:web:12345678abcdefgh',
      messagingSenderId: '869636106856',
      projectId: projectId,
      authDomain: '$projectId.firebaseapp.com',
      databaseURL: 'https://$projectId.firebaseio.com',
      storageBucket: '$projectId.appspot.com',
    ),
  );

  final firestore = FirebaseFirestore.instance;

  final cars = [
    {
      'name': 'Tesla Model 3',
      'model': '2024',
      'category': 'Sedan',
      'description': 'Luxury electric sedan with autopilot',
      'pricePerDay': 2500,
      'available': true,
      'imageUrl': 'https://via.placeholder.com/300x200?text=Tesla+Model+3',
      'features': ['Autopilot', 'Electric', 'Long Range', 'Touchscreen']
    },
    {
      'name': 'BMW X5',
      'model': '2024',
      'category': 'SUV',
      'description': 'Premium SUV with all-wheel drive',
      'pricePerDay': 3500,
      'available': true,
      'imageUrl': 'https://via.placeholder.com/300x200?text=BMW+X5',
      'features': ['All-Wheel Drive', 'Leather Seats', 'Panoramic Roof', '7-Seater']
    },
    {
      'name': 'Honda Civic',
      'model': '2023',
      'category': 'Sedan',
      'description': 'Reliable and fuel-efficient sedan',
      'pricePerDay': 1500,
      'available': true,
      'imageUrl': 'https://via.placeholder.com/300x200?text=Honda+Civic',
      'features': ['Fuel Efficient', 'Backup Camera', 'Bluetooth', 'USB Port']
    },
    {
      'name': 'Toyota Fortuner',
      'model': '2024',
      'category': 'SUV',
      'description': 'Spacious 7-seater SUV perfect for family trips',
      'pricePerDay': 2800,
      'available': true,
      'imageUrl': 'https://via.placeholder.com/300x200?text=Toyota+Fortuner',
      'features': ['7-Seater', 'Automatic', 'Air Conditioning', 'Good Ground Clearance']
    },
    {
      'name': 'Mercedes-Benz E-Class',
      'model': '2024',
      'category': 'Sedan',
      'description': 'Luxury sedan with premium comfort and technology',
      'pricePerDay': 4000,
      'available': true,
      'imageUrl': 'https://via.placeholder.com/300x200?text=Mercedes+E-Class',
      'features': ['Luxury', 'Sunroof', 'Premium Audio', 'Leather Interior']
    },
  ];

  try {
    print('📝 Adding sample cars to Firestore...\n');
    int count = 0;
    for (var car in cars) {
      await firestore.collection('cars').add(car);
      count++;
      print('✅ Added #$count: ${car['name']}');
    }
    print('\n✅ SUCCESS! All $count cars added to Firestore!');
    print('🔄 Refresh your Flutter app now to see the cars.\n');
    exit(0);
  } catch (e) {
    print('\n❌ ERROR: $e\n');
    print('Troubleshooting:');
    print('1. Check your internet connection');
    print('2. Verify Firestore is created in Firebase Console');
    print('3. Make sure Firestore is in test mode (allows public access)');
    print('4. Check projectId and apiKey are correct\n');
    exit(1);
  }
}
