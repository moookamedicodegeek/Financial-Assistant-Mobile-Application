class BudgetModel {
  String budgetId;
  double monthlyIncome;
  double savingsGoal;
  double totalExpenses;
  double remainingBalance;
  Map<String, List<BudgetItem>> categories;

  BudgetModel({
    required this.budgetId,
    required this.monthlyIncome,
    required this.savingsGoal,
    required this.totalExpenses,
    required this.remainingBalance,
    required this.categories,
  });

  factory BudgetModel.fromMap(Map<dynamic, dynamic> data) {
    return BudgetModel(
      budgetId: data['budgetId'] as String? ?? '',
      monthlyIncome: (data['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      savingsGoal: (data['savingsGoal'] as num?)?.toDouble() ?? 0.0,
      totalExpenses: (data['totalExpenses'] as num?)?.toDouble() ?? 0.0,
      remainingBalance: (data['remainingBalance'] as num?)?.toDouble() ?? 0.0,
      categories: (data['categories'] as Map<dynamic, dynamic>).map(
        (key, value) {
          // Safely casting each category value to List<BudgetItem>
          return MapEntry(
            key as String,
            (value as List<dynamic>)
                .map(
                    (item) => BudgetItem.fromMap(item as Map<dynamic, dynamic>))
                .toList(),
          );
        },
      ),
    );
  }

  // Convert BudgetModel into a Map for saving in Firebase
  Map<String, dynamic> toMap() {
    return {
      'budgetId': budgetId,
      'monthlyIncome': monthlyIncome,
      'savingsGoal': savingsGoal,
      'totalExpenses': totalExpenses,
      'remainingBalance': remainingBalance,
      'categories': categories.map((key, value) => MapEntry(
            key,
            value.map((item) => item.toMap()).toList(),
          )),
    };
  }
}

class BudgetItem {
  String itemId; // New field for tracking each item
  String name;
  double estimatedCost;

  BudgetItem({
    required this.itemId, // Ensure itemId is required
    required this.name,
    required this.estimatedCost,
  });

  factory BudgetItem.fromMap(Map<dynamic, dynamic> data) {
    return BudgetItem(
      itemId: data['itemId'] as String? ?? '', // Initialize itemId
      name: data['name'] as String? ?? '',
      estimatedCost: (data['estimatedCost'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId, // Include itemId in the map
      'name': name,
      'estimatedCost': estimatedCost,
    };
  }
}
