import 'dart:io';

import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/core/usecases/usecase.dart';
import 'package:camera_app/domain/repositories/photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UploadPhoto implements UseCase<void, UploadPhotoParams> {
  final PhotoRepository repository;

  UploadPhoto(this.repository);

  @override
  Future<Either<Failure, void>> call(UploadPhotoParams params) async {
    return await repository.uploadPhoto(params.photo, params.comment);
  }
}

class UploadPhotoParams extends Equatable {
  final String comment;
  final File photo;

  const UploadPhotoParams({required this.comment, required this.photo});

  @override
  List<Object?> get props => [comment, photo];
}
