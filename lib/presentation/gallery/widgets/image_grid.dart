import 'package:camera_app/domain/entities/image.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageEntity> images;

  const ImageGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final imageEntity = images[index];

        return imageEntity.imageProvider != null
            ? Image(
                image: imageEntity.imageProvider!, // Access from ImageEntity
                fit: BoxFit.cover,
              )
            : const SizedBox();
      },
    );
  }
}
