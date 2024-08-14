import 'package:flutter/material.dart';
import 'society_db.dart';
import 'view_society.dart';
import 'society_search.dart';

class AllSocieties extends StatefulWidget {
  const AllSocieties({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllSocietiesState createState() => _AllSocietiesState();
}

class _AllSocietiesState extends State<AllSocieties> {
  late Future<List<Society>> _societyList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _societyList = SocietyDB.retrieveSocieties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _pinSociety(Society society) async {
    final pinnedCount = await SocietyDB.getPinnedSocietyCount();
    if (!society.pinned && pinnedCount >= 3) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only pin up to 3 societies.')),
      );
      return;
    }
    if (society.pinned) {
      await SocietyDB.unpinSociety(society.name);
    } else {
      await SocietyDB.pinSociety(society.name);
    }
    setState(() {
      _societyList = SocietyDB.retrieveSocieties();
    });
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
          'All Societies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(0, 9, 41, 1.0),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Societies',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.lightBlue, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.lightBlue, width: 2),
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(0, 9, 41, 1.0),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightBlue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SocietySearch(query: _searchController.text),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Society>>(
                future: _societyList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No societies found.' , style: TextStyle(color: Colors.white , fontSize: 20 ),));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final society = snapshot.data![index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewSociety(society: society),
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
                                society.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    society.description,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Category: ${society.category}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  society.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                                  color: society.pinned ? Colors.yellow : Colors.white,
                                ),
                                onPressed: () {
                                  _pinSociety(society);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
