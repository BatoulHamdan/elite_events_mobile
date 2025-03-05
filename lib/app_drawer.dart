import 'package:elite_events_mobile/Screens/Services_Screens/catering_screen.dart';
import 'package:elite_events_mobile/Screens/Services_Screens/decoration_screen.dart';
import 'package:elite_events_mobile/Screens/Services_Screens/entertainment_screen.dart';
import 'package:elite_events_mobile/Screens/Services_Screens/music_screen.dart';
import 'package:elite_events_mobile/Screens/Services_Screens/photo_screen.dart';
import 'package:elite_events_mobile/Screens/Services_Screens/venue_screen.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 80,
            color: Colors.black,
            alignment: Alignment.center,
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.photo),
            title: Text('Gallery'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GalleryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Venue'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VenueScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.music_note),
            title: Text('Music'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MusicScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('Catering'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CateringScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.brush),
            title: Text('Decoration'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DecorationScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.theater_comedy),
            title: Text('Entertainment'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EntertainmentScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
