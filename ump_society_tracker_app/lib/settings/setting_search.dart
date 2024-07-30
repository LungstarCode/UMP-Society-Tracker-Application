import 'package:flutter/material.dart';

class SettingSearchResultScreen extends StatelessWidget {
  final List<Map<String, dynamic>> searchResults;
  final String query;

  const SettingSearchResultScreen({super.key, required this.searchResults, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Results for "$query"',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0),
        child: searchResults.isEmpty
            ? Center(
                child: Text(
                  'No settings found for "$query"',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    leading: Icon(result['icon'], color: Colors.white),
                    title: Text(
                      result['text'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => result['onTap']()),
                      );
                    },
                  );
                },
              ),
      ),

    );
  }
}
