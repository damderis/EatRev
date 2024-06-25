import 'package:camera/camera.dart';

class CapturedImageModel {
  XFile? imageFile;
  String? nameOfPlace;
  int? starRating;
  String? description;

  CapturedImageModel({
    this.imageFile,
    this.nameOfPlace,
    this.starRating,
    this.description,
  });
}
