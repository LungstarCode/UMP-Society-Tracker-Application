import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:ump_society_tracker_app/societies/membership_db.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';

class JoinSociety extends StatefulWidget {
  final Society society;

  const JoinSociety({super.key, required this.society});

  @override
  // ignore: library_private_types_in_public_api
  _JoinSocietyState createState() => _JoinSocietyState();
}

class _JoinSocietyState extends State<JoinSociety> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _studentIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _joinSociety(BuildContext context) async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final studentId = _studentIdController.text.trim();

    if (name.isEmpty || surname.isEmpty || studentId.isEmpty || studentId.length != 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill out all fields with valid information")),
      );
      return;
    }

    try {
      // Check if the user is already a member of the society
      final isMember = await MembershipDB.checkMembership(studentId, widget.society.name);

      if (isMember) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You are already a member of this society")),
        );
        return;
      }

      // Add the user to the society
      await MembershipDB.addMember(Member(
        studentId: studentId,
        name: name,
        surname: surname,
        societyName: widget.society.name,
      ));

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully joined the society")),
      );

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close the screen

    } catch (e) {
      // Handle errors (e.g., database issues)
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to join the society: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        title: Text(
          "Join ${widget.society.name}",
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your details to join ${widget.society.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _surnameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Surname',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _studentIdController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Student ID',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9), // Limit input to 9 digits
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to the previous screen
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _joinSociety(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Light blue button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Curved corners
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                  child: const Text(
                    "Join",
                    style: TextStyle(fontSize: 16 , color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
