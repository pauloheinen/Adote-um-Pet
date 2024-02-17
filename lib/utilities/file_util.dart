import 'dart:convert';

import 'package:adote_um_pet/models/pet_file_entity.dart';
import 'package:adote_um_pet/models/user_file_entity.dart';
import 'package:flutter/material.dart';

class FileUtil {
  static ImageProvider getPetImage(PetFile file) {
    return _getMemoryImage(file.item);
  }

  static ImageProvider getDefaultPetImage() {
    return getAssetImage("no-image-avaliable.png");
  }

  static ImageProvider getUserImage(UserFile file) {
    return _getMemoryImage(file.item);
  }

  static ImageProvider getDefaultUserImage() {
    return getAssetImage("default-profile-photo.png");
  }

  static ImageProvider _getMemoryImage(String? file) {
    return Image.memory(const Base64Decoder().convert(file!)).image;
  }

  static ImageProvider getAssetImage(String file) {
    return Image.asset("lib/resources/$file").image;
  }

  static Image getImage(String file) {
    return Image.asset("lib/resources/$file");
  }
}
