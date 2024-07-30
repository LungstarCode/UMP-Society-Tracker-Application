import 'package:flutter/material.dart';
import 'society_db.dart';

class PrimaryAdminLogin extends StatefulWidget {
  const PrimaryAdminLogin({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrimaryAdminLoginState createState() => _PrimaryAdminLoginState();
}

class _PrimaryAdminLoginState extends State<PrimaryAdminLogin> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Primary Admin Login',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background color
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background color
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool isValid = await SocietyDB.validatePrimaryAdmin(_email, _password);
                    if (isValid) {
                      Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (context) => const PrimaryAdminPanel()),
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid credentials', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.lightBlueAccent, // Sky blue background color
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.1),
                  ),
                  minimumSize: const Size(double.infinity, 50), // Match the height of text fields
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryAdminPanel extends StatefulWidget {
  const PrimaryAdminPanel({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrimaryAdminPanelState createState() => _PrimaryAdminPanelState();
}

class _PrimaryAdminPanelState extends State<PrimaryAdminPanel> {
  late Future<List<SocietyRequest>> _societyRequests;

  @override
  void initState() {
    super.initState();
    _societyRequests = SocietyDB.retrieveSocietyRequests();
  }

  void _approveSociety(SocietyRequest request) async {
    await SocietyDB.approveSociety(request);
    setState(() {
      _societyRequests = SocietyDB.retrieveSocietyRequests();
    });
  }

  void _rejectSociety(SocietyRequest request) async {
    await SocietyDB.rejectSociety(request);
    setState(() {
      _societyRequests = SocietyDB.retrieveSocietyRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Primary Admin CPanel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // Change icon color to white
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      body: FutureBuilder<List<SocietyRequest>>(
        future: _societyRequests,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.lightBlueAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No society requests found.', style: TextStyle(color: Colors.white)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background color
                    border: Border.all(color: Colors.lightBlueAccent), // Sky blue outline color
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
  color: const Color.fromRGBO(0, 0, 41, 1.0),
  child: ListTile(
    title: Text(
      snapshot.data![index].name,
      style: const TextStyle(color: Colors.white),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          snapshot.data![index].description,
          style: const TextStyle(color: Colors.white70),
        ),
        Text(
          'Admin Names: ${snapshot.data![index].adminNames}',
          style: const TextStyle(color: Colors.white70),
        ),
        Text(
          'Admin ID: ${snapshot.data![index].adminId}',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              _approveSociety(snapshot.data![index]);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              _rejectSociety(snapshot.data![index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
