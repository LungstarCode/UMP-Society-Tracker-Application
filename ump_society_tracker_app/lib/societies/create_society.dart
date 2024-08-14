import 'package:flutter/material.dart';
import 'society_db.dart';

class CreateSociety extends StatefulWidget {
  const CreateSociety({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateSocietyState createState() => _CreateSocietyState();
}

class _CreateSocietyState extends State<CreateSociety> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _category = 'Sports'; // Default category
  String _creatorFullName = '';
  String _creatorStudentNumber = '';
  bool _showOtherCategoryField = false;

  void _showToast(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Cancel',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 9, 41, 1.0),
        title: const Text(
          'Create Society',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 9, 41, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Society Name',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.group, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the society name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.description, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.category, color: Colors.white),
                    ),
                    dropdownColor: const Color.fromRGBO(0, 9, 41, 1.0), // Dark blue background
                    style: const TextStyle(color: Colors.white), // White text
                    value: _category,
                    items: <String>[
                      'Sports',
                      'Educational',
                      'Religion',
                      'Cultural',
                      'Christianity',
                      'Other',
                    ].map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _category = newValue!;
                        _showOtherCategoryField = _category == 'Other';
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _category = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  if (_showOtherCategoryField)
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Specify Other Category',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixIcon: Icon(Icons.text_fields, color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (_category == 'Other' && (value == null || value.isEmpty)) {
                          return 'Please specify the other category';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (_category == 'Other') {
                          _category = value!;
                        }
                      },
                    ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Creator's Full Names",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the creator's full names";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _creatorFullName = value!;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Creator's Student Number",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.badge, color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the creator's student number";
                      } else if (value.length != 9 || !RegExp(r'^\d{9}$').hasMatch(value)) {
                        return "Student number must be 9 digits";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _creatorStudentNumber = value!;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Check if society name already exists
                        bool isDuplicate = await SocietyDB.checkDuplicateSociety(_name);
                        if (isDuplicate) {
                          _showToast('Society already exists', Colors.lightBlueAccent);
                          return;
                        }

                        // Proceed with creating society request
                        await SocietyDB.createSocietyRequest(
                          _name,
                          _description,
                          _category,
                          _creatorFullName,
                          _creatorStudentNumber,
                        );

                        _showToast('Society creation request sent', Colors.lightBlueAccent);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.1),
                      ),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        'Submit Request',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Added to ensure there's space after the button
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
    );
  }
}
