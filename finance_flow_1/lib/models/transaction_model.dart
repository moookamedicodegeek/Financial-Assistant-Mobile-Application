class FinancialTransaction {
  final String transactionId;
  final String description;
  final String category;
  double amount;
  final DateTime date;

  FinancialTransaction({
    required this.transactionId,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  /// Create a FinancialTransaction from a map (for Realtime Database retrieval)
  factory FinancialTransaction.fromMap(Map<String, dynamic> map) {
    return FinancialTransaction(
      transactionId: map['transactionId'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] as num).toDouble(), // Convert to double if needed
      date: DateTime.parse(map['date'] ??
          DateTime.now().toIso8601String()), // Handle date parsing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'category': category,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(), // Store date as ISO8601 string
    };
  }

  /// Adds a copyWith method to allow copying with modifications
  FinancialTransaction copyWith({
    String? transactionId,
    String? description,
    String? category,
    double? amount,
    DateTime? date,
  }) {
    return FinancialTransaction(
      transactionId: transactionId ?? this.transactionId,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, double> calculateTotalByCategory(
      List<FinancialTransaction> transactions) {
    Map<String, double> categoryTotals = {};

    for (var transaction in transactions) {
      if (categoryTotals.containsKey(transaction.category)) {
        categoryTotals[transaction.category] =
            categoryTotals[transaction.category]! + transaction.amount;
      } else {
        categoryTotals[transaction.category] = transaction.amount;
      }
    }

    return categoryTotals;
  }

  static List<FinancialTransaction> filterByCurrentMonth(
      List<FinancialTransaction> transactions) {
    DateTime now = DateTime.now();
    return transactions.where((transaction) {
      return transaction.date.year == now.year &&
          transaction.date.month == now.month;
    }).toList();
  }
}
