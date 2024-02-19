import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../maps/googleMaps.dart';

class Event2 {
  final String name;
  final String time;
  final String place;
  final DateTime date;
  final double latitude;
  final double longitude;

  Event2({
    required this.name,
    required this.time,
    required this.place,
    required this.date,
    required this.latitude,
    required this.longitude,
  });
}

void main() {
  runApp(MaterialApp(
    home: EventListScreen(),
  ));
}

class EventListScreen extends StatelessWidget {
  final List<Event2> events = [
    Event2(
      name: 'Finki Event',
      time: '10:00',
      place: 'Finki',
      date: DateTime(2024, 2, 22),
      latitude: 42.00438241893107,
      longitude: 21.410177085673432,
    ),
    Event2(
      name: 'Coding Event',
      time: '16:00',
      place: 'Public room',
      date: DateTime(2024, 2, 25),
      latitude: 41.99002261456822,
      longitude: 21.42572958428729,
    ),
    Event2(
      name: 'Conference Event',
      time: '19:00',
      place: 'Boris Trajkovski Sports Center',
      date: DateTime(2024, 2, 22),
      latitude: 42.00964657816307,
      longitude: 21.404400073655303,
    ),
    Event2(
      name: 'Conference Event',
      time: '19:00',
      place: 'Hotel Russia',
      date: DateTime(2024, 2, 22),
      latitude: 41.99307382294972,
      longitude: 21.465710446667472,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event2 event;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  EventCard({Key? key, required this.event}) : super(key: key) {
    final settingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings();
    final initializationSettings =
    InitializationSettings(android: settingsAndroid, iOS: settingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(event.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${event.time}'),
            Text('Place: ${event.place}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.cyan.shade900),
              iconSize: 30,
              onPressed: () {
                _scheduleNotification();
              },
            ),
            IconButton(
              icon: Icon(Icons.directions, color: Colors.cyan.shade900),
              iconSize: 30,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoogleMapScreen(
                      destination: LatLng(event.latitude, event.longitude),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _scheduleNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '2',
      'reminder',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder',
      'Don\'t forget about ${event.name} at ${event.place}!',
      platformChannelSpecifics,
    );
  }

}
