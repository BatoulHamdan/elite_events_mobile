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
  late Future<List<Decorationn>> _decorationList;

  @override
  void initState() {
    super.initState();
    _decorationList = DecorationService().getDecorations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Decorations')),
      body: FutureBuilder<List<Decorationn>>(
        future: _decorationList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No decorations available.'));
          } else {
            List<Decorationn> decorationList = snapshot.data!;

            return ListView.builder(
              itemCount: decorationList.length,
              itemBuilder: (context, index) {
                Decorationn decoration = decorationList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      decoration.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Type: ${decoration.type}'),
                        Text('Price: \$${decoration.price.toStringAsFixed(2)}'),
                      ],
                    ),
                    leading:
                        decoration.images.isNotEmpty
                            ? Image.network(
                              'http://10.0.2.2:5000/api/user/service/images/${decoration.images[0]}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                            : const Icon(Icons.light, size: 60),
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
            );
          }
        },
      ),
    );
  }
}
