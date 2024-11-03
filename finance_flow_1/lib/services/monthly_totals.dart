import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';

class MonthlyTotals {
  final double totalIncome;
  final double totalSpent;
  final double remainingIncome;
  late final double savedAmount;

  MonthlyTotals({
    required this.totalIncome,
    required this.totalSpent,
    required this.remainingIncome,
    required this.savedAmount,
  });

  // Function to calculate remaining income
  Future<double> calculateTotalRemaining() async {
    final UserService userService = UserService();
    String? userId = userService.getCurrentUserId();

    if (userId == null) return 0.0;

    try {
      double totalIncome = await calculateTotalIncome();
      double totalExpenditure = await calculateTotalExpenditure();
      double savedAmount = await calculateTotalSavings(); // Fetch from DB

      double remainingIncome = totalIncome - totalExpenditure - savedAmount;
      return remainingIncome;
    } catch (e) {
      print('Error calculating total remaining income: $e');
      return 0.0;
    }
  }

  // Calculate total savings for the current month
  Future<double> calculateTotalSavings() async {
    final UserService userService = UserService();
    String? userId = userService.getCurrentUserId();

    if (userId == null) return 0.0;

    double savedAmount = 0;

    try {
      List<FinancialTransaction> transactions =
          await userService.getTransactions(userId);
      DateTime now = DateTime.now();

      for (var transaction in transactions) {
        if (transaction.category.toLowerCase() == 'savings' &&
            transaction.date.month == now.month &&
            transaction.date.year == now.year) {
          savedAmount += transaction.amount;
        }
      }
    } catch (e) {
      print('Error calculating total savings: $e');
    }

    return savedAmount;
  }

  // Calculate total expenditure for the current month
  Future<double> calculateTotalExpenditure() async {
    final UserService userService = UserService();
    String? userId = userService.getCurrentUserId();

    if (userId == null) return 0.0;

    double totalExpenditure = 0;

    try {
      List<FinancialTransaction> transactions =
          await userService.getTransactions(userId);
      DateTime now = DateTime.now();

      final currentMonthExpenditureTransactions = transactions.where((t) =>
          t.category.toLowerCase() != 'savings' &&
          t.category.toLowerCase() != 'income' &&
          t.date.month == now.month &&
          t.date.year == now.year);

      totalExpenditure = currentMonthExpenditureTransactions.fold(
          0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      print('Error calculating total expenditure: $e');
    }

    return totalExpenditure;
  }

  // Calculate total income for the current month
  Future<double> calculateTotalIncome() async {
    final UserService userService = UserService();
    String? userId = userService.getCurrentUserId();

    if (userId == null) return 0.0;

    double totalIncome = 0.0;

    try {
      List<FinancialTransaction> transactions =
          await userService.getTransactions(userId);
      DateTime now = DateTime.now();

      final incomeTransactions = transactions.where((t) =>
          t.category.toLowerCase() == 'income' &&
          t.date.month == now.month &&
          t.date.year == now.year);

      totalIncome = incomeTransactions.fold(0.0, (sum, t) => sum + t.amount);
    } catch (e) {
      print('Error calculating total income: $e');
    }

    return totalIncome;
  }

  // Calculate totals for the current month and show notifications
  static Future<MonthlyTotals> calculateAsync(
      BuildContext context, UserService userService) async {
    String? userId = userService.getCurrentUserId();

    if (userId == null) {
      return MonthlyTotals(
        totalIncome: 0.0,
        totalSpent: 0.0,
        remainingIncome: 0.0,
        savedAmount: 0.0,
      );
    }

    try {
      List<FinancialTransaction> transactions =
          await userService.getTransactions(userId);
      DateTime now = DateTime.now();
      final currentMonthTransactions = transactions
          .where((t) => t.date.month == now.month && t.date.year == now.year)
          .toList();

      double totalIncome = 0.0;
      double totalSpent = 0.0;

      for (var transaction in currentMonthTransactions) {
        String categoryLower = transaction.category.toLowerCase();
        if (categoryLower == 'income') {
          totalIncome += transaction.amount;
        } else if (categoryLower != 'savings') {
          totalSpent += transaction.amount;
        }
      }

      MonthlyTotals monthlyTotals = MonthlyTotals(
        totalIncome: totalIncome,
        totalSpent: totalSpent,
        remainingIncome: 0.0,
        savedAmount: 0.0,
      );

      double savedAmount = await monthlyTotals.calculateTotalSavings();
      double remainingIncome = totalIncome - totalSpent - savedAmount;

      // New notification logic
      if (savedAmount > 0) {
        String notificationMessage;
        if (savedAmount >= (totalIncome * 0.15)) {
          notificationMessage = 'Great job! You met the 15% savings goal.';
        } else {
          notificationMessage =
              'Keep going! You’re on your way to hitting your savings goal.';
        }

        DateTime? lastNotificationTime = await userService
            .getLastNotificationTime(userId, notificationMessage);
        if (lastNotificationTime == null ||
            now.difference(lastNotificationTime).inDays >= 3) {
          showSimpleNotification(
            Text(notificationMessage),
            background: Colors.greenAccent,
          );
          await userService.saveNotification(userId,
              notificationMessage); // Save notification with current time
        }
      }

      if (totalSpent > 0) {
        String notificationMessage;
        if (totalSpent >= 0.65 * totalIncome) {
          notificationMessage = 'Warning: You have spent 65% of your income!';
        } else {
          notificationMessage = 'Good job managing your expenses so far!';
        }

        DateTime? lastNotificationTime = await userService
            .getLastNotificationTime(userId, notificationMessage);
        if (lastNotificationTime == null ||
            now.difference(lastNotificationTime).inDays >= 3) {
          showSimpleNotification(
            Text(notificationMessage),
            background: Colors.redAccent,
          );
          await userService.saveNotification(userId,
              notificationMessage); // Save notification with current time
        }
      }

      if (transactions.isEmpty) {
        String notificationMessage =
            'No transactions logged this month. Start now!';
        DateTime? lastNotificationTime = await userService
            .getLastNotificationTime(userId, notificationMessage);
        if (lastNotificationTime == null ||
            now.difference(lastNotificationTime).inDays >= 3) {
          showSimpleNotification(
            Text(notificationMessage),
            background: Colors.orangeAccent,
          );
          await userService.saveNotification(userId,
              notificationMessage); // Save notification with current time
        }
      } else if (transactions.length < 5) {
        String notificationMessage =
            'You’ve logged only a few transactions. Keep it up!';
        DateTime? lastNotificationTime = await userService
            .getLastNotificationTime(userId, notificationMessage);
        if (lastNotificationTime == null ||
            now.difference(lastNotificationTime).inDays >= 3) {
          showSimpleNotification(
            Text(notificationMessage),
            background: Colors.purpleAccent,
          );
          await userService.saveNotification(userId,
              notificationMessage); // Save notification with current time
        }
      }

      return MonthlyTotals(
        totalIncome: totalIncome,
        totalSpent: totalSpent,
        remainingIncome: remainingIncome,
        savedAmount: savedAmount,
      );
    } catch (e) {
      print('Error calculating monthly totals: $e');
      return MonthlyTotals(
        totalIncome: 0.0,
        totalSpent: 0.0,
        remainingIncome: 0.0,
        savedAmount: 0.0,
      );
    }
  }
}
