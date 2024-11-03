import 'package:finance_flow_1/routes/transactions%20pages/edit_transaction.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:finance_flow_1/services/user_service.dart';

class TransactionDetailsPage extends StatelessWidget {
  final FinancialTransaction transaction;
  final UserService _userService = UserService();

  TransactionDetailsPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Transaction Details',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                elevation: 5,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1,
                      ),
                    ),
                    leading: const Icon(
                      Icons.money,
                      size: 40,
                    ),
                    title: Text(
                      transaction.amount.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: const Text(
                      'Amount',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ),
              const SizedBox(height: 38),
              Material(
                elevation: 5,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1,
                      ),
                    ),
                    leading: _getCategoryIcon(transaction.category),
                    title: Text(
                      transaction.category,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ),
              const SizedBox(height: 38),
              Material(
                elevation: 5,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1,
                      ),
                    ),
                    leading: const Icon(
                      Icons.date_range,
                      size: 40,
                    ),
                    title: Text(
                      '${transaction.date.day}-${transaction.date.month}-${transaction.date.year}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ),
              const SizedBox(height: 38),
              Material(
                elevation: 5,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.5),
                child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.tertiary,
                        width: 1,
                      ),
                    ),
                    leading: const Icon(
                      Icons.description,
                      size: 40,
                    ),
                    title: Text(
                      transaction.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    )),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  CustomIconButton(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    icon: Icons.edit,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditTransactionPage(transaction: transaction),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  CustomIconButton(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    icon: Icons.delete,
                    iconSize: 32,
                    onPressed: () => _showDeleteConfirmationDialog(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getCategoryIcon(String category) {
    switch (category) {
      case 'Income':
        return const Icon(Icons.monetization_on, size: 40);
      case 'Expense':
        return const Icon(Icons.money_off, size: 40);
      case 'Savings':
        return const Icon(Icons.savings, size: 40);
      default:
        return const Icon(Icons.attach_money, size: 40);
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Transaction'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without action
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              onPressed: () async {
                // Delete the transaction
                String? currentUserId = _userService.getCurrentUserId();
                if (currentUserId != null) {
                  await _userService.deleteTransaction(
                      currentUserId, transaction.transactionId);
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back to the previous page
                } else {
                  // Handle the case where the user is not logged in
                  Navigator.of(context).pop(); // Close dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error: No user is logged in.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
