import 'package:camera/camera.dart';
import 'package:camera_app/presentation/camera/pages/camera_page.dart';
import 'package:camera_app/presentation/gallery/bloc/gallery_bloc.dart';
import 'package:camera_app/presentation/gallery/widgets/image_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GalleryPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const GalleryPage({super.key, required this.cameras});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  void initState() {
    super.initState();
    // Access the bloc and add the event to load images
    context.read<GalleryBloc>().add(GetImagesEvent());
  }

  // Function to refresh the gallery
  void _refreshGallery() {
    context.read<GalleryBloc>().add(GetImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshGallery();
        },
        child: BlocBuilder<GalleryBloc, GalleryState>(
          builder: (context, state) {
            if (state is GalleryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GalleryLoaded) {
              return ImageGrid(images: state.images);
            } else if (state is GalleryError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unexpected error'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(
                camera: widget.cameras.first,
                onPhotoUploaded: _refreshGallery,
              ),
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
