/// Booking model representing a car rental booking
class BookingModel {
  final String id;
  final String userId;
  final String carId;
  final String carName;
  final DateTime pickupDate;
  final DateTime returnDate;
  final double totalPrice;
  final String status; // pending, confirmed, completed, cancelled
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final String? notes;

  BookingModel({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.pickupDate,
    required this.returnDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.confirmedAt,
    this.notes,
  });

  /// Calculate number of days between pickup and return
  int get numberOfDays {
    return returnDate.difference(pickupDate).inDays;
  }

  /// Check if booking is upcoming
  bool get isUpcoming {
    return pickupDate.isAfter(DateTime.now()) && status != 'cancelled';
  }

  /// Check if booking is completed
  bool get isCompleted {
    return returnDate.isBefore(DateTime.now()) || status == 'completed';
  }

  /// Copy with method for updating booking data
  BookingModel copyWith({
    String? id,
    String? userId,
    String? carId,
    String? carName,
    DateTime? pickupDate,
    DateTime? returnDate,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
    DateTime? confirmedAt,
    String? notes,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      carName: carName ?? this.carName,
      pickupDate: pickupDate ?? this.pickupDate,
      returnDate: returnDate ?? this.returnDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      notes: notes ?? this.notes,
    );
  }

  /// Convert BookingModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'carId': carId,
      'carName': carName,
      'pickupDate': pickupDate,
      'returnDate': returnDate,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
      'confirmedAt': confirmedAt,
      'notes': notes,
    };
  }

  /// Create BookingModel from Firestore JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      carId: json['carId'] as String,
      carName: json['carName'] as String,
      pickupDate: (json['pickupDate'] as dynamic)?.toDate() ?? DateTime.now(),
      returnDate: (json['returnDate'] as dynamic)?.toDate() ?? DateTime.now(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: (json['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      confirmedAt: (json['confirmedAt'] as dynamic)?.toDate(),
      notes: json['notes'] as String?,
    );
  }
}
