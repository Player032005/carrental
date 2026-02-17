/// Car model representing a rental car in the system
class CarModel {
  final String id;
  final String name;
  final String model;
  final int year;
  final String category; // Sedan, SUV, Luxury, Economic, Family
  final double pricePerDay;
  final double rating;
  final int reviewCount;
  final int seats;
  final String transmission; // Manual, Automatic
  final String fuelType; // Petrol, Diesel, Electric, Hybrid
  final bool airConditioning;
  final String description;
  final List<String> imageUrls; // Multiple images for carousel
  final bool isAvailable;
  final List<String> bookedDates; // Dates when car is booked
  final DateTime createdAt;
  final String? ownerEmail;

  CarModel({
    required this.id,
    required this.name,
    required this.model,
    required this.year,
    required this.category,
    required this.pricePerDay,
    required this.rating,
    this.reviewCount = 0,
    required this.seats,
    required this.transmission,
    required this.fuelType,
    required this.airConditioning,
    required this.description,
    required this.imageUrls,
    this.isAvailable = true,
    this.bookedDates = const [],
    required this.createdAt,
    this.ownerEmail,
  });

  /// Check if car is available on a specific date
  bool isAvailableOnDate(DateTime date) {
    String dateString = _formatDateForComparison(date);
    return !bookedDates.contains(dateString);
  }

  /// Check if car is available between two dates
  bool isAvailableBetweenDates(DateTime startDate, DateTime endDate) {
    for (var date = startDate;
        date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
        date = date.add(const Duration(days: 1))) {
      if (!isAvailableOnDate(date)) {
        return false;
      }
    }
    return true;
  }

  /// Format date as YYYY-MM-DD for comparison
  String _formatDateForComparison(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get car's full display name
  String get displayName => '$name ($model) - $year';

  /// Copy with method for updating car data
  CarModel copyWith({
    String? id,
    String? name,
    String? model,
    int? year,
    String? category,
    double? pricePerDay,
    double? rating,
    int? reviewCount,
    int? seats,
    String? transmission,
    String? fuelType,
    bool? airConditioning,
    String? description,
    List<String>? imageUrls,
    bool? isAvailable,
    List<String>? bookedDates,
    DateTime? createdAt,
    String? ownerEmail,
  }) {
    return CarModel(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      year: year ?? this.year,
      category: category ?? this.category,
      pricePerDay: pricePerDay ?? this.pricePerDay,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      seats: seats ?? this.seats,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      airConditioning: airConditioning ?? this.airConditioning,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      isAvailable: isAvailable ?? this.isAvailable,
      bookedDates: bookedDates ?? this.bookedDates,
      createdAt: createdAt ?? this.createdAt,
      ownerEmail: ownerEmail ?? this.ownerEmail,
    );
  }

  /// Convert CarModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model': model,
      'year': year,
      'category': category,
      'pricePerDay': pricePerDay,
      'rating': rating,
      'reviewCount': reviewCount,
      'seats': seats,
      'transmission': transmission,
      'fuelType': fuelType,
      'airConditioning': airConditioning,
      'description': description,
      'imageUrls': imageUrls,
      'isAvailable': isAvailable,
      'bookedDates': bookedDates,
      'createdAt': createdAt,
      'ownerEmail': ownerEmail,
    };
  }

  /// Create CarModel from Firestore JSON
  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'] as String,
      name: json['name'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      category: json['category'] as String,
      pricePerDay: (json['pricePerDay'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      seats: json['seats'] as int,
      transmission: json['transmission'] as String,
      fuelType: json['fuelType'] as String,
      airConditioning: json['airConditioning'] as bool,
      description: json['description'] as String,
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
      isAvailable: json['isAvailable'] as bool? ?? true,
      bookedDates: List<String>.from(json['bookedDates'] as List? ?? []),
      createdAt: (json['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      ownerEmail: json['ownerEmail'] as String?,
    );
  }
}
