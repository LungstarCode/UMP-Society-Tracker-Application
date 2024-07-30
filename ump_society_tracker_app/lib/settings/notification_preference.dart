
import 'package:flutter/material.dart';

class NotificationsPreferenceScreen extends StatefulWidget {
  const NotificationsPreferenceScreen({super.key});

  @override
  _NotificationsPreferenceScreenState createState() =>
      _NotificationsPreferenceScreenState();
}

class _NotificationsPreferenceScreenState
    extends State<NotificationsPreferenceScreen> {
  bool _notificationsEnabled = true; // Initial state

  void _toggleNotifications(bool newValue) {
    setState(() {
      _notificationsEnabled = newValue;
    });
    // You can implement logic here to save the user's preference
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
      body: Center(
        child: Card(
          color: Colors.white,
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 32.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Notifications Preference',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListTile(
                  title: const Text('Enable Notifications'),
                  trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: Colors.lightBlueAccent, // Sky blue color
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
