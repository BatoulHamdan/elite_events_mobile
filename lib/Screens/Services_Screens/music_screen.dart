import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/music_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/music_service.dart';
import 'music_detail_screen.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  MusicScreenState createState() => MusicScreenState();
}

class MusicScreenState extends State<MusicScreen> {
  late Future<List<Music>> _musicList;

  @override
  void initState() {
    super.initState();
    _musicList = MusicService().getMusic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music Services')),
      body: FutureBuilder<List<Music>>(
        future: _musicList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No music services available.'));
          } else {
            List<Music> musicList = snapshot.data!;

            return ListView.builder(
              itemCount: musicList.length,
              itemBuilder: (context, index) {
                Music music = musicList[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      music.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(music.type),
                        const SizedBox(height: 5),
                        Text('Price: \$${music.price.toStringAsFixed(2)}'),
                      ],
                    ),
                    leading:
                        music.images.isNotEmpty
                            ? Image.network(
                              'http://10.0.2.2:5000/api/user/service/images/${music.images[0]}',
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                            : const Icon(Icons.music_note, size: 60),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MusicDetailScreen(music: music),
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
