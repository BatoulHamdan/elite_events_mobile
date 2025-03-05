import 'package:elite_events_mobile/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:elite_events_mobile/app_drawer.dart';
import 'package:elite_events_mobile/navbar.dart';
import 'package:elite_events_mobile/Services/User_Services/profile_service.dart';
import 'package:elite_events_mobile/Models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProfileService _profileService = ProfileService();
  String? firstName; // Store the user's first name

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userId = await AuthService().getUserId(); 

    if (userId != null) {
      User? user = await _profileService.getUserById(userId);
      if (user != null) {
        setState(() {
          firstName = user.firstName;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Welcome Message
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                firstName != null
                    ? "Welcome, $firstName!"
                    : "Welcome to Elite Events!",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Services & Events Section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Elite Events - We Make Your Vision a Reality!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
