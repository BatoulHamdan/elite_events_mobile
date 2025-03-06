import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Screens/User_Screens/login_screen.dart';
import 'package:elite_events_mobile/Screens/User_Screens/register_screen.dart';
import 'package:elite_events_mobile/Services/User_Services/auth_service.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const Navbar({super.key})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

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
                onSelected: (String result) async {
                  switch (result) {
                    case 'Login':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      break;
                    case 'Register':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                      break;
                    case 'Logout':
                      await AuthService().logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      break;
                    case 'Settings':
                      // Navigate to Settings screen
                      break;
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem<String>(
                      value: 'Settings',
                      child: Text('Settings'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
              );
            } else {
              // User is not logged in
              return PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result) {
                    case 'Login':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      break;
                    case 'Register':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                      break;
                  }
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
