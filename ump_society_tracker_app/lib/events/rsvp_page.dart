import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/events/events_db.dart';

class RsvpPage extends StatefulWidget {
  final Event event;

  const RsvpPage({super.key, required this.event});

  @override
  // ignore: library_private_types_in_public_api
  _RsvpPageState createState() => _RsvpPageState();
}

class _RsvpPageState extends State<RsvpPage> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _confirmStudentIdController = TextEditingController();
  bool _consentGiven = false;
  bool _idMatch = true;

  @override
  void initState() {
    super.initState();
    _confirmStudentIdController.addListener(_checkIdMatch);
  }

  void _checkIdMatch() {
    setState(() {
      _idMatch = _studentIdController.text == _confirmStudentIdController.text;
    });
  }

  @override
  void dispose() {
    _confirmStudentIdController.removeListener(_checkIdMatch);
    _studentIdController.dispose();
    _confirmStudentIdController.dispose();
    super.dispose();
  }

  Future<void> _submitRsvp() async {
    if (_formKey.currentState!.validate() && _consentGiven && _idMatch) {
      final studentId = _studentIdController.text;
      await EventsDB.rsvpEvent(widget.event.id, studentId);

      // Show success message
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('RSVP successful!'),
          backgroundColor: Color.fromRGBO(135, 206, 250, 1.0), // Sky blue background
        ),
      );

      // Navigate back to event detail page
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please give your consent to proceed.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (!_idMatch) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student IDs do not match.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RSVP for Event',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(
                    labelText: 'Enter your Student ID',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLength: 9, // Limit to 9 digits
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Student ID';
                    }
                    if (value.length != 9) {
                      return 'Student ID must be 9 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmStudentIdController,
                  decoration: InputDecoration(
                    labelText: 'Confirm your Student ID',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorText: _idMatch ? null : 'Student ID does not match',
                  ),
                  style: const TextStyle(color: Colors.white),
                  maxLength: 9, // Limit to 9 digits
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your Student ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _consentGiven,
                      onChanged: (bool? value) {
                        setState(() {
                          _consentGiven = value ?? false;
                        });
                      },
                      activeColor: const Color.fromRGBO(135, 206, 250, 1.0), // Sky blue checkbox color
                    ),
                    const Expanded(
                      child: Text(
                        'I consent to attend the event. I will cancel my RSVP at least 2 days before the event if I cannot attend.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitRsvp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue background
                    foregroundColor: Colors.white, // White text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Nicely curved corners
                    ),
                    minimumSize: const Size(double.infinity, 50), // Full width button
                  ),
                  child: const Text('Submit RSVP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
