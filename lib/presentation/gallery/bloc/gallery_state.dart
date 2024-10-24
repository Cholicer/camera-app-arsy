part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {}

class GalleryLoading extends GalleryState {}

class GalleryLoaded extends GalleryState {
  final List<ImageEntity> images;

  const GalleryLoaded({required this.images});

  @override
  List<Object?> get props => [images];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError({required this.message});

  @override
  List<Object?> get props => [message];
}
