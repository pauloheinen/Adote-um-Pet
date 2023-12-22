import 'dart:convert';

import 'package:adote_um_pet/android/models/pet_file_entity.dart';
import 'package:flutter/material.dart';

import '../../models/user_file_entity.dart';

class FileUtil {
  static ImageProvider getPetImage(PetFile file) {
    return _getMemoryImage(file.item);
  }

  static ImageProvider getDefaultPetImage() {
    return _getAssetImage("lib/resources/no-image-avaliable.png");
  }

  static ImageProvider getUserImage(UserFile file) {
    return _getMemoryImage(file.item);
  }

  static ImageProvider getDefaultUserImage() {
    return _getAssetImage("lib/resources/default-profile-photo.png");
  }

  static ImageProvider _getMemoryImage(String? file) {
    return Image.memory(const Base64Decoder().convert(file!)).image;
  }

  static ImageProvider _getAssetImage(String file) {
    return Image.asset(file).image;
  }
}
