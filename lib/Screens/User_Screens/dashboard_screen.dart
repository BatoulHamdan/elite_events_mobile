import 'package:flutter/material.dart';
import 'package:elite_events_mobile/app_drawer.dart';
import 'package:elite_events_mobile/navbar.dart';
import 'package:elite_events_mobile/Services/User_Services/user_service.dart';
import 'package:elite_events_mobile/Services/Services_Services/offers_service.dart';
import 'package:elite_events_mobile/Services/User_Services/reviews_service.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  UserDashboardState createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  final UserService userService = UserService();
  final OffersService offersService = OffersService();
  final ReviewService reviewService = ReviewService();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  List<dynamic> offers = [];
  String offersErrorMessage = '';

  List<Map<String, dynamic>> reviews = [];
  String reviewsErrorMessage = '';

  int currentPage = 0;
  int reviewsPerPage = 2;

  TextEditingController reviewController = TextEditingController();
  String reviewText = '';
  bool isReviewFormVisible = false;

  @override
  void initState() {
    super.initState();
    loadUserDashboard();
    fetchOffers();
    fetchReviews();
  }

  Future<void> loadUserDashboard() async {
    final response = await userService.fetchUserDashboard();
    if (response.containsKey('error')) {
      setState(() {
        errorMessage = response['error'];
      });
    } else {
      setState(() {
        userData = response['user'];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchOffers() async {
    try {
      final response = await offersService.getOffers();
      setState(() {
        offers = response;
      });
    } catch (error) {
      setState(() {
        offersErrorMessage = error.toString();
      });
    }
  }

  Future<void> fetchReviews() async {
    try {
      final response = await reviewService.fetchReviews();
      setState(() {
        reviews = response;
      });
    } catch (error) {
      setState(() {
        reviewsErrorMessage = error.toString();
      });
    }
  }

  Future<void> submitReview() async {
    if (reviewText.isEmpty) {
      setState(() {
        reviewsErrorMessage = "Review cannot be empty";
      });
      return;
    }

    try {
      final response = await reviewService.createReview(
        userData?['_id'] ?? '',
        reviewText,
      );

      if (response) {
        reviewController.clear();
        isReviewFormVisible = false;
        fetchReviews();
      } else {
        setState(() {
          reviewsErrorMessage = 'Failed to submit review';
        });
      }
    } catch (error) {
      setState(() {
        reviewsErrorMessage = error.toString();
      });
    }
  }

  // Toggle review form visibility
  void toggleReviewForm() {
    setState(() {
      isReviewFormVisible = !isReviewFormVisible;
    });
  }

  // Pagination Logic
  List<Map<String, dynamic>> getPaginatedReviews() {
    int start = currentPage * reviewsPerPage;
    int end = start + reviewsPerPage;
    if (end > reviews.length) end = reviews.length;
    return reviews.sublist(start, end);
  }

  void nextPage() {
    if ((currentPage + 1) * reviewsPerPage < reviews.length) {
      setState(() {
        currentPage++;
      });
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
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
              image: AssetImage("assets/title.jpg"),
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

                            // Offers Section
                            offersErrorMessage.isNotEmpty
                                ? Text(
                                  offersErrorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                : offers.isEmpty
                                ? const Text(
                                  "No offers available.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                                : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: offers.length,
                                  itemBuilder: (context, index) {
                                    final offer = offers[index];
                                    return Card(
                                      elevation: 5, // Adding shadow to the card
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ), // Rounded corners
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 15,
                                      ), // Margin for spacing
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.redAccent,
                                              Colors.deepOrange,
                                              Colors.red,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(
                                            15,
                                          ),
                                          title: Text(
                                            offer.title ?? 'No Title',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                          subtitle: Text(
                                            offer.description ??
                                                'No Description',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          trailing: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            // Handle onTap if necessary
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            const SizedBox(height: 20),

                            // Reviews Section
                            const Text(
                              "User Reviews",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),

                            reviewsErrorMessage.isNotEmpty
                                ? Text(
                                  reviewsErrorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                                : reviews.isEmpty
                                ? const Text(
                                  "No reviews available.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                )
                                : GridView.builder(
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                      ),
                                  itemCount: getPaginatedReviews().length,
                                  itemBuilder: (context, index) {
                                    final review = getPaginatedReviews()[index];
                                    return Card(
                                      color: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          "${review['firstName']} ${review['lastName']}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          review['comment'],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                            // Pagination controls
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: previousPage,
                                ),
                                Text(
                                  'Page ${currentPage + 1}',
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward),
                                  onPressed: nextPage,
                                ),
                              ],
                            ),

                            // Add Review Button
                            ElevatedButton(
                              onPressed: toggleReviewForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                isReviewFormVisible ? "Cancel" : "Add Review",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Review Form Section
                            if (isReviewFormVisible) ...[
                              const Text(
                                "Write a Review",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: reviewController,
                                decoration: const InputDecoration(
                                  hintText: 'Write your review here...',
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    reviewText = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: submitReview,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Submit Review",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
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
