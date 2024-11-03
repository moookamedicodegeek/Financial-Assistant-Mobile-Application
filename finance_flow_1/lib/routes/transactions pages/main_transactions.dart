import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/routes/transactions%20pages/transaction_details.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends State<TransactionsPage> {
  final UserService _userService = UserService();
  String? _userId;
  late Future<List<FinancialTransaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _getUserIdAndLoadTransactions();
  }

  Future<void> _getUserIdAndLoadTransactions() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _transactionsFuture = _userService.getTransactions(_userId!);
      });
    } else {
      // Handle the case when the user is not logged in (redirect or show error)
    }
  }

  Future<void> _refreshTransactions() async {
    if (_userId != null) {
      setState(() {
        _transactionsFuture = _userService.getTransactions(_userId!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Transactions',
      floatingButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          size: 40,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        onPressed: () async {
          await Navigator.pushNamed(context, RouteManager.addTransactionPage);
          _refreshTransactions();
        },
      ),
      body: FutureBuilder<List<FinancialTransaction>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading transactions.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No transactions found.',
                  style: TextStyle(fontSize: 20)),
            );
          }

          List<FinancialTransaction> transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                child: Material(
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
                    leading: Icon(
                      Icons.swap_horiz_outlined,
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 35,
                    ),
                    title: Text(
                      'R${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      transaction.category,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ), // Transaction category
                    trailing: Text(
                      '${transaction.date.day}/${transaction.date.month}', // Date in day-month format
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailsPage(
                            transaction: transaction,
                          ),
                        ),
                      );
                      _refreshTransactions(); // Refresh after returning from the details page
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
