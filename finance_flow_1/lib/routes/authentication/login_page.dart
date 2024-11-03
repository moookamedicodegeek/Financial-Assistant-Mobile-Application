import 'package:finance_flow_1/route_manager.dart';
import 'package:finance_flow_1/services/user_auth.dart';
import 'package:finance_flow_1/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false; // To control the visibility of the password
  final UserAuth _userAuth = UserAuth();

  // Function to log in the user
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start showing CircularProgressIndicator
      });
      User? user = await _userAuth.signIn(email: _email, password: _password);
      setState(() {
        _isLoading = false; // Stop showing CircularProgressIndicator
      });

      if (user != null) {
        // Navigate to the main screen without showing a successful login message
        Navigator.pushReplacementNamed(context, RouteManager.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Login Failed'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                ),
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text('Login',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.tertiary,
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value;
                      },
                    ),
                    const SizedBox(height: 35),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 22,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                        hintText: 'Password',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText:
                          !_isPasswordVisible, // Toggle password visibility
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _isLoading
                          ? const CircularProgressIndicator() // Show spinner while loading
                          : CustomButton(
                              color: Theme.of(context).colorScheme.surface,
                              textColor: Theme.of(context).colorScheme.tertiary,
                              onPressed: _login,
                              text: 'Login',
                            ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteManager.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
