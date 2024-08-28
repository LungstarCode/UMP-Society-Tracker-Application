import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/join_society.dart';
import 'package:ump_society_tracker_app/societies/view_society.dart';

class SocietyCards extends StatefulWidget {
  final String userType;
  final String societyName;

  const SocietyCards({
    super.key,
    required this.userType,
    required this.societyName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SocietyCardsState createState() => _SocietyCardsState();
}

class _SocietyCardsState extends State<SocietyCards> {
  List<Society> societies = [];

  @override
  void initState() {
    super.initState();
    _loadSocieties();
  }

  Future<void> _loadSocieties() async {
    List<Society> retrievedSocieties = await SocietyDB.retrieveSocieties();
    setState(() {
      societies = retrievedSocieties;
    });
  }

  Widget _buildSocietyCard(Society society) {
    return Container(
      width: 300, // Adjust width as needed
      height: 120, // Adjust height to accommodate the new padding
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding between the title and the top of the card
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              society.name,
              style: const TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    society.description,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3, // Limit description lines
                  ),
                  const SizedBox(height: 8), // Padding between description and category
                  Text(
                    'Category: ${society.category}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton('View', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewSociety(society: society),
                  ),
                );
              }),
              _buildActionButton('Join', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinSociety(society: society),
                  ),
                );
              }),
              _buildActionButton('Exit', onTap: () {
                // Add action for Exit button for members
              }),
              if (widget.userType == 'Admin' && society.name == widget.societyName) 
                _buildActionButton('Edit', onTap: () {
                  // Add action for Edit button for admins
                }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, {required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: societies.length,
        itemBuilder: (context, index) {
          return _buildSocietyCard(societies[index]);
        },
      ),
    );
  }
}
