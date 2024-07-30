
import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/authentication/login.dart';
import 'package:ump_society_tracker_app/databases/db_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String? userType;
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController studentNumberController = TextEditingController();
  final TextEditingController usernameController = TextEditingController(); // Added for Primary Admin
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController societyNameController = TextEditingController();
  final TextEditingController positionController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  final TextEditingController workEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account' ,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select User Type',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: const Color.fromRGBO(0, 0, 41, 1.0),
                items: const [
                  DropdownMenuItem(value: 'Member', child: Text('Member', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin', style: TextStyle(color: Colors.white))),
                  DropdownMenuItem(value: 'Primary Admin', child: Text('Primary Admin', style: TextStyle(color: Colors.white))),
                ],
                onChanged: (value) {
                  setState(() {
                    userType = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a user type' : null,
              ),
              if (userType != null && userType != 'Primary Admin') ..._buildFields(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String email = '${studentNumberController.text}@ump.ac.za';
                      if (userType == 'Primary Admin') {
                        email = '${usernameController.text}@ump.ac.za';
                      }
                      Map<String, dynamic> user = {
                        'userType': userType,
                        'name': nameController.text,
                        'surname': surnameController.text,
                        if (userType != 'Primary Admin') 'studentNumber': studentNumberController.text,
                        if (userType == 'Primary Admin') 'username': usernameController.text,
                        'email': email,
                        'password': passwordController.text,
                        if (userType == 'Admin') ...{
                          'societyName': societyNameController.text,
                          'position': positionController.text,
                         
                        }

                       
                      };
                      await DatabaseHelper().insertUser(user);

                      // Show a customized success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Account created successfully!',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      );

                      // Navigate to the login screen
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  const LoginScreen()));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) =>  const LoginScreen()));
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields() {
    List<Widget> fields = [
      const SizedBox(height: 16),
      TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: 'Name',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.person, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: surnameController,
        decoration: const InputDecoration(
          labelText: 'Surname',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.person, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? 'Please enter your surname' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: studentNumberController,
        decoration: const InputDecoration(
          labelText: 'Student Number',
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.school, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? 'Please enter your student number' : null,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: passwordController,
        obscureText: _obscurePassword,
decoration: InputDecoration(
  labelText: 'Password',
  labelStyle: const TextStyle(color: Colors.white),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  border: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
  prefixIcon: const Icon(Icons.lock, color: Colors.white),
  suffixIcon: IconButton(
    icon: Icon(
      _obscurePassword ? Icons.visibility : Icons.visibility_off,
      color: Colors.white,
    ),
    onPressed: () {
      setState(() {
        _obscurePassword = !_obscurePassword;
      });
    },
  ),
),
        style: const TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
      ),
    ];

    if (userType == 'Admin') {
  fields.addAll([
    const SizedBox(height: 16),
    TextFormField(
      controller: societyNameController,
      decoration: const InputDecoration(
        labelText: 'Society Name',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.group, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'Please enter the society name' : null,
    ),
    const SizedBox(height: 16),
    TextFormField(
      controller: positionController,
      decoration: const InputDecoration(
        labelText: 'Position',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.work, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'Please enter your position' : null,
    ),
    const SizedBox(height: 16),
    TextFormField(
      controller: referenceController,
      decoration: const InputDecoration(
        labelText: 'Reference',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.book, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'Please enter a reference' : null,
    ),
  ]);
} else if (userType == 'Primary Admin') {
  fields.addAll([
    const SizedBox(height: 16),
    TextFormField(
      controller: usernameController,
      decoration: const InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: Icon(Icons.person, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
    ),
  ]);
}

return fields;
  }
  
}