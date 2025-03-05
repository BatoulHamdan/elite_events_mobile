// import 'package:flutter/material.dart';
// import 'package:elite_events_mobile/app_drawer.dart';
// import 'package:elite_events_mobile/navbar.dart';
// import 'package:elite_events_mobile/Services/user_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List<String> photos = [];
//   List<String> offers = [];
//   List<Map<String, String>> reviews = [];
//   int currentIndex = 0;
//   final PageController _pageController = PageController();

//   @override
//   void initState() {
//     super.initState();
//     fetchOffers();
//     fetchReviews();
//   }


//   // Future<void> fetchOffers() async {
//   //   List<String> fetchedOffers = await UserService.getServiceOffers();
//   //   setState(() {
//   //     offers = fetchedOffers;
//   //   });
//   // }

//   // Future<void> fetchReviews() async {
//   //   List<Map<String, String>> fetchedReviews =
//   //       await UserService.getUserReviews();
//   //   setState(() {
//   //     reviews = fetchedReviews;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Navbar(),
//       drawer: AppDrawer(),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Offers Section
//             if (offers.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 color: Colors.amberAccent,
//                 child: Column(
//                   children:
//                       offers
//                           .map(
//                             (offer) => Text(
//                               offer,
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ),

//             // Slideshow Section (Replaced Carousel with PageView)
//             if (photos.isNotEmpty)
//               SizedBox(
//                 height: 200,
//                 child: PageView.builder(
//                   controller: _pageController,
//                   itemCount: photos.length,
//                   onPageChanged: (index) {
//                     setState(() {
//                       currentIndex = index;
//                     });
//                   },
//                   itemBuilder: (context, index) {
//                     return Container(
//                       margin: const EdgeInsets.all(5.0),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Image.network(
//                         photos[index],
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                       ),
//                     );
//                   },
//                 ),
//               ),

//             // Services & Events Section
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 "Elite Events - We Make Your Vision a Reality!",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),

//             // Reviews Section
//             if (reviews.isNotEmpty)
//               Column(
//                 children: [
//                   const Text(
//                     "Reviews",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: reviews.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(
//                           "${reviews[index]['firstName']} ${reviews[index]['lastName']}",
//                         ),
//                         subtitle: Text(reviews[index]['comment'] ?? ""),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
