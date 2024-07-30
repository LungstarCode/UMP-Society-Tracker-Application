import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import this for File

class GalleryWidget extends StatefulWidget {
  final List<XFile>? images;

  const GalleryWidget({super.key, this.images});

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  final List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    if (widget.images != null) {
      setState(() {
        _images.addAll(widget.images!);
      });
    }
  }

  void _viewImage(XFile image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(imagePath: image.path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _images.isNotEmpty
            ? SizedBox(
                height: 100, // Adjust height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    return GestureDetector(
                      onTap: () => _viewImage(image),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: Image.file(
                          File(image.path),
                          width: 100, // Adjust size as needed
                          height: 100, // Adjust size as needed
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Text('No images selected'),
      ],
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
