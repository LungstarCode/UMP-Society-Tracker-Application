import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:ump_society_tracker_app/societies/gallery_widget.dart';
import 'package:ump_society_tracker_app/societies/join_society.dart';

import '../societies/society_db.dart'; // Import for XFile

class WidgetHavenDB extends StatefulWidget {
  final Society society;

  const WidgetHavenDB({super.key, required this.society});

  @override
  _WidgetHavenDBState createState() => _WidgetHavenDBState();
}

class _WidgetHavenDBState extends State<WidgetHavenDB> {
  final List<Widget> _availableWidgets = [];
  final List<Widget> _selectedWidgets = [];

  @override
  void initState() {
    super.initState();
    _availableWidgets.add(
      ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JoinSociety(),
            ),
          );
        },
        child: const Text('Join Society'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
    _availableWidgets.add(
      ElevatedButton(
        onPressed: () async {
          final ImagePicker picker = ImagePicker();
          final List<XFile>? pickedImages = await picker.pickMultiImage();
          if (pickedImages != null) {
            _addWidgetToCanvas(GalleryWidget(images: pickedImages));
          }
        },
        child: const Text('Gallery'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _addWidgetToCanvas(Widget widget) {
    setState(() {
      _selectedWidgets.add(widget);
    });
  }

  void _removeWidgetFromCanvas(Widget widget) {
    setState(() {
      _selectedWidgets.remove(widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
        title: const Text(
          'Widget Haven',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, _selectedWidgets);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _availableWidgets.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: _availableWidgets[index],
                  trailing: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => _addWidgetToCanvas(_availableWidgets[index]),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Selected Widgets',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedWidgets.length,
              itemBuilder: (context, index) {
                final widget = _selectedWidgets[index];
                return ListTile(
                  title: widget,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeWidgetFromCanvas(widget),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(0, 0, 41, 1.0),
    );
  }
}
