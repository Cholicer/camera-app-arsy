import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera_app/domain/entities/image.dart';

class ImageModel extends ImageEntity {
  ImageModel({required super.url});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      url: json['photo'] != null ? json['photo'] as String : 'https://cdn.tripster.ru/thumbs2/4db405d6-aad9-11ec-90e8-7a1d555471ec.800x600.jpeg',
    );
  }

  ImageModel.fromBase64({required String base64String}) : super(url: '') {
    // Decode the base64 string
    final decodedBytes = base64Decode(base64String);

    // Create a MemoryImage from the decoded bytes
    imageProvider = MemoryImage(decodedBytes);
  }
}
