import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/all_societies.dart';
import 'package:ump_society_tracker_app/societies/create_society.dart';
import 'package:ump_society_tracker_app/societies/primary_admin.dart';
import 'package:ump_society_tracker_app/societies/society_request_status.dart';

class ManageSocietiesScreen extends StatelessWidget {
  final bool isAdmin;
  final String societyName;

  const ManageSocietiesScreen({super.key, required this.isAdmin, required this.societyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        title: const Text(
          'Manage Societies',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildListItem(Icons.add, 'Create Society', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateSociety()),
              );
            }),
            _buildListItem(Icons.view_list, 'View Societies', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllSocieties()),
              );
            }),
            _buildListItem(Icons.how_to_reg, 'Society Requests', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrimaryAdminLogin()),
              );
            }),
            _buildListItem(Icons.history, 'Society Request Status', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SocietyRequestStatus()),
              );
            }),
            _buildListItem(Icons.home, 'Home', () {
              // Navigate to Home screen
              
            }),
            _buildListItem(Icons.settings, 'Settings', () {
              // Navigate to Settings screen
            }),
            
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
