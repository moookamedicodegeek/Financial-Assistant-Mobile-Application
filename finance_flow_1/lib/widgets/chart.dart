import 'package:finance_flow_1/services/monthly_totals.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  ChartPageState createState() => ChartPageState();
}

class ChartPageState extends State<ChartPage> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _monthlyTotals != null
              ? _buildBarChart()
              : const Center(child: Text('No data available')),
    );
  }

  Widget _buildBarChart() {
    double maxValue = _monthlyTotals!.totalIncome > _monthlyTotals!.totalSpent
        ? _monthlyTotals!.totalIncome
        : _monthlyTotals!.totalSpent;

    if (maxValue == 0) maxValue = 1; // To avoid division by zero

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Analysis',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBar('Income', incomeAmount(), maxValue, Colors.orange),
                  const SizedBox(width: 20),
                  _buildBar('Spent', spentAmount(), maxValue, Colors.red),
                  const SizedBox(width: 20),
                  _buildBar(
                      'Remaining', remainingAmount(), maxValue, Colors.blue),
                  const SizedBox(width: 20),
                  _buildBar('Saved', savedAmount(), maxValue, Colors.green),
                ],
              ),
            ),
            const SizedBox(height: 30),
            CustomIconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icons.arrow_back_sharp,
              iconColor: Theme.of(context).colorScheme.tertiary,
              buttonColor: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(String label, double value, double maxValue, Color color) {
    double barHeight = (value / maxValue) * 200;
    double barWidth = 60;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            alignment: Alignment.center,
            height: barHeight.abs(), // Use absolute value for positive height
            width: barWidth, // Fixed width for the bar
            color: color,
          ),
        ),
        const SizedBox(width: 20),
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: 100,
            child: Text(
              '$label: R${value.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
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
