import 'package:camera_app/data/datasources/camera_local_data_source.dart';
import 'package:camera_app/data/datasources/location_local_data_source.dart';
import 'package:camera_app/data/repositories/photo_repository_impl.dart';
import 'package:camera_app/domain/repositories/photo_repository.dart';
import 'package:camera_app/domain/usecases/get_images.dart';
import 'package:camera_app/domain/usecases/upload_photo.dart';
import 'package:camera_app/presentation/camera/bloc/photo_bloc.dart';
import 'package:camera_app/presentation/gallery/bloc/gallery_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => GalleryBloc(getImages: sl()));
  sl.registerFactory(() => PhotoBloc(uploadPhoto: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetImages(sl()));
  sl.registerLazySingleton(() => UploadPhoto(sl()));

  // Repository
  sl.registerLazySingleton<PhotoRepository>(() => PhotoRepositoryImpl(
        cameraLocalDataSource: sl(),
        locationLocalDataSource: sl(),
        client: sl(),
      ));

  // Data sources
  sl.registerLazySingleton<CameraLocalDataSource>(() => CameraLocalDataSourceImpl());
  sl.registerLazySingleton<LocationLocalDataSource>(() => LocationLocalDataSourceImpl(location: sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Location());
}
