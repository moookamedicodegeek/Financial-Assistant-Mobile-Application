import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/services/monthly_totals.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/widgets/custom_button.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';

class MonthlyTotalsPage extends StatefulWidget {
  const MonthlyTotalsPage({super.key});

  @override
  MonthlyTotalsPageState createState() => MonthlyTotalsPageState();
}

class MonthlyTotalsPageState extends State<MonthlyTotalsPage> {
  MonthlyTotals? _monthlyTotals;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyTotals();
  }

  Future<void> _fetchMonthlyTotals() async {
    final UserService userService = UserService();
    String? userId = userService.getCurrentUserId();

    if (userId != null) {
      MonthlyTotals totals =
          await MonthlyTotals.calculateAsync(context, userService);

      setState(() {
        _monthlyTotals = totals;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _monthlyTotals != null
              ? _buildTotalsView()
              : const Center(child: Text('No data available')),
    );
  }

  Widget _buildTotalsView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Center(
            child: Text(
              'Monthly Financial Overview',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'Total Income: R${incomeAmount().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Total Spent: R${spentAmount().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Remaining Amount: R${remainingAmount().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Saved Amount: R${savedAmount().toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconButton(
                buttonColor: Theme.of(context).colorScheme.primary,
                iconColor: Theme.of(context).colorScheme.tertiary,
                onPressed: () => Navigator.pop(context),
                icon: Icons.arrow_back,
              ),
              const SizedBox(width: 20),
              CustomButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.tertiary,
                text: 'Chart',
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteManager.chartPage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double remainingAmount() {
    return _monthlyTotals!.remainingIncome < 0
        ? 0.00
        : _monthlyTotals!.remainingIncome;
  }

  double savedAmount() {
    return _monthlyTotals!.savedAmount < 0 ? 0.00 : _monthlyTotals!.savedAmount;
  }

  double spentAmount() {
    return _monthlyTotals!.totalSpent < 0 ? 0.00 : _monthlyTotals!.totalSpent;
  }

  double incomeAmount() {
    return _monthlyTotals!.totalIncome < 0 ? 0.00 : _monthlyTotals!.totalIncome;
  }
}
