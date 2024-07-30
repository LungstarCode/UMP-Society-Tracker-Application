import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _currentPassword = '';
  String _newPassword = '';
  // ignore: unused_field
  String _confirmNewPassword = '';
  bool _isLoading = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a backend call to change the password
      await Future.delayed(const Duration(seconds: 2));

      // Assume password change is successful
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password changed successfully!'),
        backgroundColor: Colors.green,
      ));

      // Navigate back or clear fields
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildPasswordField(
                      context,
                      label: 'Current Password',
                      onChanged: (value) => _currentPassword = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your current password';
                        }
                        return null;
                      },
                      icon: Icons.lock_outline,
                    ),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                      context,
                      label: 'New Password',
                      onChanged: (value) => _newPassword = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a new password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      icon: Icons.lock_open,
                    ),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                      context,
                      label: 'Confirm New Password',
                      onChanged: (value) => _confirmNewPassword = value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your new password';
                        } else if (value != _newPassword) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      icon: Icons.lock,
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.lightBlueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('Change Password'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context,
      {required String label,
      required Function(String) onChanged,
      required String? Function(String?) validator,
      required IconData icon}) {
    return TextFormField(
      obscureText: true,
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: Colors.white),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}