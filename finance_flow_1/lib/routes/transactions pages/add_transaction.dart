import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/models/transaction_model.dart';
import 'package:finance_flow_1/services/transaction_id_generator.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  AddTransactionPageState createState() => AddTransactionPageState();
}

class AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Income', 'Expense', 'Savings'];
  final UniqueStringGenerator _idGenerator = UniqueStringGenerator();
  final UserService _userService = UserService();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _addTransaction() async {
    if (_formKey.currentState!.validate()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      String transactionId = _idGenerator.generateUniqueString(8, 12);
      FinancialTransaction newTransaction = FinancialTransaction(
        transactionId: transactionId,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: _selectedDate!,
        description: _descriptionController.text,
      );

      await _userService.addTransaction(firebaseUser.uid, newTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction added successfully')),
      );
      Navigator.pop(context); // Go back after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(labelText: 'Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                        _dateController.text =
                            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconButton(
                      buttonColor: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.tertiary,
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.arrow_back,
                    ),
                    const SizedBox(width: 20),
                    CustomIconButton(
                      buttonColor: Theme.of(context).colorScheme.primary,
                      iconColor: Theme.of(context).colorScheme.tertiary,
                      onPressed: _addTransaction,
                      icon: Icons.download_outlined,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
