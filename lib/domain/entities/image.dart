import 'package:flutter/material.dart';

class ImageEntity {
  final String url;
  ImageProvider? imageProvider; // Abstract property

  ImageEntity({required this.url});
}
