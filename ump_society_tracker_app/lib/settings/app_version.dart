import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AppVersionInfoScreen extends StatelessWidget {
  const AppVersionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    void submitFeedback() async {
      final String feedback = feedbackController.text;
      if (feedback.isNotEmpty) {
        final Uri emailUri = Uri(
          scheme: 'mailto',
          path: 'support@techtrendsetters.com',
          queryParameters: {
            'subject': 'App Feedback',
            'body': feedback,
          },
        );

        try {
          await launch(emailUri.toString());
          Fluttertoast.showToast(
            msg: "Feedback successfully sent!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } catch (e) {
          Fluttertoast.showToast(
            msg: "Could not send feedback. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Please enter feedback before submitting.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'App Version Info',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'UMP Society Tracker App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Version 2.3.1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Release Date: June 2024',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'What\'s New',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1. Improved performance and bug fixes.\n'
                '2. New user interface for better user experience.\n'
                '3. Added support for more languages.\n'
                '4. Enhanced security features.',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Developer Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'TechTrendSetters\n'
                'Website: www.techtrendsetters.com\n'
                'Email: support@techtrendsetters.com',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Submit Feedback',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback here',
                  hintStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: submitFeedback,
                  icon: const Icon(Icons.send, color: Color.fromRGBO(0, 0, 41, 1.0)),
                  label: const Text('Submit Feedback'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(0, 0, 41, 1.0), backgroundColor: Colors.lightBlue, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
    );
  }
}
