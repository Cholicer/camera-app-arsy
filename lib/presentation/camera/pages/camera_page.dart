import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/injection_container.dart';
import 'package:camera_app/presentation/camera/bloc/photo_bloc.dart';
import 'package:camera_app/presentation/camera/widgets/camera_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription camera;
  final VoidCallback? onPhotoUploaded;

  const CameraPage({super.key, required this.camera, this.onPhotoUploaded});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PhotoBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Take a Photo'),
        ),
        body: BlocListener<PhotoBloc, PhotoState>(
          listener: (context, state) {
            if (kDebugMode) {
              print("State is: $state");
            }
            if (state is PhotoUploaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Photo uploaded!')),
              );

              widget.onPhotoUploaded?.call();

              Navigator.pop(context);
            } else if (state is PhotoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
          },
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        CameraPreviewWidget(
                          controller: _controller,
                          constraints: constraints,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _commentController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your comment',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final bloc = context.read<PhotoBloc>(); // Access Bloc here

                            _initializeControllerFuture.then((_) async {
                              try {
                                final image = await _controller.takePicture();

                                bloc.add(
                                  UploadPhotoEvent(
                                    photo: File(image.path),
                                    comment: _commentController.text,
                                  ),
                                );
                              } catch (e) {
                                if (kDebugMode) {
                                  print('Upload error: $e');
                                }
                              }
                            });
                          },
                          child: const Text('Upload Photo'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
