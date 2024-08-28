 // Import the search results screen
import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/authentication/change_password.dart';
import 'package:ump_society_tracker_app/authentication/login.dart';
import 'package:ump_society_tracker_app/home/home.dart';
import 'package:ump_society_tracker_app/settings/about.dart';
import 'package:ump_society_tracker_app/settings/app_version.dart';
import 'package:ump_society_tracker_app/settings/notification_preference.dart';
import 'package:ump_society_tracker_app/settings/setting_search.dart';
import 'package:ump_society_tracker_app/settings/terms_&_conditions.dart';
import 'package:ump_society_tracker_app/societies/manage_society.dart';


class SettingsScreen extends StatelessWidget {

  final Function(ThemeData) onThemeChanged;
  
  const SettingsScreen({super.key, required this.onThemeChanged, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      appBar: AppBar(
        title: const Text(
          'Settings',
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
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 2.5,
          children: [
            _buildSettingsTile(
              context,
              icon: Icons.lock,
              text: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen(email: '',)),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.notifications,
              text: 'Notification Preferences',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPreferenceScreen()),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.group,
              text: 'Manage Societies',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageSocietiesScreen(
                    isAdmin: true,
                    societyName: 'Thrive Students',
                  )),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.event,
              text: 'Event Management',
              onTap: () {
                 //
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.description,
              text: 'Terms & Conditions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.info,
              text: 'About',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
            _buildSettingsTile(
              context,
              icon: Icons.logout,
              text: 'Logout',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomDrawer(context);
        },
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showBottomDrawer(BuildContext context) {
    String searchQuery = '';
    
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search settings...',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.orange),
                      onPressed: () {
                        _searchSettings(context, searchQuery);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    searchQuery = value;
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.orange),
                title: const Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(
                     
                        fullName: '',
                        position: '',
                        societyName: '',
                         userType: '', 
                         email: '',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.verified, color: Colors.orange),
                title: const Text('App Version Info', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppVersionInfoScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                onTap: () {
                  // Add your onTap logic here
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchSettings(BuildContext context, String query) {
    final List<Map<String, dynamic>> tiles = [
      {'icon': Icons.lock, 'text': 'Change Password', 'onTap': () => const ChangePasswordScreen(email: '',)},
      {'icon': Icons.notifications, 'text': 'Notification Preferences', 'onTap': () => const NotificationsPreferenceScreen()},
      {'icon': Icons.group, 'text': 'Manage Societies', 'onTap': () => const ManageSocietiesScreen(
        isAdmin: true,
        societyName: 'Thrive Students',
      )},
      {'icon': Icons.event, 'text': 'Event Management', 'onTap': () => null},
      {'icon': Icons.description, 'text': 'Terms & Conditions', 'onTap': () => const TermsAndConditionsScreen()},
      {'icon': Icons.info, 'text': 'About', 'onTap': () => const AboutScreen()},
      {'icon': Icons.logout, 'text': 'Logout', 'onTap': () => const LoginScreen()},
    ];

    final results = tiles.where((tile) => tile['text'].toString().toLowerCase().contains(query.toLowerCase())).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingSearchResultScreen(searchResults: results, query: query),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {required IconData icon, required String text, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.lightBlue,
        elevation: 4.0,
        shadowColor: Colors.black54,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color.fromRGBO(0, 0, 41, 1.0)),
              const SizedBox(height: 8.0),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(color: Color.fromRGBO(0, 0, 41, 1.0), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
