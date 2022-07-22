import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_flutter/utils/colors.dart';
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
      showSnackBar("Please wait. Loading...", Colors.blue, context);
      return;
    }
    if (_image == null) {
      return;
    }
    isLoading = true;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ConfirmPostScreen(
              image: _image!,
            )));
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InteractiveViewer(
                  child: Image(image: Image.memory(_image!).image),
                ),
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

class ConfirmPostScreen extends StatefulWidget {
  final Uint8List image;

  const ConfirmPostScreen({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ConfirmPostScreen> createState() => _ConfirmPostScreenState();
}

class _ConfirmPostScreenState extends State<ConfirmPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mobileBackgroundColor,
        title: const Text("New Post"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => (Navigator.of(context).pop()),
        ),
        actions: [
          InkWell(
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text("Post")),
            ),
            onTap: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InteractiveViewer(
                  child: Image(
                image: Image.memory(widget.image).image,
              )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  label: const Text("Caption"),
                  hintText: "Add caption",
                  border: OutlineInputBorder(
                    borderSide: Divider.createBorderSide(context),
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                minLines: null,
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
