import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/models/budget_model.dart';

class BudgetOverviewPage extends StatefulWidget {
  const BudgetOverviewPage({super.key});

  @override
  BudgetOverviewPageState createState() => BudgetOverviewPageState();
}

class BudgetOverviewPageState extends State<BudgetOverviewPage> {
  List<BudgetModel> budgets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _listenForBudgetUpdates(); // Start listening for budget updates
  }

  // Listen for budget updates from Firebase using the UserService method
  void _listenForBudgetUpdates() {
    String? userId = UserService().getCurrentUserId();

    if (userId != null) {
      UserService().listenToBudgetUpdates(userId).listen((event) {
        if (event.snapshot.exists && event.snapshot.value != null) {
          final data = event.snapshot.value;

          if (data is Map<dynamic, dynamic>) {
            List<BudgetModel> updatedBudgets = [];

            data.forEach((key, value) {
              if (value != null && value is Map) {
                updatedBudgets.add(BudgetModel.fromMap(
                  Map<String, dynamic>.from(value),
                ));
              }
            });

            setState(() {
              budgets = updatedBudgets;
              isLoading = false;
            });
          } else {
            setState(() {
              budgets = [];
              isLoading = false;
            });
          }
        } else {
          setState(() {
            budgets = [];
            isLoading = false;
          });
        }
      }, onError: (error) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  // Function to delete a budget item
  Future<void> _deleteBudget(String? userId, String budgetId) async {
    await UserService().deleteBudget(userId, budgetId);
  }

  // Show delete confirmation dialog
  Future<void> _showDeleteConfirmationDialog(
      String? userId, String budgetId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Budget'),
          content: const Text('Are you sure you want to delete this budget?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary)),
            ),
            TextButton(
              onPressed: () async {
                await _deleteBudget(userId, budgetId);
                Navigator.of(context).pop();
              },
              child: Text('Confirm',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Budget Overview',
      floatingButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          size: 40,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        onPressed: () =>
            Navigator.pushNamed(context, RouteManager.addBudgetPage),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : budgets.isEmpty
              ? _buildNoItemsView()
              : _buildBudgetOverview(),
    );
  }

  // Widget to display when there are no budget items
  Widget _buildNoItemsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            'No Budget Items Found',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 10),
          Text(
            'Add budget categories and items to get started.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget to display the budget categories and items
  Widget _buildBudgetOverview() {
    String? userId = UserService().getCurrentUserId();

    return ListView.builder(
      itemCount: budgets.length,
      itemBuilder: (context, index) {
        BudgetModel budget = budgets[index];
        return ExpansionTile(
          title: Text(
            'Budget ${index + 1}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: budget.categories.entries.map((entry) {
            String category = entry.key;
            List<BudgetItem> items = entry.value;

            // Calculate total estimated cost for this category
            double totalEstimatedCost =
                items.fold(0.0, (sum, item) => sum + item.estimatedCost);

            return ExpansionTile(
              title: Text(
                category,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              children: [
                ...items.map((item) {
                  return ListTile(
                    title: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Estimated: R${item.estimatedCost.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Total Estimated Cost: R${totalEstimatedCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 80),
                      CustomIconButton(
                        icon: Icons.delete,
                        iconColor: Theme.of(context).colorScheme.tertiary,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          if (userId != null) {
                            _showDeleteConfirmationDialog(
                                userId, budget.budgetId);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
