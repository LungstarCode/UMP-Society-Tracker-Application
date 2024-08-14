import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/authentication/login.dart';
import 'package:ump_society_tracker_app/databases/db_helper.dart';
import 'package:ump_society_tracker_app/events/create_event.dart';
import 'package:ump_society_tracker_app/events/events_list.dart';
import 'package:ump_society_tracker_app/societies/join_society.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/view_members.dart';
import 'package:ump_society_tracker_app/societies/view_suggestions.dart';
import 'submit_suggestion.dart'; 

class ViewSociety extends StatefulWidget {
  final Society society;

  const ViewSociety({super.key, required this.society});

  @override
  // ignore: library_private_types_in_public_api
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.society.description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmitSuggestionScreen(society: widget.society),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Suggestion',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Place for other widgets
            ],
          ),
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
                          // Add other ListTile items as needed
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
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => CreateEventPage(societyId: widget.society.adminId)));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.group, color: Colors.orange),
                            title: const Text('View Members', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ViewMembers(society: widget.society))
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.event_available, color: Colors.orange),
                            title: const Text('View Events', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(context ,
                              MaterialPageRoute(builder: (context) => EventsListPage(societyId: widget.society.adminId, userId: '',)));
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
                                MaterialPageRoute(builder: (context) => JoinSociety(society: widget.society,) )
                              );
                              
                            },
                          ),

                        
                          ListTile(
                            leading: const Icon(Icons.logout, color: Colors.orange),
                            title: const Text('Logout', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(context, 
                              MaterialPageRoute(builder: (context) => const LoginScreen()));
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
    );
  }
}
