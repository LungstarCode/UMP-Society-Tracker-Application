import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/suggestions_db.dart';

import 'package:ump_society_tracker_app/society_store/widget_haven.dart';

class ViewSociety extends StatefulWidget {
  final Society society;

  const ViewSociety({super.key, required this.society});

  @override
  _ViewSocietyState createState() => _ViewSocietyState();
}

class _ViewSocietyState extends State<ViewSociety> {
  final List<Widget> _canvas = [];

  Future<void> _navigateToWidgetHaven(BuildContext context) async {
    TextEditingController studentNumberController = TextEditingController();
    bool isAdmin = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Student Number"),
          content: TextField(
            controller: studentNumberController,
            decoration: const InputDecoration(hintText: "Student Number"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () async {
                String studentNumber = studentNumberController.text;
                if (studentNumber == widget.society.adminId) {
                  isAdmin = true;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (isAdmin) {
      final newWidgets = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WidgetHavenDB(society: widget.society),
        ),
      );

      if (newWidgets != null) {
        setState(() {
          _canvas.addAll(newWidgets);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only accessible for Admins")),
      );
    }
  }

  Future<void> _showSuggestionBox(BuildContext context) async {
    TextEditingController studentNumberController = TextEditingController();
    TextEditingController suggestionController = TextEditingController();
    ValueNotifier<bool> consentGiven = ValueNotifier<bool>(false);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submit Suggestion"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentNumberController,
                decoration: const InputDecoration(hintText: "Student Number (Optional)"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: suggestionController,
                decoration: const InputDecoration(hintText: "Enter your suggestion"),
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: consentGiven,
                    builder: (context, value, child) {
                      return Checkbox(
                        value: value,
                        onChanged: (bool? newValue) {
                          consentGiven.value = newValue ?? false;
                        },
                      );
                    },
                  ),
                  const Text("I consent to submit this suggestion"),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () async {
                if (!consentGiven.value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please consent to submit your suggestion")),
                  );
                  return;
                }

                String studentNumber = studentNumberController.text;
                String suggestion = suggestionController.text;

                await SuggestionsDB.instance.createSuggestion(
                  SuggestionsData(
                    id: 0,
                    societyId: widget.society.name,
                    studentNumber: studentNumber,
                    suggestion: suggestion,
                    timestamp: DateTime.now(),
                  ),
                );

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Suggestion submitted")),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _viewSuggestions(BuildContext context) async {
    TextEditingController studentNumberController = TextEditingController();
    bool isAdmin = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Student Number"),
          content: TextField(
            controller: studentNumberController,
            decoration: const InputDecoration(hintText: "Student Number"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Submit"),
              onPressed: () async {
                String studentNumber = studentNumberController.text;
                if (studentNumber == widget.society.adminId) {
                  isAdmin = true;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    if (isAdmin) {
      List<SuggestionsData> suggestions = await SuggestionsDB.instance.getSuggestionsBySocietyId(widget.society.name);

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Suggestions", style: TextStyle(color: Colors.black)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(suggestions.length, (index) {
                  return Card(
                    color: const Color.fromRGBO(0, 0, 41, 1.0),
                    child: ListTile(
                      title: Text(
                        suggestions[index].suggestion,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            suggestions[index].studentNumber.isNotEmpty
                                ? "Student Number: ${suggestions[index].studentNumber}"
                                : "Student Number: Unknown",
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "Submitted on: ${suggestions[index].timestamp.toLocal()}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Close", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
            backgroundColor: const Color.fromRGBO(255, 255, 255, 1.0),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only accessible for Admins")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: Text(
          widget.society.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () => _viewSuggestions(context),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.society.description,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _navigateToWidgetHaven(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Widget Haven',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showSuggestionBox(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Submit Suggestion',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._canvas,
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
    );
  }
}
