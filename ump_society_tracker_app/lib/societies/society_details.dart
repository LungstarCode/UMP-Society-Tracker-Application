import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ump_society_tracker_app/societies/about_society.dart';
import 'package:ump_society_tracker_app/societies/society_db.dart';
import 'package:ump_society_tracker_app/societies/society_events_announcements.dart';
import 'package:ump_society_tracker_app/societies/society_gallery.dart';
import 'package:ump_society_tracker_app/societies/submit_suggestion.dart';
import 'dart:io'; // Import for File handling

class SocietyDetail extends StatefulWidget {
  final Society society;

  const SocietyDetail({super.key, required this.society});

  @override
  _SocietyDetailState createState() => _SocietyDetailState();
}

class _SocietyDetailState extends State<SocietyDetail> {
  List<SocietyGallery> galleryImages = [];

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final images = await SocietyGalleryDB.getGalleryImages(widget.society.name);
    setState(() {
      galleryImages = images;
    });
  }

  Future<void> _uploadImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(); // Allow multiple image selection

    if (images.isNotEmpty) {
      // Upload each selected image to the database
      for (var image in images) {
        final galleryItem = SocietyGallery(
          id: 0, // ID will be auto-generated
          societyName: widget.society.name,
          imageUrl: image.path,
          description: null,
          uploadDate: DateTime.now().toIso8601String(),
        );
        await SocietyGalleryDB.addGalleryItem(galleryItem);
      }
      _loadGalleryImages(); // Refresh gallery after uploading
    }
  }

  void _showImageOptions(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 500, 20, 0),
      items: [
        const PopupMenuItem<String>(
          value: 'upload',
          child: Text('Upload Image'),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Text('Delete Image'),
        ),
      ],
    ).then((value) {
      if (value == 'upload') {
        _uploadImage();
      } else if (value == 'delete') {
        // Handle delete operation
        if (galleryImages.isNotEmpty) {
          //
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.society.description,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubmitSuggestionScreen(society: widget.society),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit Suggestion',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Our Gallery',
              style: TextStyle(fontSize: 16, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              onPressed: () {
                _showImageOptions(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200, // Adjust height as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              final image = galleryImages[index];
              return Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(imageUrl: image.imageUrl),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(image.imageUrl),
                      width: 120, // Adjust width as needed
                      height: 120, // Adjust height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AboutSection(description: widget.society.description,), // Add About Section
        // Pass the adminId to ContactSection
        const SizedBox(height: 16),
        EventsAnnouncementsSection(societyId: widget.society.adminId,), // Add Events and Announcements Section
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.file(
            File(imageUrl),
          ),
        ),
      ),
    );
  }
}
