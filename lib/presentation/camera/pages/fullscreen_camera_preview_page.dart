// // ignore_for_file: use_build_context_synchronously

// import 'package:camera/camera.dart';
// import 'package:camera_app/presentation/camera/pages/camera_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// class FullscreenCameraPreviewPage extends StatefulWidget {
//   final CameraDescription camera;
//   final VoidCallback? onPhotoUploaded; // Add this property

//   const FullscreenCameraPreviewPage({super.key, required this.camera, this.onPhotoUploaded});

//   @override
//   State<FullscreenCameraPreviewPage> createState() => _FullscreenCameraPreviewPageState();
// }

// class _FullscreenCameraPreviewPageState extends State<FullscreenCameraPreviewPage> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(
//       widget.camera,
//       ResolutionPreset.medium,
//     );
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Center(
//               child: CameraPreview(_controller),
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             final image = await _controller.takePicture();

//             // Navigate to the comment page and pass the image
//             if (mounted) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CameraPage(
//                     imagePath: image.path,
//                     onPhotoUploaded: widget.onPhotoUploaded,
//                   ),
//                 ),
//               );
//             }
//           } catch (e) {
//             if (kDebugMode) {
//               print('Error taking picture: $e');
//             }
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }
