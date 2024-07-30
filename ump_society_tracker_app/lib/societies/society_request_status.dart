import 'package:flutter/material.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
 // Adjust as per your project structure

class SocietyRequestStatus extends StatefulWidget {
  const SocietyRequestStatus({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocietyRequestStatusState createState() => _SocietyRequestStatusState();
}

class _SocietyRequestStatusState extends State<SocietyRequestStatus> {
  late Future<List<SocietyRequest>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = SocietyDB.retrieveSocietyRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Society Request Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background
        iconTheme: const IconThemeData(color: Colors.white), // White back leading icon
      ),
      body: Container(
        color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background for the body
        child: FutureBuilder<List<SocietyRequest>>(
          future: _requests,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No society requests.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  SocietyRequest request = snapshot.data![index];
                  return _buildRequestCard(request);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRequestCard(SocietyRequest request) {
    Color statusColor;
    IconData statusIcon;

    switch (request.status) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.timer;
        break;
      case 'Approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.lightBlueAccent), // Sky blue outline
      ),
      color: const Color.fromRGBO(0, 0, 41, 1.0), // Dark blue background for the card
      elevation: 2,
      child: ListTile(
        title: Text(
          request.name,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text(request.description, style: const TextStyle(color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              statusIcon,
              color: statusColor,
            ),
            const SizedBox(width: 4),
            Text(
              request.status,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
