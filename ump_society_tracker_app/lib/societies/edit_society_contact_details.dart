import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/society_contact_db.dart';

class EditContactDetailsScreen extends StatefulWidget {
  final String adminId;

  const EditContactDetailsScreen({super.key, required this.adminId});

  @override
  // ignore: library_private_types_in_public_api
  _EditContactDetailsScreenState createState() => _EditContactDetailsScreenState();
}

class _EditContactDetailsScreenState extends State<EditContactDetailsScreen> {
  final TextEditingController _contactPersonController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cellNumberController = TextEditingController();
  final TextEditingController _whatsappGroupLinkController = TextEditingController();

  // ignore: prefer_final_fields
  bool _isLoading = true;
  // ignore: unused_field
  bool _updateSuccess = false;

  @override
  void initState() {
    super.initState();
    
  }


  Future<void> _saveContactDetails() async {
    final String contactPerson = _contactPersonController.text;
    final String email = _emailController.text;
    final String cellNumber = _cellNumberController.text;
    final String? whatsappGroupLink = _whatsappGroupLinkController.text.isNotEmpty ? _whatsappGroupLinkController.text : null;

    try {
      await ContactsDB.updateContact(
        widget.adminId,
        contactPerson,
        email,
        cellNumber,
        whatsappGroupLink: whatsappGroupLink,
      );

      setState(() {
        _updateSuccess = true;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact details updated successfully.'),
          backgroundColor: Colors.lightBlue, // Light blue color for success
        ),
      );

      // Perform animation and navigate back
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      setState(() {
        _updateSuccess = false;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update contact details. Please try again.'),
          backgroundColor: Colors.lightBlue, // Light blue color for failure
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact Details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _contactPersonController,
                    decoration: const InputDecoration(
                      labelText: 'Contact Person',
                      hintText: 'Enter contact person name',
                      filled: true,
                      fillColor: Color.fromRGBO(0, 0, 41, 1.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter email address',
                      filled: true,
                      fillColor: Color.fromRGBO(0, 0, 41, 1.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _cellNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Cell Number',
                      hintText: 'Enter cell number',
                      filled: true,
                      fillColor: Color.fromRGBO(0, 0, 41, 1.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _whatsappGroupLinkController,
                    decoration: const InputDecoration(
                      labelText: 'WhatsApp Group Link (Optional)',
                      hintText: 'Enter WhatsApp group link (optional)',
                      filled: true,
                      fillColor: Color.fromRGBO(0, 0, 41, 1.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveContactDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Button color
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save Contact Details'),
                  ),
                ],
              ),
            ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
    );
  }
}
