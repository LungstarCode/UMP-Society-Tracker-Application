import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ump_society_tracker_app/events/create_event.dart';
import 'package:ump_society_tracker_app/events/event_details.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';

class EventsListPage extends StatefulWidget {
  final String societyId;
  final String userId;

  const EventsListPage({super.key, required this.societyId, required this.userId});

  @override
  // ignore: library_private_types_in_public_api
  _EventsListPageState createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  late Future<List<Event>> _futureEvents;
  final TextEditingController _adminIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureEvents = EventsDB.retrieveEvents(widget.societyId);
  }

  @override
  void dispose() {
    _adminIdController.dispose();
    super.dispose();
  }

  void _viewEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: event),
      ),
    );
  }

  Future<void> _showAdminIdDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            width: double.infinity, // Full width of the screen
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Admin ID',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _adminIdController,
                  keyboardType: TextInputType.number,
                  maxLength: 9, // Limit to 9 digits
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  ],
                  decoration: InputDecoration(
                    counterText: "", // Hide character counter
                    labelText: 'Admin ID',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintText: 'Enter your Admin ID',
                    hintStyle: const TextStyle(color: Colors.white38),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(3, 169, 244, 1), // Sky blue border color
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.white, // White border color when focused
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () {
                        String adminIdInput = _adminIdController.text;
                        if (adminIdInput == widget.societyId) {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateEventPage(societyId: widget.societyId),
                            ),
                          ).then((_) {
                            setState(() {
                              _futureEvents = EventsDB.retrieveEvents(widget.societyId);
                            });
                          });
                        } else {
                          Navigator.of(context).pop();
                          _showAccessDeniedMessage();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAccessDeniedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Access Denied: Incorrect Admin ID'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
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
        child: FutureBuilder<List<Event>>(
          future: _futureEvents,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error loading events', style: TextStyle(color: Colors.white)),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No events available', style: TextStyle(color: Colors.white)),
              );
            } else {
              final events = snapshot.data!;
              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: Color.fromRGBO(3, 169, 244, 1), // Sky blue border color
                        width: 2.0,
                      ),
                    ),
                    color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
                    child: ListTile(
                      title: Text(
                        event.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold, // Bold text
                          fontSize: 18.0, // Increased font size
                        ),
                      ),
                      subtitle: Text(
                        '${event.date} ${event.time}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () => _viewEventDetails(event),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue background
                          foregroundColor: Colors.white, // White text color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0), // Nicely curved corners
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                      onTap: () {
                        _viewEventDetails(event);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAdminIdDialog,
        backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Dark blue background
        child: const Icon(Icons.add, color: Colors.white), // White icon
      ),
    );
  }
}
