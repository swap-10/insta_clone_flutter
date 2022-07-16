import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_flutter/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _image;

  dynamic selectImage(source) async {
    Uint8List? image = await pickImage(source);
    setState(() {
      if (image != null) {
        _image = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: InkWell(
            child: const Icon(Icons.camera_alt_outlined),
            onTap: () {
              selectImage(ImageSource.camera);
            },
          ),
        ),
        const Divider(
          height: 16,
          thickness: 4,
        ),
        Expanded(
          child: InkWell(
            child: const Icon(Icons.file_upload_outlined),
            onTap: () {
              selectImage(ImageSource.gallery);
            },
          ),
        ),
      ],
    );
  }
}
