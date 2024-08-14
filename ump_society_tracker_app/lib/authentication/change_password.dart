import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/databases/db_helper.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String email;

  const ChangePasswordScreen({super.key, required this.email});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isProcessing = false;
  String _message = '';

  Future<void> _changePassword() async {
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _message = 'New password and confirm password do not match.';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _message = '';
    });

    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUserByEmail(widget.email);

    if (user == null || user['password'] != currentPassword) {
      setState(() {
        _message = 'Current password is incorrect.';
        _isProcessing = false;
      });
      return;
    }

    try {
      await dbHelper.updateUserPassword(widget.email, newPassword);
      setState(() {
        _message = 'Password changed successfully.';
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Error changing password. Please try again.';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTextField(
              controller: _currentPasswordController,
              label: 'Current Password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _newPasswordController,
              label: 'New Password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm New Password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isProcessing ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue, // Sky blue background
                minimumSize: const Size(double.infinity, 48), // Match the width of the text fields
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: _isProcessing
                  ? const CircularProgressIndicator()
                  : const Text('Change Password', style: TextStyle(color: Colors.white)),
            ),
            if (_message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('Error') ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Colors.white), // White text color
      decoration: InputDecoration(
        labelText: label,
        hintText: label, // Placeholder text
        hintStyle: const TextStyle(color: Colors.white), // White placeholder text
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white), // White outline
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.white), // White outline on focus
        ),
        filled: true,
        fillColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
      ),
    );
  }
}
