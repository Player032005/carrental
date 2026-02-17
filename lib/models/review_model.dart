/// Review model for car ratings and comments
class ReviewModel {
  final String id;
  final String carId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String>? imageUrls;

  ReviewModel({
    required this.id,
    required this.carId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.imageUrls,
  });

  /// Copy with method for updating review data
  ReviewModel copyWith({
    String? id,
    String? carId,
    String? userId,
    String? userName,
    double? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? imageUrls,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }

  /// Convert ReviewModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'imageUrls': imageUrls,
    };
  }

  /// Create ReviewModel from Firestore JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      carId: json['carId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: (json['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      imageUrls: List<String>.from(json['imageUrls'] as List? ?? []),
    );
  }
}
