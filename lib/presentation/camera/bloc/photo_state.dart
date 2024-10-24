part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object?> get props => [];
}

class PhotoInitial extends PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoUploaded extends PhotoState {}

class PhotoError extends PhotoState {
  final String? message;

  const PhotoError({required this.message});

  @override
  List<Object?> get props => [message];
}
