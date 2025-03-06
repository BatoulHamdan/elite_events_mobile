import 'package:flutter/material.dart';
import 'package:elite_events_mobile/app_drawer.dart';
import 'package:elite_events_mobile/navbar.dart';
import 'package:elite_events_mobile/Services/User_Services/user_service.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  UserDashboardState createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  final UserService userService = UserService();
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadUserDashboard();
  }

  Future<void> loadUserDashboard() async {
    final response = await userService.fetchUserDashboard();

    if (response.containsKey('error')) {
      setState(() {
        errorMessage = response['error'];
        isLoading = false;
      });
    } else {
      setState(() {
        userData = response['user'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(),
      drawer: AppDrawer(),
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.avif"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : errorMessage.isNotEmpty
                        ? Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        )
                        : Column(
                          children: [
                            Text(
                              "Welcome, ${userData?['firstName'] ?? 'User'}!",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5.0,
                                    color: Colors.black38,
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
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
}
