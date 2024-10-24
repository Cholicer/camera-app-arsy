import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/core/usecases/usecase.dart';
import 'package:camera_app/domain/entities/image.dart';
import 'package:camera_app/domain/repositories/photo_repository.dart';
import 'package:dartz/dartz.dart';

class GetImages implements UseCase<List<ImageEntity>, NoParams> {
  final PhotoRepository repository;

  GetImages(this.repository);

  @override
  Future<Either<Failure, List<ImageEntity>>> call(NoParams params) async {
    return await repository.getImages();
  }
}

class NoParams {}
