import 'package:finance_flow_1/services/user_auth.dart';
import 'package:finance_flow_1/widgets/custom_button.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;
  final UserAuth _userAuth = UserAuth();

  // Function to send a password reset email
  Future<void> _sendPasswordReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await _userAuth.sendPasswordResetEmail(email: _email);
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Password reset link sent to $_email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Forgot Password'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    labelText: 'Email',
                    labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                        color: Color.fromARGB(255, 110, 108, 108))
                    : CustomButton(
                        onPressed: _sendPasswordReset,
                        text: 'Send Password Reset',
                        textColor: Theme.of(context).colorScheme.tertiary,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                const SizedBox(height: 20),
                CustomIconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icons.arrow_back_outlined,
                  buttonColor: Theme.of(context).colorScheme.primary,
                  iconColor: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
