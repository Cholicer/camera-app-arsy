import 'dart:convert';
import 'dart:io';

import 'package:camera_app/core/errors/exceptions.dart';
import 'package:camera_app/core/errors/failures.dart';
import 'package:camera_app/data/datasources/camera_local_data_source.dart';
import 'package:camera_app/data/datasources/location_local_data_source.dart';
import 'package:camera_app/data/models/image_model.dart';
import 'package:camera_app/data/models/photo_request_model.dart';
import 'package:camera_app/domain/entities/image.dart';
import 'package:camera_app/domain/repositories/photo_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PhotoRepositoryImpl implements PhotoRepository {
  final CameraLocalDataSource cameraLocalDataSource;
  final LocationLocalDataSource locationLocalDataSource;
  final http.Client client;
  static const String baseUrl = 'https://crudcrud.com/api/ff4d36fbae684bb182ca7d025da2e004/gallery';

  PhotoRepositoryImpl({
    required this.cameraLocalDataSource,
    required this.locationLocalDataSource,
    required this.client,
  });

  @override
  Future<Either<Failure, void>> uploadPhoto(File photo, String comment) async {
    try {
      final location = await locationLocalDataSource.getCurrentLocation();
      final photoRequestModel = PhotoRequestModel(
        comment: comment,
        latitude: location.latitude,
        longitude: location.longitude,
        photo: photo,
      );
      await _uploadPhotoData(photoRequestModel);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    } on LocationException {
      return Left(LocationFailure());
    }
  }

  Future<void> _uploadPhotoData(PhotoRequestModel photoRequest) async {
    final bytes = await photoRequest.photo.readAsBytes();
    final base64Image = base64Encode(bytes);

    final data = {
      'comment': photoRequest.comment,
      'latitude': photoRequest.latitude.toString(),
      'longitude': photoRequest.longitude.toString(),
      'photo': base64Image, // Include base64 image in JSON
    };

    final url = Uri.parse(baseUrl);

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data), // Encode data as JSON
    );

    if (kDebugMode) {
      print("response.statusCode is: ${response.statusCode}");
    }

    // Check for a successful status code range (200-299)
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException();
    }
  }

  // Future<void> _uploadPhotoData(PhotoRequestModel photoRequest) async {
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse(baseUrl),
  //   );

  //   // Add the image file as a multipart file
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'photo', // This should match the field name your server expects
  //       photoRequest.photo.path,
  //     ),
  //   );

  //   // Add other fields as string parameters
  //   request.fields['comment'] = photoRequest.comment;
  //   request.fields['latitude'] = photoRequest.latitude.toString();
  //   request.fields['longitude'] = photoRequest.longitude.toString();

  //   try {
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     if (kDebugMode) {
  //       print("Response status code: ${response.statusCode}");
  //       print("Response body: ${response.body}");
  //     }

  //     if (response.statusCode < 200 || response.statusCode >= 300) {
  //       throw ServerException();
  //     }
  //   } on SocketException catch (e) {
  //     if (kDebugMode) {
  //       print("SocketException during upload: ${e.toString()}");
  //     }
  //     throw ServerException();
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Error during upload: ${e.toString()}");
  //     }
  //     throw ServerException();
  //   }
  // }

  @override
  Future<Either<Failure, List<ImageEntity>>> getImages() async {
    try {
      // Replace with your actual server endpoint for fetching images
      final url = Uri.parse(baseUrl);
      final response = await client.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<ImageEntity> images = data
            .map((imageJson) => ImageModel.fromBase64(
                  base64String: imageJson['photo'], // Assuming 'photo' holds base64
                ))
            .toList();
        return Right(images);
      } else {
        throw ServerException();
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
