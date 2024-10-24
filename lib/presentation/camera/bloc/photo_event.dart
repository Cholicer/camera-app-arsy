part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object?> get props => [];
}

class UploadPhotoEvent extends PhotoEvent {
  final File photo;
  final String comment;

  const UploadPhotoEvent({required this.photo, required this.comment});

  @override
  List<Object?> get props => [photo, comment];
}
