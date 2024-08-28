// ignore_for_file: non_constant_identifier_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/authentication/change_password.dart';
import 'package:ump_society_tracker_app/profile/edit_profile.dart';
import 'package:ump_society_tracker_app/settings/settings.dart';

class AppDrawer extends StatelessWidget {
  final String email;
  final String userType;
  final String fullName;
  final String position;
  final String societyName;
  final String profileImageUrl;
  final Future<void> Function() updateProfilePicture;
  final Future<void> Function() logout;

  const AppDrawer({
    super.key,
    required this.email,
    required this.userType,
    required this.fullName,
    required this.position,
    required this.societyName,
    required this.profileImageUrl,
    required this.updateProfilePicture,
    required this.logout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                          onTap: updateProfilePicture,
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
                                fullName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              if (userType == 'Admin') ...{
                                Text(
                                  position,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  societyName,
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
                                  fullName: fullName,
                                  email: email,
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
                        // ignore: avoid_types_as_parameter_names
                        MaterialPageRoute(builder: (context) => SettingsScreen(onThemeChanged: (ThemeData) {})),
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
                        MaterialPageRoute(builder: (context) => ChangePasswordScreen(email: email)),
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
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                            fullName: fullName,
                            email: email,
                            profileImageUrl: profileImageUrl,
                          ),
                        ),
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
                onTap: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
