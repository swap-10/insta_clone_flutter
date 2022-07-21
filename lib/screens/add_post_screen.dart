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
  bool isLoading = false;

  dynamic selectImage(source) async {
    Uint8List? image = await pickImage(source);
    setState(() {
      if (image != null) {
        _image = image;
      }
    });
  }

  dynamic removeImage() {
    isLoading = true;
    setState(() {
      if (_image != null) {
        _image = null;
      }
    });
    isLoading = false;
  }

  dynamic postImage() {
    if (isLoading == true) {
      return;
    }
    isLoading = true;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ConfirmPostPage()));
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLoading == true)
            const LinearProgressIndicator(
              color: Colors.blue,
            ),
          if (_image != null)
            Expanded(
              child: InteractiveViewer(
                child: Image(image: Image.memory(_image!).image),
              ),
              flex: 5,
            ),
          if (_image != null)
            const Divider(
              height: 16,
              thickness: 4,
            ),
          if (_image != null)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: InkWell(
                      hoverColor: Colors.red,
                      child: const Icon(Icons.cancel_outlined),
                      onTap: () {
                        removeImage();
                      },
                    ),
                  ),
                  const VerticalDivider(
                    width: 16,
                    thickness: 4,
                  ),
                  Expanded(
                    child: InkWell(
                      hoverColor: Colors.green,
                      child: const Icon(Icons.check_circle_outline),
                      onTap: () {
                        postImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          if (_image != null)
            const Divider(
              height: 16,
              thickness: 4,
            ),
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
      ),
    );
  }
}

class ConfirmPostPage extends StatelessWidget {
  const ConfirmPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Confirm Post"),
      ),
    );
  }
}
