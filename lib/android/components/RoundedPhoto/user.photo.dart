import 'dart:convert';
import 'dart:io';

import 'package:adote_um_pet/android/entities/user.entity.dart';
import 'package:adote_um_pet/android/services/user-file.service.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import '../../utilities/File/file.util.dart';

class CustomUserPhoto extends StatefulWidget {
  final User user;
  final bool editMode;

  CustomUserPhoto({super.key, required this.user, required this.editMode});

  @override
  State<CustomUserPhoto> createState() => _CustomUserPhotoState();
}

class _CustomUserPhotoState extends State<CustomUserPhoto> {
  String photo = "";

  @override
  void initState() {
    _loadBackgroundImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        alignment: Alignment.center,
        child: Stack(children: [
          Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                  backgroundImage: showProfileImage(), radius: 85)),
          Visibility(
              visible: widget.editMode,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: IconButton(
                      padding: const EdgeInsets.fromLTRB(85, 25, 0, 0),
                      enableFeedback: false,
                      iconSize: 40,
                      icon: const Icon(Icons.camera_alt),
                      splashColor: Colors.transparent,
                      onPressed: () {
                        changePhoto();
                      })))
        ]));
  }

  changePhoto() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: const EdgeInsets.only(top: 10.0),
              content: SizedBox(
                  width: 800.0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Selecionar foto",
                                  style: TextStyle(fontSize: 24.0))
                            ]),
                        const SizedBox(height: 5),
                        const Divider(
                            color: Colors.grey, height: 5, thickness: 1),
                        SizedBox(
                            height: 110,
                            child: Center(
                                child: Row(children: [
                                  Expanded(
                                      child: Center(
                                          child: Column(children: [
                                            const Text("Galeria",
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                                splashColor: Colors.transparent,
                                                enableFeedback: false,
                                                iconSize: 50,
                                                icon: const Icon(Icons.image_rounded),
                                                onPressed: () async {
                                                  await accessGallery();
                                                  setState(() {});
                                                })
                                          ]))),
                                  Expanded(
                                      child: Center(
                                          child: Column(children: [
                                            const Text("Câmera",
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                                splashColor: Colors.transparent,
                                                enableFeedback: false,
                                                iconSize: 50,
                                                icon: const Icon(Icons.camera_alt),
                                                onPressed: () async {
                                                  await accessCamera();
                                                  setState(() {});
                                                })
                                          ])))
                                ])))
                      ])));
        });
  }

  Future<void> accessGallery() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    String path = recordedImage!.path;

    setState(() {
      var encodedFile = base64Encode(File(path).readAsBytesSync());
      // _profileImage = encodedFile;
    });
  }

  Future<void> accessCamera() async {
    XFile? recordedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);

    String path = recordedImage!.path;
    GallerySaver.saveImage(path);

    setState(() {
      var encodedFile = base64Encode(File(path).readAsBytesSync());
      // _profileImage = encodedFile;
    });
  }

  void _loadBackgroundImage() async {
    if (widget.user.imageId != null) {
      photo = await UserFileService().getProfilePhoto(widget.user.imageId!);
    }
  }

  ImageProvider showProfileImage() {
    if (photo.isEmpty) {
      return FileUtil.getDefaultUserImage();
    }

    return Image.memory(const Base64Decoder().convert(photo)).image;
  }
}
