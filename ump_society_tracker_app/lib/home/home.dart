import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:ump_society_tracker_app/authentication/change_password.dart';
import 'package:ump_society_tracker_app/authentication/login.dart';
import 'package:ump_society_tracker_app/databases/db_helper.dart';
import 'package:ump_society_tracker_app/profile/edit_profile.dart';
import 'package:ump_society_tracker_app/settings/settings.dart';
import 'package:ump_society_tracker_app/societies/society.dart'; 

class HomeScreen extends StatefulWidget {
  final String email;
  final String userType;
  final String fullName;
  final String position;
  final String societyName;

  const HomeScreen({super.key, 
    required this.email,
    required this.userType,
    required this.fullName,
    required this.position,
    required this.societyName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();

  
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String profileImageUrl = "";
  bool _showToast = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    
  }

  Future<void> _loadUserProfile() async {
    final user = await DatabaseHelper().getUserByEmail(widget.email);
    if (user != null) {
      setState(() {
        profileImageUrl = user['profileImageUrl'] ?? profileImageUrl;
      });
    }
  }

  Future<void> _updateProfilePicture() async {
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String newPath = path.join(directory.path, path.basename(pickedFile.path));
      final File newImage = await File(pickedFile.path).copy(newPath);

      await DatabaseHelper().updateUserProfilePicture(widget.email, newImage.path);

      setState(() {
        profileImageUrl = newImage.path;
      });
    }
  }

  Future<void> _logout() async {
    // Implement logout logic here (clear user session, etc.)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) =>  const LoginScreen()),
      (route) => false,
    );
  }




  final List<Society> _dummySocieties = [
    Society(name: 'Thrive Students', description: 'A society for thriving students', category: ''),
    Society(name: 'Anti-GBV Society', description: 'Fighting against gender-based violence', category: ''),
    Society(name: 'Society C', description: 'Description for Society C', category: ''),
    Society(name: 'Society D', description: 'Description for Society D', category: ''),
  ];

  Widget _buildSocietyCard(Society society) {
    return Container(
      width: 300, // Adjust width as needed
      height: 200, // Increased height to accommodate buttons
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            society.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                society.description,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 3, // Limit description lines
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Add action for View button
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // White text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('View'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add action for Join button
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // White text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Join'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Add action for Exit button for members
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // White text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: const Text('Exit'),
              ),
              if (widget.userType == 'Admin' && society.name == widget.societyName) ...{
                ElevatedButton(
                  onPressed: () {
                    // Add action for Edit button for admins
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.lightBlue, // White text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Edit'),
                ),
              },
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Society Tracker App',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white), // Title color changed to white
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromRGBO(0, 0, 41, 1.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 41, 1.0),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: _updateProfilePicture,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: profileImageUrl.isNotEmpty
                                      ? FileImage(File(profileImageUrl))
                                      : null,
                                  backgroundColor: Colors.grey,
                                  child: profileImageUrl.isEmpty
                                      ? const Icon(Icons.person, size: 30, color: Colors.white)
                                      : null,
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.edit, size: 14, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.email,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                if (widget.userType == 'Admin') ...{
                                  Text(
                                    widget.position,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    widget.societyName,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                },
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(
                                    fullName: widget.fullName,
                                    email: widget.email,
                              
                                    profileImageUrl: profileImageUrl,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    ListTile(
                      leading: const Icon(Icons.settings, color: Colors.orange),
                      title: const Text(
                        'Settings',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, 
                          // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                          MaterialPageRoute(builder: (context) => SettingsScreen(onThemeChanged: (ThemeData ) {  },) )
                        );
                      },
                    ),
                     ListTile(
                      leading: const Icon(Icons.password, color: Colors.orange),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => ChangePasswordScreen(email: widget.email) )
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications, color: Colors.orange),
                      title: const Text(
                        'Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // Handle navigation to Notifications
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.chat, color: Colors.orange),
                      title: const Text(
                        'Chats',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        // Handle navigation to Chats
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.verified_user, color: Colors.orange),
                      title: const Text(
                        'Profile',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditProfileScreen(
                                    fullName: widget.fullName,
                                    email: widget.email,
                              
                                    profileImageUrl: profileImageUrl,
                                  ),)
                        );
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.orange),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: _logout,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${widget.fullName}',
              style: const TextStyle(fontSize: 18, color: Colors.white), // Text color changed to white
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for societies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: _dummySocieties.map(_buildSocietyCard).toList(),
            ),
          ),
          if (_showToast) // Show the toast if _showToast is true
            GestureDetector(
              onTap: () {
                // Handle toast tap (e.g., navigate to the society's page)
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners for the toast
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Best Society of the Week: ${_dummySocieties[0].name}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _showToast = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0), // Padding to separate the bottom bar from the scroll indicator
            child: Text(
              '← Swipe to see more societies →',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.white), // White icon color
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.white), // White icon color
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Colors.white), // White icon color
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white), // White icon color
            label: 'Profile',
          ),
        ],
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Background color for the bottom bar
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Handle bottom navigation bar item tap

            if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
                builder: (context) => SettingsScreen(onThemeChanged: (ThemeData ) {},),
              ),
            );
            
          }


          if (index == 3){

            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfileScreen(
                                    fullName: widget.fullName,
                                    email: widget.email,
                              
                                    profileImageUrl: profileImageUrl,
                                  ),
                )
            );
          }

        },
      ),
    );
  }
} 