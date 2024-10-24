// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_app/injection_container.dart';
import 'package:camera_app/presentation/camera/bloc/photo_bloc.dart';
import 'package:camera_app/presentation/camera/widgets/camera_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatefulWidget {
  final CameraDescription? camera; // Now optional
  final VoidCallback? onPhotoUploaded;
  final String? imagePath; // Optional image path

  const CameraPage({super.key, this.camera, this.onPhotoUploaded, this.imagePath});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController? _controller; // Now nullable
  late Future<void>? _initializeControllerFuture; // Now nullable
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.camera != null) {
      // Initialize camera only if camera is provided
      _controller = CameraController(
        widget.camera!,
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
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
              Navigator.pop(context);
            } else if (state is PhotoError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message!)),
              );
            }
          },
          child: widget.imagePath != null
              ? _buildCommentSection(context, widget.imagePath!)
              : FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            children: [
                              CameraPreviewWidget(
                                controller: _controller!,
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
                                  _initializeControllerFuture!.then((_) async {
                                    try {
                                      final image = await _controller!.takePicture();

                                      // After taking the picture, navigate to the same CameraPage
                                      // but with the image path
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CameraPage(
                                              imagePath: image.path,
                                              onPhotoUploaded: widget.onPhotoUploaded,
                                            ),
                                          ),
                                        );
                                      }
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

  // Separate function to build the comment section
  Widget _buildCommentSection(BuildContext context, String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Image.file(File(imagePath)),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Enter your comment',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                try {
                  context.read<PhotoBloc>().add(
                        UploadPhotoEvent(
                          photo: File(widget.imagePath!),
                          comment: _commentController.text,
                        ),
                      );
                } catch (e) {
                  if (kDebugMode) {
                    print('Upload error: $e');
                  }
                }
              },
              child: const Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
