import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';
import 'package:ump_society_tracker_app/societies/membership_db.dart';

class SocietyNotificationsScreen extends StatelessWidget {
  final String userId; // Student ID or User ID

  const SocietyNotificationsScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    // Fetch RSVPs
    List<Event> rsvps = await EventsDB.retrieveUserRsvps(userId);

    // Fetch memberships
    List<Member> memberships = await MembershipDB.retrieveUserSocieties(userId);

    // Combine results in a single list
    List<Map<String, dynamic>> notifications = [];

    for (var event in rsvps) {
      notifications.add({
        'type': 'RSVP',
        'event': event,
        'society': event.societyId,
        'date': event.date,
        'time': event.time,
      });
    }

    for (var member in memberships) {
      notifications.add({
        'type': 'Joined Society',
        'society': member.societyName,
        'name': '${member.name} ${member.surname}',
      });
    }

    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Society Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Background color as per the theme
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0), 
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchNotifications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Error fetching notifications',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No notifications available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final notifications = snapshot.data!;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Card(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      notification['type'] == 'RSVP'
                          ? Icons.event_available
                          : Icons.group_add,
                      color: Colors.white,
                    ),
                    title: Text(
                      notification['type'] == 'RSVP'
                          ? 'RSVP\'d to ${notification['event'].name}'
                          : 'Joined ${notification['society']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      notification['type'] == 'RSVP'
                          ? '${notification['society']} | ${notification['date']} ${notification['time']}'
                          : 'Member: ${notification['name']}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

