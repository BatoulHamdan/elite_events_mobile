import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Services/User_Services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService userService = UserService();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final response = await userService.fetchUserDashboard();
    if (!mounted) return;
    if (response.containsKey('error')) {
      setState(() {
        errorMessage = response['error'];
        isLoading = false;
      });
    } else {
      setState(() {
        userData = response['user'];
        firstNameController.text = userData?['firstName'] ?? '';
        lastNameController.text = userData?['lastName'] ?? '';
        emailController.text = userData?['email'] ?? '';
        isLoading = false;
      });
    }
  }

  Future<void> updateProfile() async {
    final updatedUser = {
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'email': emailController.text,
    };

    final response = await userService.updateUserProfile(updatedUser);

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error updating profile'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage.isNotEmpty
              ? Center(
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Name:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your first name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Last Name:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your last name',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: const Text('Update Profile'),
                    ),
                  ],
                ),
              ),
    );
  }
}
