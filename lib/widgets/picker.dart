import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_shop/helpers/url_extension.dart';

class Picker extends StatefulWidget {
  final Color color;
  final bool isText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String?)? onSaved;
  final Function(String) imagePickFn;

  /// [Picker] is a widget that accesses the phone camera and parses
  /// the retrieved file as [FileImage]
  const Picker({
    super.key,
    required this.color,
    required this.imagePickFn,
    required this.isText,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
  });

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  String? _fileImage;
  Future<void> _selectImage() async {
    final pickedImageFile = await ImagePicker()
        .pickImage(
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
    )
        .catchError((err) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Couldn\'t get because $err')));
      return null;
    });

    if (pickedImageFile == null) return;
    setState(() {
      widget.imagePickFn(pickedImageFile.path);
    });
  }

  Future<void> _selectNetworkImage(String? imageUrl) async {
    if (imageUrl == null) return;
    // final url = Uri.parse(imageUrl);
    try {
      final response = await Dio().get(imageUrl);
      if (response.statusCode == 200) {
        setState(() {
          _fileImage = imageUrl;
        });
      } else {
        setState(() {
          _fileImage = null;
        });
      }
    } catch (error) {
      setState(() {
        _fileImage = null;
      });
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to launch URL'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width * 0.8,
          margin: const EdgeInsets.only(top: 8, right: 8),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _fileImage == null
              ? const Center(child: Text('Image Preview'))
              : FittedBox(
                  child: widget.isText
                      ? Image.file(
                          File(_fileImage!),
                          fit: BoxFit.cover,
                        )
                      : Image.network(_fileImage!),
                ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: _selectImage,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor),
              child: const Text('Add Product Image'),
            ),
          ),
          secondChild: SizedBox(
            height: 60,
            child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(labelText: 'Input URL'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                focusNode: widget.focusNode,
                // onFieldSubmitted: widget.onFieldSubmitted,
                onFieldSubmitted: (value) => _selectNetworkImage(value),
                style: const TextStyle(color: Colors.black),
                // onChanged: (value) => _selectNetworkImage(value),
                validator: (value) =>
                    value!.isValidUrl() ? null : 'Not a valid url',
                onSaved: (val) {
                  widget.onSaved;
                }),
          ),
          crossFadeState: widget.isText
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
