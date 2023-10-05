import 'dart:convert';
import 'package:adote_um_pet/android/entities/user.entity.dart';
import 'package:adote_um_pet/android/services/user-file.service.dart';
import 'package:flutter/material.dart';
import '../../utilities/File/file.util.dart';

class CustomUserPhoto extends StatefulWidget {
  final User user;
  final bool editMode;
  final double photoSize;

  static const double appbarSize = 45.0;
  static const double profileSize = 120.0;

  const CustomUserPhoto({
    Key? key,
    required this.user,
    required this.editMode,
    required this.photoSize,
  }) : super(key: key);

  @override
  _CustomUserPhotoState createState() => _CustomUserPhotoState();
}

class _CustomUserPhotoState extends State<CustomUserPhoto> {
  String photo = "";

  double get effectivePhotoSize =>
      widget.photoSize == CustomUserPhoto.appbarSize
          ? CustomUserPhoto.appbarSize
          : CustomUserPhoto.profileSize;

  @override
  void initState() {
    _loadBackgroundImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: effectivePhotoSize,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              backgroundImage: showProfileImage(),
              radius: effectivePhotoSize / 2,
            ),
          ),
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
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
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
