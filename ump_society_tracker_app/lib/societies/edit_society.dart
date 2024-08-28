import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/edit_society_contact_details.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';

class EditSocietyScreen extends StatefulWidget {
  final String societyName;

  const EditSocietyScreen({super.key, required this.societyName});

  @override
  _EditSocietyScreenState createState() => _EditSocietyScreenState();
}

class _EditSocietyScreenState extends State<EditSocietyScreen> {
  final TextEditingController _adminIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  bool _isAuthorized = false;
  Society? _society;

  @override
  void initState() {
    super.initState();
    _loadSocietyDetails();
  }

  Future<void> _loadSocietyDetails() async {
    final society = await SocietyDB.retrieveSocietyByName(widget.societyName);
    if (society != null) {
      setState(() {
        _society = society;
        _nameController.text = society.name;
        _descriptionController.text = society.description;
        _categoryController.text = society.category;
      });
    }
  }

  Future<void> _validateAdmin(String adminId) async {
    if (_society != null && _society!.adminId == adminId) {
      setState(() {
        _isAuthorized = true;
      });
    } else {
      _showSnackBar('Invalid Admin ID. Access Denied.');
      setState(() {
        _isAuthorized = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue color
      ),
    );
  }

  Future<void> _navigateToEditSection(String section) async {
    // Implement navigation to the relevant section
    // You can create separate screens for each section or handle it within this screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: const Text(
          'Edit Society',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: !_isAuthorized
            ? Column(
                children: [
                  const Text(
                    'Enter Admin ID to edit society details:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _adminIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Admin ID',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white24,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      if (value.isNotEmpty && !RegExp(r'^\d+$').hasMatch(value)) {
                        _showSnackBar('Admin ID can only contain digits');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _validateAdmin(_adminIdController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, 
                        backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // White text color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Authenticate'),
                    ),
                  ),
                ],
              )
            : ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.white),
                    title: const Text(
                      'Edit Society Details',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigateToEditSection('details'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.contact_phone, color: Colors.white),
                    title: const Text(
                      'Edit Society Contact Info',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditContactDetailsScreen(adminId: _society!.adminId)));
                    }
                  ),
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.white),
                    title: const Text(
                      'Other Options',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => _navigateToEditSection('other_options'),
                  ),
                ],
              ),
      ),
    );
  }
}
