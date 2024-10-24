import 'dart:io';

import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/domain/entities/image.dart';
import 'package:dartz/dartz.dart';

abstract class PhotoRepository {
  Future<Either<Failure, void>> uploadPhoto(File photo, String comment);

  Future<Either<Failure, List<ImageEntity>>> getImages();
}
