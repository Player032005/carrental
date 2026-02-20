import 'dart:convert';
import 'dart:io';

/// Instructions for manually adding cars to Firestore via Firebase Console
void main() {
  print('''
╔══════════════════════════════════════════════════════════════╗
║  MANUAL FIRESTORE CAR INSERTION - Firebase Console Method  ║
╚══════════════════════════════════════════════════════════════╝

Here are 4 cars to add to your 'cars' collection:

CAR 1 - Toyota Fortuner (SUV):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
id: car_002
name: Toyota Fortuner
model: Fortuner
year: 2023 (number)
category: SUV
pricePerDay: 4500 (number)
rating: 4.8 (number)
reviewCount: 45 (number)
seats: 7 (number)
transmission: Automatic
fuelType: Diesel
airConditioning: true (boolean)
description: Spacious SUV perfect for family trips
imageUrls: [] (array)
available: true (boolean)

CAR 2 - Hyundai Creta (SUV):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
id: car_003
name: Hyundai Creta
model: Creta
year: 2024 (number)
category: SUV
pricePerDay: 3800 (number)
rating: 4.6 (number)
reviewCount: 32 (number)
seats: 5 (number)
transmission: Automatic
fuelType: Petrol
airConditioning: true (boolean)
description: Modern compact SUV with comfort
imageUrls: [] (array)
available: true (boolean)

CAR 3 - Honda City (Sedan):
━━━━━━━━━━━━━━━━━━━━━━━━━━━
id: car_004
name: Honda City
model: City
year: 2023 (number)
category: Sedan
pricePerDay: 2500 (number)
rating: 4.4 (number)
reviewCount: 28 (number)
seats: 5 (number)
transmission: Manual
fuelType: Petrol
airConditioning: true (boolean)
description: Affordable and reliable sedan
imageUrls: [] (array)
available: true (boolean)

CAR 4 - BMW X5 (Luxury):
━━━━━━━━━━━━━━━━━━━━━━━━━
id: car_005
name: BMW X5
model: X5
year: 2024 (number)
category: Luxury
pricePerDay: 8500 (number)
rating: 4.9 (number)
reviewCount: 18 (number)
seats: 5 (number)
transmission: Automatic
fuelType: Petrol
airConditioning: true (boolean)
description: Premium luxury SUV with all features
imageUrls: [] (array)
available: true (boolean)

STEPS TO ADD CARS:
1. Open Firebase Console → Your Project → Firestore Database
2. Click "cars" collection
3. Click "+ Add Document"
4. For Document ID, enter: car_002
5. Add each field from the data above
6. Click "Save"
7. Repeat for car_003, car_004, car_005

ALTERNATIVE - Copy/Paste JSON:
You can also add via Firestore REST API with curl:

curl -X POST \\
  "https://firestore.googleapis.com/v1/projects/YOUR_PROJECT_ID/databases/(default)/documents/cars?documentId=car_002" \\
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \\
  -H "Content-Type: application/json" \\
  -d '{
    "fields": {
      "id": {"stringValue": "car_002"},
      "name": {"stringValue": "Toyota Fortuner"},
      "model": {"stringValue": "Fortuner"},
      "year": {"integerValue": "2023"},
      "category": {"stringValue": "SUV"},
      "pricePerDay": {"doubleValue": 4500.0},
      "rating": {"doubleValue": 4.8},
      "reviewCount": {"integerValue": "45"},
      "seats": {"integerValue": "7"},
      "transmission": {"stringValue": "Automatic"},
      "fuelType": {"stringValue": "Diesel"},
      "airConditioning": {"booleanValue": true},
      "description": {"stringValue": "Spacious SUV perfect for family trips"},
      "imageUrls": {"arrayValue": {}},
      "available": {"booleanValue": true}
    }
  }'

═══════════════════════════════════════════════════════════════
After adding these cars, restart your Flutter app to see them!
═══════════════════════════════════════════════════════════════
  ''');
}
