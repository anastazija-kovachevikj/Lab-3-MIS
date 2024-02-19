import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../maps/googleMaps.dart';

// Model class for events
class Event2 {
  final String name;
  final String time;
  final String place;
  final double latitude;
  final double longitude;

  Event2({
    required this.name,
    required this.time,
    required this.place,
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
      time: '10:00 AM',
      place: 'Finki',
      latitude:  42.00438241893107,
      longitude:   21.410177085673432,
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

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(event.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time: ${event.time}'),
            Text('Place: ${event.place}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleMapWidget(
                  destination: LatLng(event.latitude, event.longitude),
                ),
              ),
            );
          },
          child: Text('Get Directions'),
        ),
      ),
    );
  }
}
