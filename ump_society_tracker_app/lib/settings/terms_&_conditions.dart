import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
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
              _buildTermsText(),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                  );
                },
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText() {
    return const Text(
      '''Welcome to the UMP Society Tracker App. By downloading, installing, and using this app, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.

1. Acceptance of Terms
By accessing and using the UMP Society Tracker App, you accept and agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use the app.

2. Eligibility
The UMP Society Tracker App is intended for use by the students, staff, and faculty of the University of Mpumalanga. By using this app, you confirm that you are a current member of the UMP community.

3. User Accounts
- Users must create an account to access certain features of the app.
- Users are responsible for maintaining the confidentiality of their account credentials and for all activities that occur under their account.

4. Usage Guidelines
- The app is to be used solely for the purpose of managing and participating in university societies and related activities.
- Users must not use the app for any unlawful or prohibited activities.
- Users must not engage in any behavior that disrupts the operation or integrity of the app.

5. Privacy Policy
Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.

6. Content and Intellectual Property
- All content provided through the app, including text, graphics, logos, and images, is the property of the University of Mpumalanga or its content suppliers and is protected by intellectual property laws.
- Users may not reproduce, distribute, or create derivative works from any content accessed through the app without prior written permission.

7. Modification of Terms
The University of Mpumalanga reserves the right to modify these Terms and Conditions at any time. Users will be notified of any changes through the app. Continued use of the app after such modifications constitutes acceptance of the new terms.

8. Termination of Use
The University of Mpumalanga reserves the right to terminate or suspend access to the app at any time, without notice, for any reason, including if you breach any of these Terms and Conditions.

9. Limitation of Liability
The UMP Society Tracker App is provided "as is" and "as available" without warranties of any kind. The University of Mpumalanga does not warrant that the app will be uninterrupted or error-free. The university is not liable for any damages arising from the use or inability to use the app.

10. Governing Law
These Terms and Conditions are governed by and construed in accordance with the laws of South Africa. Any disputes arising out of or relating to these terms or the use of the app shall be resolved in the courts of South Africa.

11. Contact Information
For any questions or concerns regarding these Terms and Conditions, please contact us at [insert contact information].

By using the UMP Society Tracker App, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions.''',
      style: TextStyle(color: Colors.white),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''[Insert Privacy Policy Here]''',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}