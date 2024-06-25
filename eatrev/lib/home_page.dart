import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'captured_image_model.dart';
import 'package:image/image.dart' as img;

class HomePage extends StatefulWidget {
  final CapturedImageModel capturedImageModel;
  final Function(CapturedImageModel) onCapture;

  const HomePage({required this.capturedImageModel, required this.onCapture});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CapturedImageModel _capturedImageModel = CapturedImageModel();
  int? _selectedStarRating;
  TextEditingController _nameOfPlaceController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameOfPlaceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile picture = await _controller.takePicture();
      File imageFile = File(picture.path);
      File croppedImageFile = await _cropImageToSquare(imageFile);

      setState(() {
        _capturedImageModel.imageFile = XFile(croppedImageFile.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  Future<File> _cropImageToSquare(File imageFile) async {
    img.Image originalImage = img.decodeImage(await imageFile.readAsBytes())!;
    int shortestSide = originalImage.width > originalImage.height
        ? originalImage.height
        : originalImage.width;
    int xCenter = originalImage.width ~/ 2;
    int yCenter = originalImage.height ~/ 2;

    img.Image croppedImage = img.copyCrop(
      originalImage,
      xCenter - shortestSide ~/ 2,
      yCenter - shortestSide ~/ 2,
      shortestSide,
      shortestSide,
    );

    File croppedImageFile = await imageFile.writeAsBytes(img.encodeJpg(croppedImage));
    return croppedImageFile;
  }

  void _submitReview() {
    if (_capturedImageModel.imageFile != null) {
      widget.onCapture(_capturedImageModel);
      Fluttertoast.showToast(
        msg: "Successfully shared your review",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      setState(() {
        _capturedImageModel = CapturedImageModel();
        _selectedStarRating = null;
        _nameOfPlaceController.clear();
        _descriptionController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('No Picture Taken'),
          content: Text('Please take a picture before submitting.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EatRev', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _capturedImageModel.imageFile != null
                              ? Image.file(File(_capturedImageModel.imageFile!.path))
                              : CameraPreview(_controller),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _takePicture,
                  icon: Icon(Icons.camera),
                  iconSize: 40,
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameOfPlaceController,
              onChanged: (value) {
                _capturedImageModel.nameOfPlace = value;
              },
              decoration: InputDecoration(
                labelText: 'Name of Place',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _selectedStarRating,
              items: List.generate(5, (index) {
                return DropdownMenuItem(
                  value: index + 1,
                  child: Text('${index + 1} Star'),
                );
              }),
              onChanged: (value) {
                setState(() {
                  _selectedStarRating = value;
                  _capturedImageModel.starRating = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Star Rating',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              onChanged: (value) {
                _capturedImageModel.description = value;
              },
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitReview,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
