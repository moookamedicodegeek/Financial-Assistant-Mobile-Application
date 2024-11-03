import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/routes/transactions%20pages/transaction_details.dart';
import 'package:finance_flow_1/services/monthly_totals.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final UserService _userService = UserService();
  List<FinancialTransaction> _transactions = [];
  MonthlyTotals? monthlyTotals;
  bool _isLoading = true;
  String? _error;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
    _startAutoSlider();
    _fetchMonthlyTotals();
  }

  @override
  void dispose() {
    // Perform any cleanup or stop timers, etc. when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchMonthlyTotals() async {
    monthlyTotals = await MonthlyTotals.calculateAsync(context, _userService);
    setState(() {}); // Rebuild the widget to reflect the updated totals
  }

  // Get the current month transactions
  List<FinancialTransaction> _filterCurrentMonthTransactions(
      List<FinancialTransaction> transactions) {
    DateTime now = DateTime.now();
    return transactions
        .where((transaction) =>
            transaction.date.month == now.month &&
            transaction.date.year == now.year)
        .toList();
  }

  Future<void> _fetchTransactions() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        List<FinancialTransaction> transactions =
            await _userService.getTransactions(firebaseUser.uid);
        if (mounted) {
          setState(() {
            _transactions = _filterCurrentMonthTransactions(transactions);
            _isLoading = false; // Update loading state
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _error = 'Error fetching transactions: $e';
            _isLoading = false; // Update loading state
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _error = 'Error:\nUser not logged in';
          _isLoading = false; // Update loading state
        });
      }
    }
  }

  void _startAutoSlider() {
    // Change the current index every 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _transactions.isNotEmpty) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _transactions.length;
        });
        _startAutoSlider(); // Call again to continue the loop
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Dashboard',
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Text(
                        'Transactions',
                        style: TextStyle(
                          fontSize: 26,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _transactions.isEmpty
                        ? const Center(
                            child: Text(
                              'No transactions found for this month.',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Material(
                            elevation: 5,
                            shadowColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.5),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  width: 1,
                                ),
                              ),
                              leading: const Icon(
                                Icons.swap_horiz_outlined,
                                size: 40,
                              ),
                              title: Text(
                                'Amount: R${_transactions[_currentIndex].amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'Category: ${_transactions[_currentIndex].category}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Text(
                                '${_transactions[_currentIndex].date.day}/${_transactions[_currentIndex].date.month}',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransactionDetailsPage(
                                      transaction: _transactions[_currentIndex],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 26,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1,
                          ),
                        ),
                        leading: const Icon(
                          Icons.chat_outlined,
                          size: 40,
                        ),
                        title: const Text(
                          'Get Financial Advice',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Go to chat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteManager.chat);
                        },
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        'Budget',
                        style: TextStyle(
                          fontSize: 26,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1,
                          ),
                        ),
                        leading: const Icon(
                          Icons.wallet_outlined,
                          size: 40,
                        ),
                        title: const Text(
                          'View Your Budget',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Go to budget',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.viewBudget);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        'Analysis',
                        style: TextStyle(
                          fontSize: 26,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1,
                          ),
                        ),
                        leading: const Icon(
                          Icons.bar_chart,
                          size: 40,
                        ),
                        title: const Text(
                          'View Your Totals',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Go to Monthly Totals',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.monthlyTotals);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 26,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Material(
                      elevation: 5,
                      shadowColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1,
                          ),
                        ),
                        leading: const Icon(
                          Icons.notification_important_outlined,
                          size: 40,
                        ),
                        title: const Text(
                          'View Your Notifications',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'Go to Notifications',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(RouteManager.notifications);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
