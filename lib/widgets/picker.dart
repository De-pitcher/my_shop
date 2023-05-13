import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class Picker extends StatefulWidget {
  final Color color;
  final Function(File pickedImage) imagePickFn;

  /// [Picker] is a widget that accesses the phone camera and parses
  /// the retrieved file as [FileImage]
  const Picker({super.key, required this.color, required this.imagePickFn});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  File? _pickedImage;

  Future<void> _selectImage() async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
      imageQuality: 80,
      maxWidth: 150,
    );

    if (pickedImageFile == null) return;
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    final file = File(result.files.single.path!);
    setState(() {
      _pickedImage = file;
    });
  }

  // Future<void> _selectNetworkImage() async {
  //   final url = await showDialog<String>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Enter Image URL'),
  //       content: TextField(
  //         decoration:
  //             const InputDecoration(hintText: 'https://example.com/image.jpg'),
  //         onSubmitted: (value) => Navigator.of(context).pop(value),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Cancel'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // final url = _urlController.text.trim();
  //             final url = '';
  //             if (url.isNotEmpty && Uri.parse(url).isAbsolute) {
  //               Navigator.of(context).pop(url);
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //                 content: Text('Please enter a valid URL'),
  //               ));
  //             }
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (url == null) return;
  //   await UrlLauncherPlatform.instance.canLaunch(url).then((canLaunch) {
  //     if (canLaunch) {
  //       setState(() {
  //         // _imageUrl = url;
  //       });
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         content: Text('Failed to launch URL'),
  //       ));
  //     }
  //   });
  // }

  Future<void> _pickImage() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Image Source'),
        actions: [
          TextButton(
            onPressed: _selectImage,
            child: const Text('Gallery/Camera'),
          ),
          TextButton(
            onPressed: _selectFile,
            child: const Text('File System'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _pickImage,
      child: const Text('Add Product Image'),
    );
  }
}
