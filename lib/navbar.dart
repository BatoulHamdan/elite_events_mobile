import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Screens/User_Screens/profile_screen.dart';
import 'package:elite_events_mobile/Screens/User_Screens/login_screen.dart';
import 'package:elite_events_mobile/Screens/User_Screens/register_screen.dart';
import 'package:elite_events_mobile/Screens/Event_Screens/events_screen.dart';
import 'package:elite_events_mobile/Services/User_Services/auth_service.dart';

class Navbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const Navbar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  Future<void> _handleMenuSelection(String result) async {
    if (!mounted) return;

    switch (result) {
      case 'Login':
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
      case 'Register':
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterScreen()),
        );
        break;
      case 'Logout':
        await AuthService().logout();
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
        break;
      case 'Profile':
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
      case 'Events':
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Elite Events'),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
      ),
      actions: [
        FutureBuilder<bool>(
          future: AuthService().isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Icon(Icons.error);
            } else if (snapshot.hasData && snapshot.data == true) {
              return PopupMenuButton<String>(
                onSelected: (String result) {
                  _handleMenuSelection(result);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Profile',
                      child: Text('Profile'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Events',
                      child: Text('Events'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
              );
            } else {
              return PopupMenuButton<String>(
                onSelected: (String result) {
                  _handleMenuSelection(result);
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Login',
                      child: Text('Login'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Register',
                      child: Text('Register'),
                    ),
                  ];
                },
              );
            }
          },
        ),
      ],
    );
  }
}
