/// Price calculation utilities
class PriceCalculator {
  /// Calculate total rental price
  /// [pricePerDay] - Price per day
  /// [numberOfDays] - Number of days to rent
  /// Returns total price
  static double calculateTotalPrice(double pricePerDay, int numberOfDays) {
    if (numberOfDays <= 0) return 0.0;
    return pricePerDay * numberOfDays;
  }

  /// Calculate number of days between two dates
  static int calculateNumberOfDays(DateTime startDate, DateTime endDate) {
    final difference = endDate.difference(startDate);
    return difference.inDays + 1; // Include both start and end dates
  }

  /// Apply discount to price
  /// [originalPrice] - Original price
  /// [discountPercent] - Discount percentage (0-100)
  /// Returns discounted price
  static double applyDiscount(double originalPrice, double discountPercent) {
    if (discountPercent < 0 || discountPercent > 100) return originalPrice;
    return originalPrice * (1 - (discountPercent / 100));
  }

  /// Calculate tax
  /// [basePrice] - Price before tax
  /// [taxPercent] - Tax percentage (e.g., 5 for 5%)
  /// Returns total price including tax
  static double calculateWithTax(double basePrice, double taxPercent) {
    return basePrice * (1 + (taxPercent / 100));
  }

  /// Format price as currency string
  /// [price] - Price amount
  /// Returns formatted price (e.g., "$1,234.56")
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Format price with currency and abbreviation
  /// Used for quick display (e.g., "$1.2k")
  static String formatPriceCompact(double price) {
    if (price >= 1000000) {
      return '\$${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '\$${(price / 1000).toStringAsFixed(1)}k';
    } else {
      return '\$${price.toStringAsFixed(2)}';
    }
  }

  /// Calculate average daily rate
  /// [totalPrice] - Total booking price
  /// [numberOfDays] - Number of days
  /// Returns average price per day
  static double calculateAverageDailyRate(double totalPrice, int numberOfDays) {
    if (numberOfDays <= 0) return 0.0;
    return totalPrice / numberOfDays;
  }

  /// Check if price is within range
  static bool isPriceInRange(double price, double minPrice, double maxPrice) {
    return price >= minPrice && price <= maxPrice;
  }

  /// Calculate price difference
  static double calculatePriceDifference(double newPrice, double oldPrice) {
    return newPrice - oldPrice;
  }

  /// Calculate percentage change in price
  static double calculatePriceChangePercent(double newPrice, double oldPrice) {
    if (oldPrice == 0) return 0.0;
    return ((newPrice - oldPrice) / oldPrice) * 100;
  }
}
