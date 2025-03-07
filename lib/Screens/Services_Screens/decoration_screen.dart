import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/decoration_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/decoration_service.dart';
import 'decoration_detail_screen.dart';

class DecorationScreen extends StatefulWidget {
  const DecorationScreen({super.key});

  @override
  DecorationScreenState createState() => DecorationScreenState();
}

class DecorationScreenState extends State<DecorationScreen> {
  final DecorationService decorationService = DecorationService();
  List<Decorationn> decorationList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchDecorations();
  }

  Future<void> _fetchDecorations() async {
    setState(() => isLoading = true);
    try {
      List<Decorationn> fetchedDecorations =
          await decorationService.getDecorations();
      setState(() {
        decorationList = fetchedDecorations;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load decorations';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decorations')),
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
                  : decorationList.isEmpty
                  ? const Text("No decorations found. Tap '+' to add one!")
                  : RefreshIndicator(
                    onRefresh: _fetchDecorations,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: decorationList.length,
                      itemBuilder: (context, index) {
                        final decoration = decorationList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              decoration.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Type: ${decoration.type}'),
                                Text(
                                  'Price: \$${decoration.price.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            leading:
                                decoration.images.isNotEmpty
                                    ? Image.network(
                                      'http://10.0.2.2:5000/api/user/service/images/${decoration.images[0]}',
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.broken_image,
                                          size: 60,
                                        );
                                      },
                                    )
                                    : const Icon(Icons.light, size: 60),
                            trailing: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.arrow_forward_ios, size: 16),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DecorationDetailScreen(
                                        decorationn: decoration,
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
