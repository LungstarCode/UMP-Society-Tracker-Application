import 'package:flutter/material.dart';
import 'society_db.dart';
import 'view_society.dart';

class SocietySearch extends StatefulWidget {
  final String query;

  const SocietySearch({super.key, required this.query});

  @override
  // ignore: library_private_types_in_public_api
  _SocietySearchState createState() => _SocietySearchState();
}

class _SocietySearchState extends State<SocietySearch> {
  late Future<List<Society>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = _searchSocieties(widget.query);
  }

  Future<List<Society>> _searchSocieties(String query) async {
    final List<Society> allSocieties = await SocietyDB.retrieveSocieties();
    return allSocieties
        .where((society) =>
            society.name.toLowerCase().contains(query.toLowerCase()) ||
            society.description.toLowerCase().contains(query.toLowerCase()) ||
            society.category.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 9, 41, 1.0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Search Results',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 9, 41, 1.0),
        ),
        child: FutureBuilder<List<Society>>(
          future: _searchResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No societies found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewSociety(
                            society: snapshot.data![index],
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.lightBlue, width: 1),
                      ),
                      color: const Color.fromRGBO(0, 9, 41, 1.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        title: Text(
                          snapshot.data![index].name,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              snapshot.data![index].description,
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Category: ${snapshot.data![index].category}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.remove_red_eye, color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
