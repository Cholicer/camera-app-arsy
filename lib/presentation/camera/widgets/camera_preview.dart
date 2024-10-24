import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final BoxConstraints constraints;

  const CameraPreviewWidget({super.key, required this.controller, required this.constraints});

  @override
  Widget build(BuildContext context) {
    // Calculate preview size based on constraints
    double previewWidth = constraints.maxWidth;
    double previewHeight = previewWidth / controller.value.aspectRatio;

    return SizedBox(
      width: previewWidth,
      height: previewHeight,
      child: CameraPreview(controller),
    );
  }
}
