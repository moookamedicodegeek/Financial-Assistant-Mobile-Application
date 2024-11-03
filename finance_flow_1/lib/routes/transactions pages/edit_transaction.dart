import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/models/transaction_model.dart';

class EditTransactionPage extends StatefulWidget {
  final FinancialTransaction transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String? _selectedCategory;
  final List<String> _categories = ['Income', 'Expense', 'Savings'];
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.transaction.amount.toString();
    _descriptionController.text = widget.transaction.description;
    _selectedCategory = widget.transaction.category;
    _selectedDate = widget.transaction.date;
    _dateController.text =
        "${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}";
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _updateTransaction() async {
    if (_formKey.currentState!.validate()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      FinancialTransaction updatedTransaction = FinancialTransaction(
        transactionId: widget.transaction.transactionId,
        amount: double.parse(_amountController.text),
        category: _selectedCategory!,
        date: _selectedDate,
        description: _descriptionController.text,
      );

      await UserService().addTransaction(firebaseUser.uid, updatedTransaction);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Transaction updated successfully',
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    'Edit Transaction',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
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
                  const SizedBox(
                    height: 30,
                  ),

                  // Category Dropdown
                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
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
                  const SizedBox(height: 30),

                  TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  TextFormField(
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    controller: _dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      labelStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(
                          2000,
                        ),
                        lastDate: DateTime.now(),
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
                  const SizedBox(
                    height: 30,
                  ),

                  // Update Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icons.arrow_back,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        iconColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      CustomIconButton(
                        onPressed: _updateTransaction,
                        icon: Icons.download_outlined,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        iconColor: Theme.of(context).colorScheme.tertiary,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
