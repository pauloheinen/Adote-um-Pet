import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(Object)? onSelect;

  const ImagePickerWidget({
    super.key,
    this.onSelect,
  });

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  void onSelect(String encoded) {
    if (widget.onSelect != null) {
      widget.onSelect?.call(encoded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Selecionar foto", style: TextStyle(fontSize: 24.0)),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(
            color: Colors.grey,
            height: 5,
            thickness: 1,
          ),
          SizedBox(
            height: 110,
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            "Galeria",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            enableFeedback: false,
                            iconSize: 50,
                            icon: const Icon(Icons.image_rounded),
                            onPressed: () async {
                              await accessGallery();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            "Câmera",
                            style: TextStyle(fontSize: 18),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            enableFeedback: false,
                            iconSize: 50,
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () async {
                              await accessCamera();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> accessGallery() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (recordedImage == null) {
      return;
    }

    callFunction(encodeImage(recordedImage));
  }

  Future<void> accessCamera() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    if (recordedImage == null) {
      return;
    }

    String path = recordedImage.path;
    GallerySaver.saveImage(path);

    callFunction(encodeImage(recordedImage));
  }

  String encodeImage(XFile recordedImage) {
    return base64Encode(File(recordedImage.path).readAsBytesSync());
  }

  void callFunction(String encoded) {
    if (widget.onSelect != null) {
      widget.onSelect!.call(encoded);
    }
  }
}
