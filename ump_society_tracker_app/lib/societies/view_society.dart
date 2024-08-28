import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/authentication/login.dart';
import 'package:ump_society_tracker_app/databases/db_helper.dart';
import 'package:ump_society_tracker_app/events/create_event.dart';
import 'package:ump_society_tracker_app/events/events_list.dart';
import 'package:ump_society_tracker_app/societies/edit_society.dart';
import 'package:ump_society_tracker_app/societies/join_society.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/society_details.dart';
import 'package:ump_society_tracker_app/societies/society_notifications.dart';
import 'package:ump_society_tracker_app/societies/submit_suggestion.dart';
import 'package:ump_society_tracker_app/societies/view_members.dart';
import 'package:ump_society_tracker_app/societies/view_suggestions.dart';

class ViewSociety extends StatefulWidget {
  final Society society;

  const ViewSociety({super.key, required this.society});

  @override
  _ViewSocietyState createState() => _ViewSocietyState();
}

class _ViewSocietyState extends State<ViewSociety> {
  late Future<Map<String, dynamic>?> _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _fetchCurrentUser(); // Fetch user information when the widget is initialized
  }

  Future<Map<String, dynamic>?> _fetchCurrentUser() async {
    return await DatabaseHelper().getCurrentUser('society.admin@ump.ac.za');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: Text(
          widget.society.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_membership),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JoinSociety(society: widget.society),
                ),
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SocietyDetail(society: widget.society), // Use the SocietyDetail widget here
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      drawer: Drawer(
        child: Container(
          color: const Color.fromRGBO(0, 0, 41, 1.0),
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _currentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error fetching user data'));
              } else if (snapshot.hasData) {
                var user = snapshot.data;
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(user?['name'] ?? 'No Name', style: const TextStyle(color: Colors.white)),
                      accountEmail: Text(user?['email'] ?? 'No Email', style: const TextStyle(color: Colors.white)),
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 41, 1.0),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.feedback, color: Colors.orange),
                            title: const Text('Submit Suggestion', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context); // Close the drawer
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubmitSuggestionScreen(society: widget.society),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.view_list, color: Colors.orange),
                            title: const Text('View Suggestions', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewSuggestions(society: widget.society),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.event, color: Colors.orange),
                            title: const Text('Create Event', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateEventPage(societyId: widget.society.adminId),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.group, color: Colors.orange),
                            title: const Text('View Members', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewMembers(society: widget.society),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.event_available, color: Colors.orange),
                            title: const Text('View Events', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EventsListPage(
                                    societyId: widget.society.adminId,
                                    userId: '',
                                  ),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.insert_chart, color: Colors.orange),
                            title: const Text('Generate Report', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              // Add your navigation code here
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.card_membership, color: Colors.orange),
                            title: const Text('Join Society', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinSociety(society: widget.society),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.notification_add, color: Colors.orange),
                            title: const Text('Societies Notifications', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SocietyNotificationsScreen(userId: '220329966'),
                                ),
                              );
                            },
                          ),

                           ListTile(
                            leading: const Icon(Icons.edit, color: Colors.orange),
                            title: const Text('Edit Society', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSocietyScreen(societyName: widget.society.name),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.orange),
                            title: const Text('Logout', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('No user data available'));
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBottomBarIcon(Icons.home, 'Home', () {
                Navigator.pop(context); // Navigates back to the home screen or previous screen
              }),
              _buildBottomBarIcon(Icons.feedback, 'Suggestion', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubmitSuggestionScreen(society: widget.society),
                  ),
                );
              }),
              _buildBottomBarIcon(Icons.card_membership, 'Join', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinSociety(society: widget.society),
                  ),
                );
              }),
              _buildBottomBarIcon(Icons.event, 'Events', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventsListPage(
                      societyId: widget.society.adminId,
                      userId: '',
                    ),
                  ),
                );
              }),
              _buildBottomBarIcon(Icons.group, 'Members', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewMembers(society: widget.society),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarIcon(IconData icon, String label, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: label,
    );
  }
}
