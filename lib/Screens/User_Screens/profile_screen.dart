// import 'package:elite_events_mobile/app_drawer.dart';
// import 'package:elite_events_mobile/navbar.dart';
// import 'package:flutter/material.dart';
// import 'dart:developer';
// import 'package:elite_events_mobile/Services/User_Services/profile_service.dart';
// import 'package:elite_events_mobile/Models/user_model.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   User? user;
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserProfile(); // Call the fetch method here
//   }

//   Future<void> fetchUserProfile() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null; // Reset error message on retry
//     });

//     try {
//       User fetchedUser = await ProfileService.getUserById();
//       setState(() {
//         user = fetchedUser;
//         isLoading = false;
//       });
//     } catch (e) {
//       log("Error fetching profile: $e"); // Log the error for debugging
//       setState(() {
//         errorMessage = "Error fetching profile: $e";
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Navbar(),
//       drawer: AppDrawer(),

//       body: Center(
//         child:
//             isLoading
//                 ? CircularProgressIndicator()
//                 : errorMessage != null
//                 ? Text(errorMessage!, style: TextStyle(color: Colors.red))
//                 : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.account_circle, size: 100, color: Colors.grey),
//                     SizedBox(height: 10),
//                     Text(
//                       "${user!.firstName} ${user!.lastName}",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 5),
//                     Text(
//                       "Email: ${user!.email}",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: fetchUserProfile, // Refresh on button press
//                       child: Text("Refresh Profile"),
//                     ),
//                   ],
//                 ),
//       ),
//     );
//   }
// }
