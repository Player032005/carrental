import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carrental/config/firebase_options.dart';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  // Sample cars data
  final cars = [
    {
      'name': 'Tesla Model 3',
      'model': '2024',
      'category': 'Sedan',
      'description': 'Luxury electric sedan with autopilot',
      'pricePerDay': 2500,
      'available': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1560958089-b8a63dd8b50b?w=500',
      'features': ['Autopilot', 'Electric', 'Long Range', 'Touchscreen']
    },
    {
      'name': 'BMW X5',
      'model': '2024',
      'category': 'SUV',
      'description': 'Premium SUV with all-wheel drive',
      'pricePerDay': 3500,
      'available': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1606611013016-969c19f27081?w=500',
      'features': ['All-Wheel Drive', 'Leather Seats', 'Panoramic Roof', '7-Seater']
    },
    {
      'name': 'Honda Civic',
      'model': '2023',
      'category': 'Sedan',
      'description': 'Reliable and fuel-efficient sedan',
      'pricePerDay': 1500,
      'available': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1590362891990-f8023379867f?w=500',
      'features': ['Fuel Efficient', 'Backup Camera', 'Bluetooth', 'USB Port']
    },
    {
      'name': 'Toyota Fortuner',
      'model': '2024',
      'category': 'SUV',
      'description': 'Spacious 7-seater SUV perfect for family trips',
      'pricePerDay': 2800,
      'available': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1605559424843-9e4c3febfe75?w=500',
      'features': ['7-Seater', 'Automatic', 'Air Conditioning', 'Good Ground Clearance']
    },
    {
      'name': 'Mercedes-Benz E-Class',
      'model': '2024',
      'category': 'Sedan',
      'description': 'Luxury sedan with premium comfort and technology',
      'pricePerDay': 4000,
      'available': true,
      'imageUrl':
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=500',
      'features': ['Luxury', 'Sunroof', 'Premium Audio', 'Leather Interior']
    },
  ];

  try {
    print('Adding sample cars to Firestore...');
    for (var car in cars) {
      await firestore.collection('cars').add(car);
      print('✓ Added: ${car['name']}');
    }
    print('✓ All cars added successfully!');
    exit(0);
  } catch (e) {
    print('✗ Error adding cars: $e');
    exit(1);
  }
}
