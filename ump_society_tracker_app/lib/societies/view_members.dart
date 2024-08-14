import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/membership_db.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart'; // Import if needed for Society model

class ViewMembers extends StatefulWidget {
  final Society society; // Assuming Society model is needed

  const ViewMembers({super.key, required this.society});

  @override
  // ignore: library_private_types_in_public_api
  _ViewMembersState createState() => _ViewMembersState();
}

class _ViewMembersState extends State<ViewMembers> {
  late Future<List<Member>> _members;

  @override
  void initState() {
    super.initState();
    _members = _fetchMembers(); // Fetch members when the widget is initialized
  }

  Future<List<Member>> _fetchMembers() async {
    return await MembershipDB.retrieveMembersOfSociety(widget.society.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        title: Text(
          'Members of ${widget.society.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        child: FutureBuilder<List<Member>>(
          future: _members,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No members found.', style: TextStyle(color: Colors.white)));
            } else {
              final members = snapshot.data!;
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return Card(
                    color: Colors.transparent, // Transparent background
                    margin: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.lightBlueAccent, width: 2.0), // Light blue border
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0),
                      title: Text(
                        '${member.name} ${member.surname}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Student ID: ${member.studentId}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
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
