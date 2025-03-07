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
  final MusicService musicService = MusicService();
  List<Music> musicList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMusic();
  }

  Future<void> _fetchMusic() async {
    setState(() => isLoading = true);
    try {
      List<Music> fetchedMusic = await musicService.getMusic();
      setState(() {
        musicList = fetchedMusic;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load music services';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Music')),
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
                  : musicList.isEmpty
                  ? const Text("No music services found. Tap '+' to add one!")
                  : RefreshIndicator(
                    onRefresh: _fetchMusic,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: musicList.length,
                      itemBuilder: (context, index) {
                        final music = musicList[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(
                              music.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(music.type),
                                const SizedBox(height: 5),
                                Text(
                                  'Price: \$${music.price.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            leading:
                                music.images.isNotEmpty
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'http://10.0.2.2:5000/api/user/service/images/${music.images[0]}',
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
                                      (context) =>
                                          MusicDetailScreen(music: music),
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
