import 'package:finance_flow_1/models/user_model.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:flutter/material.dart';
import '../widgets/base_screen.dart';

class VirtualCardPage extends StatefulWidget {
  const VirtualCardPage({super.key});

  @override
  State<VirtualCardPage> createState() => _VirtualCardPageState();
}

class _VirtualCardPageState extends State<VirtualCardPage> {
  UserModel? _currentUser;
  final UserService _userService = UserService(); // Using UserService

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the current user ID from UserService
      final userId = _userService.getCurrentUserId();
      if (userId != null) {
        // Fetch user data using UserService
        UserModel? user = await _userService.getUser(userId);
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      setState(() {
        _currentUser = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Virtual Card',
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.only(left: 7, top: 7),
            child: Container(
              height: 550,
              width: 355,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 80, left: 25.0, right: 50),
                child: _currentUser == null
                    ? const CircularProgressIndicator() // Show a loader while fetching data
                    : Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              height: 70,
                              width: 50,
                            ),
                          ),
                          const SizedBox(height: 130),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Holder',
                                style: TextStyle(
                                  fontSize: 22,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                getFirstLetter(_currentUser?.name) != ''
                                    ? "${getFirstLetter(_currentUser?.name)} ${_currentUser?.surname}"
                                    : 'Not available',
                                style: TextStyle(
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Account Number',
                                style: TextStyle(
                                  fontSize: 22,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Text(
                                _currentUser?.cardNumber ?? 'Not available',
                                style: TextStyle(
                                  fontSize: 24,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    'Debit',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 130),
                                  Image.asset(
                                    'assets/images/mastercard.png',
                                    width: 70,
                                    height: 90,
                                  ),
                                ],
                              ),
                            ],
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

  String? getFirstLetter(String? word) {
    if (word != null && word.isNotEmpty) {
      return word.substring(0, 1);
    } else {
      return '';
    }
  }
}
