import 'dart:io';

class PhotoRequest {
  final String comment;
  final double? latitude;
  final double? longitude;
  final File photo;

  const PhotoRequest({
    required this.comment,
    required this.latitude,
    required this.longitude,
    required this.photo,
  });
}
