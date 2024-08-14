import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/suggestions_db.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';

class SubmitSuggestionScreen extends StatefulWidget {
  final Society society;

  const SubmitSuggestionScreen({super.key, required this.society});

  @override
  // ignore: library_private_types_in_public_api
  _SubmitSuggestionScreenState createState() => _SubmitSuggestionScreenState();
}

class _SubmitSuggestionScreenState extends State<SubmitSuggestionScreen> {
  final TextEditingController _studentNumberController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();
  final ValueNotifier<bool> _consentGiven = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _studentNumberController.dispose();
    _suggestionController.dispose();
    super.dispose();
  }

  Future<void> _submitSuggestion() async {
    if (!_consentGiven.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please consent to submit your suggestion")),
      );
      return;
    }

    String studentNumber = _studentNumberController.text;
    String suggestion = _suggestionController.text;

    await SuggestionsDB.instance.createSuggestion(
      SuggestionsData(
        id: 0,
        societyId: widget.society.name,
        studentNumber: studentNumber,
        suggestion: suggestion,
        timestamp: DateTime.now(),
      ),
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Suggestion submitted")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: const Text("Submit Suggestion", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _studentNumberController,
              decoration: const InputDecoration(
                hintText: "Student Number (Optional)",
                hintStyle: TextStyle(color: Colors.white60),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _suggestionController,
              decoration: const InputDecoration(
                hintText: "Enter your suggestion",
                hintStyle: TextStyle(color: Colors.white60),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              minLines: 3,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: _consentGiven,
                  builder: (context, value, child) {
                    return Checkbox(
                      value: value,
                      onChanged: (bool? newValue) {
                        _consentGiven.value = newValue ?? false;
                      },
                      checkColor: Colors.black,
                      activeColor: Colors.white,
                    );
                  },
                ),
                const Text(
                  "I consent to submit this suggestion",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitSuggestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(3, 169, 244, 1), // Light blue button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Curved corners
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
