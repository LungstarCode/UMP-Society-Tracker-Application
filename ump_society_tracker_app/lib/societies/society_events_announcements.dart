import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/event_details.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';
import 'package:ump_society_tracker_app/events/rsvp_page.dart';


class EventsAnnouncementsSection extends StatefulWidget {
  final String societyId;

  const EventsAnnouncementsSection({super.key, required this.societyId});
  
  @override
  // ignore: library_private_types_in_public_api
  _EventsAnnouncementsSectionState createState() => _EventsAnnouncementsSectionState();
}

class _EventsAnnouncementsSectionState extends State<EventsAnnouncementsSection> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = EventsDB.retrieveEvents(widget.societyId);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Events and Announcements',
            style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Stay tuned for upcoming events and important announcements from the society.',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<Event>>(
            future: _eventsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child:  Text('No events available.'));
              } else {
                final events = snapshot.data!;
                return Column(
                  children: events.map((event) {
                    return ListTile(
                      contentPadding:const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        event.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '${event.date} at ${event.time}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.event, color: Colors.orange),
                            onPressed: () {
                              // Handle viewing event details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventDetailPage(event: event),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.thumb_up, color: Colors.orange),
                            onPressed: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => RsvpPage(event: event,)));
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
