import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/home/cards.dart';
import 'package:ump_society_tracker_app/home/drawer.dart';
import 'package:ump_society_tracker_app/societies/society_search.dart';


class HomeScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const HomeScreen({
    Key? key,
    required this.userType,
    required this.email,
    required this.fullName,
    required this.position,
    required this.societyName,
  }) : super(key: key);

  final String userType;
  final String email;
  final String fullName;
  final String position;
  final String societyName;

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String email = '';
  String userType = '';
  String fullName = '';
  String position = '';
  String societyName = '';
  String profileImageUrl = '';
  int _selectedIndex = 0;
  String _searchQuery = '';

  Future<void> updateProfilePicture() async {
    // Implement your update profile picture logic here
  }

  Future<void> logout() async {
    // Implement your logout logic here
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on index
    });
  }

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SocietySearch(query: _searchQuery),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White title color
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        iconTheme: const IconThemeData(color: Colors.white), // White menu icon
      ),
      drawer: AppDrawer(
        email: widget.email,
        userType: widget.userType,
        fullName: widget.fullName,
        position: widget.position,
        societyName: widget.societyName,
        profileImageUrl: profileImageUrl,
        updateProfilePicture: updateProfilePicture,
        logout: logout,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              'Welcome ${widget.fullName}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.black),
                      hintText: 'Search for societies',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: _search,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SocietyCards(
                    userType: widget.userType,
                    societyName: widget.societyName,
                  ),
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Scroll horizontally to view more societies',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'The best society of the week is Thrive Students',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    // Add your close button action here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Societies',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        onTap: _onItemTapped,
      ),
    );
  }
}
