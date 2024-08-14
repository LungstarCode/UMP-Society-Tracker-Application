import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';
import 'package:ump_society_tracker_app/events/rsvp_list.dart';
import 'package:ump_society_tracker_app/events/rsvp_page.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  const EventDetailPage({super.key, required this.event});

 void _rsvpEvent(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RsvpPage(event: event),
    ),
  );
}

  String _daysLeft() {
    final eventDate = DateTime.parse(event.date); 
    final today = DateTime.now();
    final difference = eventDate.difference(today).inDays;
    return difference >= 0 ? '$difference days left' : 'Event passed';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.name,
          style: const TextStyle(
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
        color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background for entire screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded Card to use full width
              Card(
                color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue card background
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Color.fromRGBO(135, 206, 250, 1.0), // Sky blue border color
                    width: 2.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Date: ${event.date}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                        ),
                      ),
                      Text(
                        'Time: ${event.time}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                        ),
                      ),
                      Text(
                        'Venue: ${event.venue}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                        ),
                      ),
                      Text(
                        'Duration: ${event.duration}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                        ),
                      ),
                      Text(
                        'Seats: ${event.seats}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                        ),
                      ),
                      if (event.theme != null)
                        Text(
                          'Theme: ${event.theme}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white, // White text color
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        event.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text color
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _daysLeft(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white, // White text color
                          fontWeight: FontWeight.bold, // Bold text
                        ),
                      ),
                      const SizedBox(height: 20), // Space before the button
                      ElevatedButton(
                        onPressed: () => _rsvpEvent(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue background
                          foregroundColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Nicely curved corners
                          ),
                          minimumSize: const Size(double.infinity, 50), // Full width button
                        ),
                        child: const Text('RSVP'),
                      ),

                       const SizedBox(height: 20), // Space before the button
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>RsvpListPage(eventId: event.id)
                          ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue background
                          foregroundColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Nicely curved corners
                          ),
                          minimumSize: const Size(double.infinity, 50), // Full width button
                        ),
                        child: const Text('View RSVPs'),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue background
                    foregroundColor: Colors.white, // White text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Nicely curved corners
                    ),
                    minimumSize: const Size(150, 50), // Adjust the size as needed
                  ),
                  child: const Text('Back to Events'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
