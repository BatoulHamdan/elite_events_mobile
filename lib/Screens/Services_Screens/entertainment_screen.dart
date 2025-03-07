import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/entertainment_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/entertainment_service.dart';
import 'entertainment_detail_screen.dart';

class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({super.key});

  @override
  EntertainmentScreenState createState() => EntertainmentScreenState();
}

class EntertainmentScreenState extends State<EntertainmentScreen> {
  final EntertainmentService entertainmentService = EntertainmentService();
  List<Entertainment> entertainmentList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEntertainments();
  }

  Future<void> _fetchEntertainments() async {
    setState(() => isLoading = true);
    try {
      List<Entertainment> fetchedEntertainment =
          await entertainmentService.getEntertainments();
      setState(() {
        entertainmentList = fetchedEntertainment;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load entertainment services';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Entertainment')),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/title.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : errorMessage.isNotEmpty
                  ? Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                  : entertainmentList.isEmpty
                  ? const Text(
                    "No entertainment services found. Tap '+' to add one!",
                  )
                  : RefreshIndicator(
                    onRefresh: _fetchEntertainments,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: entertainmentList.length,
                      itemBuilder: (context, index) {
                        final entertainment = entertainmentList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              entertainment.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Price: \$${entertainment.price.toStringAsFixed(2)}',
                            ),
                            leading:
                                entertainment.images.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'http://10.0.2.2:5000/api/user/service/images/${entertainment.images[0]}',
                                        fit: BoxFit.cover,
                                        width: 60,
                                        height: 60,
                                      ),
                                    )
                                    : const Icon(Icons.music_note, size: 60),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => EntertainmentDetailScreen(
                                        entertainment: entertainment,
                                      ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
        ),
      ),
    );
  }
}
