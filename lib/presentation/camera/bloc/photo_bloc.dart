import 'dart:io';

import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/domain/usecases/upload_photo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final UploadPhoto uploadPhoto;

  PhotoBloc({required this.uploadPhoto}) : super(PhotoInitial()) {
    on<UploadPhotoEvent>((event, emit) async {
      emit(PhotoLoading());
      final failureOrSuccess = await uploadPhoto(
        UploadPhotoParams(
          photo: event.photo,
          comment: event.comment,
        ),
      );
      failureOrSuccess.fold(
        (failure) {
          if (kDebugMode) {
            print("Failure type is: ${failure.runtimeType}");
          }
          emit(PhotoError(message: _mapFailureToMessage(failure)));
        },
        (_) => emit(PhotoUploaded()),
      );
    });
  }

  String _mapFailureToMessage(Failure? failure) {
    // Allow failure to be null
    if (failure == null) {
      return ''; // Return an empty string or null for success
    }

    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Error';
      case LocationFailure:
        return 'Failed to get location';
      default:
        return 'Unexpected error';
    }
  }
}
