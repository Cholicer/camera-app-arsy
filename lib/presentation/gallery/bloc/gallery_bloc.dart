import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/domain/entities/image.dart';
import 'package:camera_app/domain/usecases/get_images.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetImages getImages;

  GalleryBloc({required this.getImages}) : super(GalleryInitial()) {
    on<GetImagesEvent>((event, emit) async {
      emit(GalleryLoading());
      final failureOrImages = await getImages(NoParams());
      failureOrImages.fold(
        (failure) => emit(GalleryError(message: _mapFailureToMessage(failure))),
        (images) => emit(GalleryLoaded(images: images)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      default:
        return 'Unexpected error';
    }
  }
}
