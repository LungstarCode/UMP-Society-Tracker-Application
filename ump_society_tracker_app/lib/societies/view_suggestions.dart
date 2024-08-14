import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/suggestions_db.dart';

class ViewSuggestions extends StatefulWidget {
  final Society society;

  const ViewSuggestions({super.key, required this.society});

  @override
  // ignore: library_private_types_in_public_api
  _ViewSuggestionsState createState() => _ViewSuggestionsState();
}

class _ViewSuggestionsState extends State<ViewSuggestions> {
  bool isAdmin = false;
  TextEditingController adminIdController = TextEditingController();
  List<SuggestionsData> suggestions = [];

  Future<void> _authenticateAdmin(String adminId) async {
    if (adminId.isNotEmpty && adminId == widget.society.adminId) {
      setState(() {
        isAdmin = true;
      });
      await _fetchSuggestions();
    } else {
      _showSnackBar('Invalid Admin ID');
    }
  }

  Future<void> _fetchSuggestions() async {
    List<SuggestionsData> fetchedSuggestions = await SuggestionsDB.instance.getAllSuggestions(widget.society.name);
    setState(() {
      suggestions = fetchedSuggestions;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Sky blue color
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: Text(
          'Suggestions for ${widget.society.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: isAdmin
            ? ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return Card(
                    color: const Color.fromRGBO(255, 255, 255, 0.9),
                    child: ListTile(
                      title: Text(
                        suggestion.suggestion,
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        'Submitted by: ${suggestion.studentNumber.isNotEmpty ? suggestion.studentNumber : 'Anonymous'}\n'
                        'Timestamp: ${suggestion.timestamp}',
                        style: const TextStyle(
                          color: Color.fromRGBO(0, 0, 41, 1.0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              )
            : Column(
                children: [
                  const Text(
                    'Enter Admin ID to view suggestions:',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: adminIdController,
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
                        _authenticateAdmin(adminIdController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // White text color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Authenticate'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
