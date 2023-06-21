import 'dart:convert';

import 'package:flutter/material.dart';

class User {
  final int? id;
  final String? name;
  final String? password;
  final String? email;
  final String? phone;
  final String? image;

  const User({
    this.id,
    required this.name,
    required this.password,
    required this.email,
    required this.phone,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      password: json['password'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['password'] = password;
    data['email'] = email;
    data['phone'] = phone;
    data['image'] = image.toString();

    return data;
  }

  ImageProvider loadProfileImage() {
    if (image.toString().isNotEmpty) {
      return Image.asset("lib/resources/default-profile-photo.png").image;
    } else {
      return Image.memory(const Base64Decoder().convert(image!)).image;
    }
  }
}
