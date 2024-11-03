import 'package:finance_flow_1/models/budget_model.dart';
import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/models/user_model.dart';
import 'package:finance_flow_1/services/generate_card_number.dart';
import 'package:finance_flow_1/services/transaction_id_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Add User to RTDB
  Future<void> addUser(UserModel user) async {
    try {
      final updatedUser = UserModel(
        uid: user.uid,
        email: user.email,
        name: user.name,
        surname: user.surname,
        iDNumber: user.iDNumber,
        dob: user.dob,
        address: user.address,
        cardNumber: generateAccountNumber(),
        imageUrl: user.imageUrl,
      );
      await _dbRef.child('User/${updatedUser.uid}').set(updatedUser.toMap());
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Get Current User ID
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Get User Data
  Future<UserModel?> getUser(String uid) async {
    try {
      DatabaseEvent event = await _dbRef.child('User/$uid').once();
      if (event.snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        return UserModel.fromMap(data, uid);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  // Add a Financial Transaction
  Future<void> addTransaction(
      String userId, FinancialTransaction transaction) async {
    try {
      await _dbRef
          .child('Transactions/$userId/${transaction.transactionId}')
          .set(transaction.toMap());
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  // Delete a Financial Transaction
  Future<void> deleteTransaction(String userId, String transactionId) async {
    try {
      await _dbRef.child('Transactions/$userId/$transactionId').remove();
    } catch (e) {
      print('Error deleting transaction: $e');
    }
  }

  // Get Transaction by ID
  Future<FinancialTransaction?> getTransactionById(
      String userId, String transactionId) async {
    try {
      final snapshot =
          await _dbRef.child('Transactions/$userId/$transactionId').get();
      if (snapshot.exists) {
        return FinancialTransaction.fromMap(
            Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      print('Error fetching transaction: $e');
      return null;
    }
  }

  // Get All Transactions
  Future<List<FinancialTransaction>> getTransactions(String userId) async {
    try {
      final snapshot = await _dbRef.child('Transactions/$userId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.values.map((value) {
          return FinancialTransaction.fromMap(Map<String, dynamic>.from(value));
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  // Add a Budget
  Future<void> addBudget(String userId, BudgetModel budget) async {
    try {
      await _dbRef
          .child('Budgets/$userId/${budget.budgetId}')
          .set(budget.toMap());
    } catch (e) {
      print('Error adding budget: $e');
    }
  }

  // Listen for Budget Updates
  Stream<DatabaseEvent> listenToBudgetUpdates(String userId) {
    return _dbRef.child('Budgets/$userId/').onValue;
  }

  // Get Budget Data
  Future<BudgetModel?> getBudget(String userId) async {
    try {
      final snapshot = await _dbRef.child('Budgets/$userId').get();
      if (snapshot.exists) {
        return BudgetModel.fromMap(
            Map<String, dynamic>.from(snapshot.value as Map));
      }
      return null;
    } catch (e) {
      print('Error fetching budget: $e');
      return null;
    }
  }

  // Get All Budgets
  Future<List<BudgetModel>> getBudgets(String userId) async {
    try {
      final snapshot = await _dbRef.child('Budgets/$userId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.values.map((value) {
          return BudgetModel.fromMap(Map<String, dynamic>.from(value));
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching budgets: $e');
      return [];
    }
  }

  // Delete a Budget
  Future<void> deleteBudget(String? userId, String budgetId) async {
    try {
      await _dbRef.child('Budgets/$userId/$budgetId').remove();
    } catch (e) {
      print('Error deleting budget: $e');
    }
  }

  // Save Notification to RTDB
  Future<void> saveNotification(String userId, String message) async {
    try {
      UniqueStringGenerator uniqueStringGenerator = UniqueStringGenerator();
      final String notificationId =
          uniqueStringGenerator.generateUniqueString(5, 11);

      await _dbRef.child('Notifications/$userId/$notificationId').set({
        'userId': userId,
        'message': message,
        'date': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _dbRef.child('User/${user.uid}').set(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Get All Notifications for a User
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    try {
      final snapshot = await _dbRef.child('Notifications/$userId').get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.entries.map((entry) {
          return {'key': entry.key, ...Map<String, dynamic>.from(entry.value)};
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  Future<DateTime?> getLastNotificationTime(
      String userId, String notificationMessage) async {
    try {
      // Fetch all notifications for the user
      List<Map<String, dynamic>> notifications = await getNotifications(userId);

      // Filter notifications by message
      final filteredNotifications = notifications.where((notification) {
        return notification['message'] == notificationMessage;
      }).toList();

      // If there are filtered notifications, sort them by date and return the latest one
      if (filteredNotifications.isNotEmpty) {
        filteredNotifications.sort((a, b) {
          DateTime dateA = DateTime.parse(a['date']);
          DateTime dateB = DateTime.parse(b['date']);
          return dateB.compareTo(dateA); // Sort descending
        });

        // Return the date of the most recent notification
        return DateTime.parse(filteredNotifications.first['date']);
      }
    } catch (e) {
      print('Error fetching last notification time: $e');
    }
    return null; // Return null if no notifications found or on error
  }

  Future<bool> notificationExists(String userId, String message) async {
    try {
      // Reference to the user's notifications
      final notificationsRef =
          FirebaseDatabase.instance.ref('Notifications/$userId');

      // Get the snapshot from the reference
      final snapshot = await notificationsRef.get();

      // Check if the snapshot has data
      if (snapshot.exists) {
        // Ensure the value is a Map
        if (snapshot.value is Map) {
          Map<dynamic, dynamic> notifications =
              snapshot.value as Map<dynamic, dynamic>;

          // Loop through each notification to check if the message exists
          for (var notification in notifications.values) {
            if (notification['message'] == message) {
              return true; // Notification exists
            }
          }
        }
      }
    } catch (e) {
      print('Error checking notification existence: $e');
    }
    return false; // Notification does not exist
  }

  // Delete a Notification
  Future<void> deleteNotification(String userId, String notificationId) async {
    try {
      await _dbRef.child('notifications/$userId/$notificationId').remove();
    } catch (e) {
      print('Error deleting notification: $e');
    }
  }

  // Check and Delete Notifications Older Than 15 Days
  Future<void> deleteOldNotifications(String userId) async {
    try {
      List<Map<String, dynamic>> notifications = await getNotifications(userId);
      DateTime now = DateTime.now();

      for (var notification in notifications) {
        DateTime notificationDate = DateTime.parse(notification['date']);
        if (now.difference(notificationDate).inDays >= 15) {
          String notificationId = notification['key'];
          await deleteNotification(userId, notificationId);
        }
      }
    } catch (e) {
      print('Error deleting old notifications: $e');
    }
  }
}
