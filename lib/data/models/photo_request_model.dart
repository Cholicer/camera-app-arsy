import 'package:camera_app/domain/entities/photo_request.dart';

class PhotoRequestModel extends PhotoRequest {
  const PhotoRequestModel({
    required super.comment,
    required super.latitude,
    required super.longitude,
    required super.photo,
  });
}
