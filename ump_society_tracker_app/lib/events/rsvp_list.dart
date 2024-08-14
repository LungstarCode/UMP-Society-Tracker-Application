import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';

class RsvpListPage extends StatelessWidget {
  final String eventId;

  const RsvpListPage({super.key, required this.eventId});

  Future<List<String>> _fetchRsvps() async {
    return await EventsDB.getRsvps(eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RSVP List',
          style: TextStyle(
            color: Colors.white, // White text color
            fontWeight: FontWeight.bold, // Bold text
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // White leading icon color
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        child: FutureBuilder<List<String>>(
          future: _fetchRsvps(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching RSVP list.'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No RSVPs yet.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      snapshot.data![index],
                      style: const TextStyle(color: Colors.white),
                    ),
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    tileColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue tile background
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
