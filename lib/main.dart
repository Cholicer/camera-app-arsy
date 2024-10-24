import 'package:camera/camera.dart';
import 'package:camera_app/injection_container.dart' as di;
import 'package:camera_app/presentation/camera/bloc/photo_bloc.dart';
import 'package:camera_app/presentation/gallery/bloc/gallery_bloc.dart';
import 'package:camera_app/presentation/gallery/pages/gallery_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Or BlocProvider if you only have one bloc
      providers: [
        BlocProvider<GalleryBloc>(
          create: (context) => di.sl<GalleryBloc>(),
        ),
        BlocProvider<PhotoBloc>(
          // Make sure PhotoBloc is provided
          create: (context) => di.sl<PhotoBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Camera App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: GalleryPage(cameras: cameras),
      ),
    );
  }
}
