import 'package:flutter/material.dart';
import 'package:elite_events_mobile/Models/Services_Models/photo_model.dart';
import 'package:elite_events_mobile/Services/Services_Services/photo_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  GalleryScreenState createState() => GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen> {
  final PhotoService photoService = PhotoService();
  List<Photo> photoList = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  Future<void> _fetchPhotos() async {
    setState(() => isLoading = true);
    try {
      List<Photo> fetchedPhotos = await photoService.getPhotos();
      setState(() {
        photoList = fetchedPhotos;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load photos';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
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
                  : photoList.isEmpty
                  ? const Text("No photos found. Pull down to refresh.")
                  : RefreshIndicator(
                    onRefresh: _fetchPhotos,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: photoList.length,
                      itemBuilder: (context, index) {
                        final photo = photoList[index];
                        return GestureDetector(
                          onTap:
                              () => _showFullScreenImage(
                                context,
                                photo.images[0],
                              ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  photo.images.isNotEmpty
                                      ? Image.network(
                                        'http://10.0.2.2:5000/api/user/service/images/${photo.images[0]}',
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(Icons.image, size: 60),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: Image.network(
                'http://10.0.2.2:5000/api/user/service/images/$imageUrl',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
