import 'package:finance_flow_1/widgets/custom_button.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:finance_flow_1/models/budget_model.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class AddBudgetPage extends StatefulWidget {
  const AddBudgetPage({super.key});

  @override
  AddBudgetPageState createState() => AddBudgetPageState();
}

class AddBudgetPageState extends State<AddBudgetPage> {
  final _formKey = GlobalKey<FormState>();
  final _monthlyIncomeController = TextEditingController();
  final _savingsGoalController = TextEditingController();
  final _budgetItemNameController = TextEditingController();
  final _budgetItemCostController = TextEditingController();

  String? _selectedCategory;
  final List<String> _categoryOptions = [
    'Housing',
    'Transportation',
    'Food',
    'Utilities',
    'Entertainment',
    'Healthcare',
    'Education',
    'Miscellaneous'
  ]; // Predefined categories

  final Map<String, List<BudgetItem>> categories =
      {}; // Category -> List of Budget Items

  final UserService _userService = UserService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _monthlyIncomeController.dispose();
    _savingsGoalController.dispose();
    _budgetItemNameController.dispose();
    _budgetItemCostController.dispose();
    super.dispose();
  }

  // Generate a unique item ID
  String _generateItemId() {
    return Random().nextInt(100000).toString();
  }

  // Add a budget item under a specific category
  void _addBudgetItem() {
    final String? categoryName = _selectedCategory;
    final String itemName = _budgetItemNameController.text;
    final double estimatedCost =
        double.tryParse(_budgetItemCostController.text) ?? 0.0;

    if (categoryName != null && itemName.isNotEmpty && estimatedCost > 0) {
      setState(() {
        if (!categories.containsKey(categoryName)) {
          categories[categoryName] = [];
        }
        categories[categoryName]!.add(
          BudgetItem(
            itemId: _generateItemId(),
            name: itemName,
            estimatedCost: estimatedCost,
          ),
        );
      });

      _budgetItemNameController.clear();
      _budgetItemCostController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid item details')),
      );
    }
  }

  // Delete a budget item
  void _deleteBudgetItem(String category, String itemId) {
    setState(() {
      categories[category]?.removeWhere((item) => item.itemId == itemId);
      if (categories[category]?.isEmpty ?? false) {
        categories.remove(category);
      }
    });
  }

  // Save the entire budget
  void _saveBudget() async {
    if (_formKey.currentState!.validate()) {
      final double monthlyIncome =
          double.tryParse(_monthlyIncomeController.text) ?? 0.0;
      final double savingsGoal =
          double.tryParse(_savingsGoalController.text) ?? 0.0;
      double totalExpenses = 0.0;

      // Calculate total expenses from all categories
      categories.forEach((categoryName, items) {
        for (var item in items) {
          totalExpenses += item.estimatedCost;
        }
      });

      final double remainingBalance =
          monthlyIncome - totalExpenses - savingsGoal;

      // Ensure the user is authenticated
      if (_currentUser != null) {
        String userId = _currentUser!.uid;

        // Create the BudgetModel
        final budget = BudgetModel(
          budgetId: DateTime.now().millisecondsSinceEpoch.toString(),
          monthlyIncome: monthlyIncome,
          savingsGoal: savingsGoal,
          totalExpenses: totalExpenses,
          remainingBalance: remainingBalance,
          categories: categories,
        );

        try {
          // Save the budget to the database
          await _userService.addBudget(userId, budget);

          // Reset form after saving
          _formKey.currentState!.reset();
          setState(() {
            categories.clear();
            _selectedCategory = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Budget saved successfully!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save budget')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to save a budget')),
        );
      }
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Budget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _monthlyIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Income',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _savingsGoalController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Savings Goal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your savings goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Add Budget Categories and Items:'),
              const SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categoryOptions.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _budgetItemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _budgetItemCostController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              CustomButton(
                color: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.tertiary,
                onPressed: _addBudgetItem,
                text: 'Add Item to Category',
              ),
              const SizedBox(height: 12.0),
              if (categories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Categories:'),
                    ...categories.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          ...entry.value.map((item) {
                            return ListTile(
                              title: Text(item.name),
                              subtitle: Text(
                                  'Estimated Cost: R${item.estimatedCost.toStringAsFixed(2)}'),
                              trailing: CustomIconButton(
                                icon: Icons.delete,
                                iconColor:
                                    Theme.of(context).colorScheme.tertiary,
                                buttonColor:
                                    Theme.of(context).colorScheme.primary,
                                iconSize: 30,
                                onPressed: () =>
                                    _deleteBudgetItem(entry.key, item.itemId),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              const SizedBox(height: 12.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 20),
                  CustomIconButton(
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: _saveBudget,
                    icon: Icons.download_outlined,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
