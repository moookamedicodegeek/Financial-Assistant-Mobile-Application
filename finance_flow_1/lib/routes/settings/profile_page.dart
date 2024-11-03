import 'package:finance_flow_1/models/user_model.dart';
import 'package:finance_flow_1/services/user_service.dart';
import 'package:finance_flow_1/widgets/base_screen.dart';
import 'package:finance_flow_1/widgets/icon_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _currentUser; // Store the logged-in user's data
  final UserService _userService =
      UserService(); // Use the UserService instance

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {
        // Fetch user data using the UserService class
        UserModel? user = await _userService.getUser(firebaseUser.uid);

        if (user != null) {
          setState(() {
            _currentUser = user;
          });
        } else {}
      }
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  _buildProfileImage(context),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.person_outline_outlined,
                    title: _currentUser?.name ?? 'Unavailable',
                    subtitle: 'Name',
                  ),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.person_outline_outlined,
                    title: _currentUser?.surname ?? 'Unavailable',
                    subtitle: 'Surname',
                  ),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.email_outlined,
                    title: _currentUser?.email ?? 'Unavailable',
                    subtitle: 'Email',
                  ),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.date_range_outlined,
                    title: _currentUser?.dob ??
                        'Unavailable', // Directly use dob since it's already a String
                    subtitle: 'Date of Birth',
                  ),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.pin_drop_outlined,
                    title: _currentUser?.address ?? 'Unavailable',
                    subtitle: 'Address',
                  ),
                  const SizedBox(height: 25),
                  _buildUserInfoTile(
                    icon: Icons.credit_card_outlined,
                    title: _currentUser?.cardNumber ?? 'Unavailable',
                    subtitle: 'Account Number',
                  ),
                  const SizedBox(height: 25),
                  CustomIconButton(
                    icon: Icons.arrow_back,
                    buttonColor: Theme.of(context).colorScheme.primary,
                    iconColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
      title: 'User Profile',
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary,
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundImage: _image().image,
        radius: 70,
      ),
    );
  }

  Widget _buildUserInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Material(
      elevation: 5,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1,
          ),
        ),
        leading: Icon(
          icon,
          size: 45,
        ),
        title: Text(
          title,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Image _image() {
    // Check if imageUrl is null or empty
    if (_currentUser == null ||
        _currentUser!.imageUrl == null ||
        _currentUser!.imageUrl!.isNotEmpty) {
      // Return a default image if the imageUrl is not available
      return Image.asset('assets/images/bot.jpg'); // Default image
    } else {
      // Return the user's image if available
      return Image.asset(
          'assets/images/bot.jpg'); // Assuming imageUrl is a network URL
    }
  }
}
