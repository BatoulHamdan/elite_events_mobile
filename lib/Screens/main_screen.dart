import 'package:elite_events_mobile/Screens/User_Screens/profile_screen.dart';
import 'package:elite_events_mobile/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Screens/home_screen.dart';
import 'package:elite_events_mobile/Screens/User_Screens/login_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await AuthService().isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isLoggedIn ? const ProfileScreen() : const LoginScreen();
  }
}
